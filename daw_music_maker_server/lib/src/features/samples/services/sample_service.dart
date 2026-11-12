import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../../core/validation/validation_rules.dart';
import '../../../generated/protocol.dart';
import '../../projects/services/project_access_service.dart';
import '../../projects/services/project_rules.dart';
import '../mappers/sample_mapper.dart';
import '../repositories/samples_repository.dart';
import 'audio_inspector.dart';

/// Audio uploads: tickets, verification, listing (with temporary download
/// URLs) and deletion. Files live in the private storage under a
/// server-generated path; clients never choose paths.
class SampleService {
  /// Creates the service.
  const SampleService();

  /// Storage holding sample files.
  static const storageId = 'private';

  /// How long download URLs stay valid.
  static const downloadUrlLifetime = Duration(hours: 12);

  static const _samples = SamplesRepository();
  static const _access = ProjectAccessService();

  /// Storage path of an upload (derived from trusted values only).
  static String storagePath(
    UuidValue projectId,
    UuidValue uploadId,
    AudioFormat format,
  ) => 'projects/$projectId/samples/$uploadId.${format.name}';

  /// Validates the file name and size, and issues an upload description
  /// limited to that size (≤ 10 MB) for a fresh server-generated path.
  Future<SampleUploadTicket> requestUpload(
    Session session,
    UuidValue userId,
    RequestSampleUploadRequest request,
  ) async {
    await _requireEditor(session, request.projectId, userId);
    final format = _validateFile(request.fileName, request.sizeBytes);
    if (await _samples.count(session, request.projectId) >=
        ValidationRules.samplesMax) {
      throw AppException(
        code: ErrorCode.limitReached,
        message:
            'A project can have at most ${ValidationRules.samplesMax} samples',
      );
    }
    final uploadId = const Uuid().v4obj();
    final description = await session.storage.createUploadDescription(
      storageId: storageId,
      path: storagePath(request.projectId, uploadId, format),
      options: UploadOptions(
        maxFileSize: ValidationRules.sampleMaxBytes,
        contentLength: request.sizeBytes,
        preventOverwrite: true,
      ),
    );
    return SampleUploadTicket(
      uploadId: uploadId,
      uploadDescription: description,
    );
  }

  /// Verifies the uploaded file (exists, ≤ 10 MB, bytes match the format)
  /// and registers it. WAV files get their duration and waveform here.
  ///
  /// Invalid files are deleted from storage and rejected with
  /// [ErrorCode.validation].
  Future<SampleResponse> finishUpload(
    Session session,
    UuidValue userId,
    FinishSampleUploadRequest request,
  ) async {
    await _requireEditor(session, request.projectId, userId);
    final format = AudioInspector.formatFromName(request.fileName);
    if (format == null) throw _invalid('Unsupported file type');
    final path = storagePath(request.projectId, request.uploadId, format);

    final existing = await _samples.findByPath(session, path);
    if (existing != null) {
      return existing.toResponse(url: await _url(session, existing));
    }
    final uploaded = await session.storage.verifyUpload(
      storageId: storageId,
      path: path,
    );
    if (!uploaded) throw _invalid('The upload did not complete');

    final data = await session.storage.retrieveFile(
      storageId: storageId,
      path: path,
    );
    final bytes = Uint8List.sublistView(data);
    if (bytes.isEmpty ||
        bytes.length > ValidationRules.sampleMaxBytes ||
        !AudioInspector.matchesFormat(bytes, format)) {
      await session.storage.deleteFile(storageId: storageId, path: path);
      throw _invalid('The file is not a valid ${format.name.toUpperCase()}');
    }

    final wav = format == AudioFormat.wav
        ? AudioInspector.inspectWav(bytes)
        : null;
    final clientDuration = request.durationMs;
    final durationMs =
        wav?.durationMs ??
        (clientDuration != null &&
                clientDuration >= 0 &&
                clientDuration <= ValidationRules.sampleMaxDurationMs
            ? clientDuration
            : null);

    final sample = await _samples.insert(
      session,
      Sample(
        projectId: request.projectId,
        name: AudioInspector.displayName(request.fileName),
        format: format,
        sizeBytes: bytes.length,
        durationMs: durationMs,
        peaks: wav?.peaks,
        storagePath: path,
        uploadedById: userId,
      ),
    );
    return sample.toResponse(url: await _url(session, sample));
  }

  /// Samples of a visible project with fresh download URLs.
  Future<List<SampleResponse>> list(
    Session session,
    UuidValue userId,
    UuidValue projectId,
  ) async {
    await _access.load(session, projectId, userId);
    final rows = await _samples.listForProject(session, projectId);
    return [for (final s in rows) s.toResponse(url: await _url(session, s))];
  }

  /// Deletes a sample, its file, and the channels / clips that use it.
  Future<void> delete(
    Session session,
    UuidValue userId,
    UuidValue sampleId,
  ) async {
    final sample = await _samples.findById(session, sampleId);
    if (sample == null) throw AppException(code: ErrorCode.notFound);
    await _requireEditor(session, sample.projectId, userId);
    await _samples.delete(session, sample);
    try {
      await session.storage.deleteFile(
        storageId: storageId,
        path: sample.storagePath,
      );
    } catch (e, st) {
      // The row is gone; a leftover file is harmless but worth logging.
      session.log(
        'Failed to delete sample file',
        level: LogLevel.warning,
        exception: e,
        stackTrace: st,
      );
    }
  }

  /// Validates name and size; returns the format.
  static AudioFormat _validateFile(String fileName, int sizeBytes) {
    final format = AudioInspector.formatFromName(fileName);
    if (format == null) {
      throw _invalid('Use a WAV, MP3, OGG or FLAC file', field: 'fileName');
    }
    if (fileName.trim().length > ValidationRules.sampleFileNameMaxLength) {
      throw _invalid('The file name is too long', field: 'fileName');
    }
    if (sizeBytes <= 0 || sizeBytes > ValidationRules.sampleMaxBytes) {
      throw _invalid('Files must be at most 10 MB', field: 'sizeBytes');
    }
    return format;
  }

  static AppException _invalid(String message, {String field = 'file'}) =>
      AppException(
        code: ErrorCode.validation,
        message: message,
        fieldErrors: {field: message},
      );

  Future<String> _url(Session session, Sample sample) async {
    final uri = await session.storage.temporaryDownloadUrl(
      storageId: storageId,
      path: sample.storagePath,
      options: const TemporaryDownloadUrlOptions(
        expirationDuration: downloadUrlLifetime,
      ),
    );
    return uri.toString();
  }

  Future<void> _requireEditor(
    Session session,
    UuidValue projectId,
    UuidValue userId,
  ) async {
    final (_, access) = await _access.load(session, projectId, userId);
    if (!ProjectRules.canEditDetails(access)) {
      throw AppException(
        code: ErrorCode.forbidden,
        message: 'You cannot change the samples of this project',
      );
    }
  }
}
