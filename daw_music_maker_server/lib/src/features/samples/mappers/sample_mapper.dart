import '../../../generated/protocol.dart';

/// Entity → response mapping for samples.
extension SampleMapper on Sample {
  /// Maps to a [SampleResponse] with a download [url].
  SampleResponse toResponse({required String url}) => SampleResponse(
    id: id!,
    projectId: projectId,
    name: name,
    format: format,
    sizeBytes: sizeBytes,
    durationMs: durationMs,
    peaks: peaks,
    url: url,
    createdAt: createdAt,
  );
}
