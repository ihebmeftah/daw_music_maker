import '../../../generated/protocol.dart';

/// Entity → response mapping for playlist clips.
extension ClipMapper on PlaylistClip {
  /// Maps to a [ClipResponse].
  ClipResponse toResponse() => ClipResponse(
    id: id!,
    patternId: patternId,
    sampleId: sampleId,
    lengthBars: lengthBars,
    track: track,
    startBar: startBar,
  );
}
