import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/error_mapper.dart';
import 'studio_clip.dart';
import 'studio_note.dart';
import 'studio_repository.dart';

/// [StudioRepository] backed by the server's `project` endpoint.
@LazySingleton(as: StudioRepository)
class StudioRepositoryImpl implements StudioRepository {
  /// Creates the repository.
  StudioRepositoryImpl(
    this._endpoint,
    this._patterns,
    this._channels,
    this._playlist,
    this._samples,
  );

  /// Bytes sent per chunk while uploading (progress granularity).
  static const uploadChunkBytes = 64 * 1024;

  final EndpointProject _endpoint;
  final EndpointPattern _patterns;
  final EndpointChannel _channels;
  final EndpointPlaylist _playlist;
  final EndpointSample _samples;

  @override
  Future<ProjectResponse> loadProject(UuidValue projectId) =>
      _guard(() => _endpoint.getById(projectId));

  @override
  Future<ProjectResponse> saveTempo(UuidValue projectId, double bpm) => _guard(
    () => _endpoint.updateTempo(
      projectId,
      UpdateProjectTempoRequest(bpm: bpm),
    ),
  );

  @override
  Future<List<PatternResponse>> listPatterns(UuidValue projectId) =>
      _guard(() => _patterns.list(projectId));

  @override
  Future<PatternResponse> createPattern(UuidValue projectId) => _guard(
    () => _patterns.create(CreatePatternRequest(projectId: projectId)),
  );

  @override
  Future<PatternResponse> updatePattern(
    UuidValue patternId, {
    required String name,
    required int colorIndex,
    required int lengthBars,
  }) => _guard(
    () => _patterns.update(
      patternId,
      UpdatePatternRequest(
        name: name.trim(),
        colorIndex: colorIndex,
        lengthBars: lengthBars,
      ),
    ),
  );

  @override
  Future<PatternResponse> clonePattern(UuidValue patternId) =>
      _guard(() => _patterns.clone(patternId));

  @override
  Future<void> deletePattern(UuidValue patternId) =>
      _guard(() => _patterns.delete(patternId));

  @override
  Future<List<ChannelResponse>> listChannels(UuidValue projectId) =>
      _guard(() => _channels.list(projectId));

  @override
  Future<ChannelResponse> createChannel(
    UuidValue projectId, {
    SampleKind? sample,
    UuidValue? sampleId,
  }) => _guard(
    () => _channels.create(
      CreateChannelRequest(
        projectId: projectId,
        sample: sample,
        sampleId: sampleId,
      ),
    ),
  );

  @override
  Future<ChannelResponse> updateChannel(
    UuidValue channelId, {
    required String name,
    required double volume,
    required bool muted,
    double pan = 0,
    int pitch = 0,
    double startFrac = 0,
    double endFrac = 1,
  }) => _guard(
    () => _channels.update(
      channelId,
      UpdateChannelRequest(
        name: name.trim(),
        volume: volume,
        muted: muted,
        pan: pan,
        pitch: pitch,
        startFrac: startFrac,
        endFrac: endFrac,
      ),
    ),
  );

  @override
  Future<List<ChannelResponse>> chopChannel(UuidValue channelId, int slices) =>
      _guard(
        () => _channels.chop(channelId, ChopChannelRequest(slices: slices)),
      );

  @override
  Future<List<SampleResponse>> listSamples(UuidValue projectId) =>
      _guard(() => _samples.list(projectId));

  @override
  Future<SampleResponse> uploadSample(
    UuidValue projectId, {
    required String fileName,
    required Uint8List bytes,
    void Function(double progress)? onProgress,
  }) => _guard(() async {
    final ticket = await _samples.requestUpload(
      RequestSampleUploadRequest(
        projectId: projectId,
        fileName: fileName,
        sizeBytes: bytes.length,
      ),
    );
    final uploaded = await FileUploader(
      ticket.uploadDescription,
    ).upload(_chunks(bytes, onProgress), bytes.length);
    if (!uploaded) {
      throw const ServerpodClientNetworkException('Upload failed');
    }
    onProgress?.call(1);
    return _samples.finishUpload(
      FinishSampleUploadRequest(
        projectId: projectId,
        uploadId: ticket.uploadId,
        fileName: fileName,
      ),
    );
  });

  /// Streams [bytes] in chunks, reporting the share already handed over.
  static Stream<List<int>> _chunks(
    Uint8List bytes,
    void Function(double progress)? onProgress,
  ) async* {
    for (var offset = 0; offset < bytes.length; offset += uploadChunkBytes) {
      final end = math.min(offset + uploadChunkBytes, bytes.length);
      yield Uint8List.sublistView(bytes, offset, end);
      onProgress?.call(end / bytes.length * 0.99);
    }
  }

  @override
  Future<void> deleteSample(UuidValue sampleId) =>
      _guard(() => _samples.delete(sampleId));

  @override
  Future<void> deleteChannel(UuidValue channelId) =>
      _guard(() => _channels.delete(channelId));

  @override
  Future<List<StudioClip>> listClips(UuidValue projectId) => _guard(
    () async => [
      for (final c in await _playlist.list(projectId))
        StudioClip.fromResponse(c),
    ],
  );

  @override
  Future<List<StudioClip>> saveClips(
    UuidValue projectId,
    List<StudioClip> clips,
  ) => _guard(
    () async => [
      for (final c in await _playlist.save(
        projectId,
        SavePlaylistRequest(clips: [for (final c in clips) c.toInput()]),
      ))
        StudioClip.fromResponse(c),
    ],
  );

  @override
  Future<List<StudioNote>> listNotes(UuidValue patternId) => _guard(
    () async => [
      for (final n in await _patterns.listNotes(patternId))
        StudioNote.fromResponse(n),
    ],
  );

  @override
  Future<List<StudioNote>> saveNotes(
    UuidValue patternId,
    List<StudioNote> notes,
  ) => _guard(
    () async => [
      for (final n in await _patterns.saveNotes(
        patternId,
        SavePatternNotesRequest(notes: [for (final n in notes) n.toInput()]),
      ))
        StudioNote.fromResponse(n),
    ],
  );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw mapGenericError(error);
    }
  }
}
