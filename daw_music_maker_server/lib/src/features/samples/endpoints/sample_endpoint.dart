import 'package:serverpod/serverpod.dart';

import '../../../core/security/auth_guard.dart';
import '../../../generated/protocol.dart';
import '../services/sample_service.dart';

/// Audio uploads of a project (`client.sample`).
///
/// Upload flow: [requestUpload] → `FileUploader(ticket.uploadDescription)`
/// → [finishUpload]. Requires a signed-in user; listing needs the project to
/// be visible, changes need owner or write access. Throws [AppException]:
/// [ErrorCode.notFound], [ErrorCode.forbidden], [ErrorCode.validation]
/// (type, size > 10 MB, bytes not matching the format),
/// [ErrorCode.limitReached] (64 samples).
class SampleEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _service = SampleService();

  /// Issues an upload description for one file (WAV/MP3/OGG/FLAC, ≤ 10 MB).
  Future<SampleUploadTicket> requestUpload(
    Session session,
    RequestSampleUploadRequest request,
  ) => _service.requestUpload(session, session.requireUserId, request);

  /// Verifies and registers an uploaded file.
  Future<SampleResponse> finishUpload(
    Session session,
    FinishSampleUploadRequest request,
  ) => _service.finishUpload(session, session.requireUserId, request);

  /// Samples of a project, newest first, with 12-hour download URLs.
  Future<List<SampleResponse>> list(Session session, UuidValue projectId) =>
      _service.list(session, session.requireUserId, projectId);

  /// Deletes a sample and the channels / playlist clips using it.
  Future<void> delete(Session session, UuidValue sampleId) =>
      _service.delete(session, session.requireUserId, sampleId);
}
