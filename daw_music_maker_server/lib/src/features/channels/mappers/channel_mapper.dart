import '../../../generated/protocol.dart';

/// Entity → response mapping for channels.
extension ChannelMapper on Channel {
  /// Maps to a [ChannelResponse].
  ChannelResponse toResponse() => ChannelResponse(
    id: id!,
    projectId: projectId,
    name: name,
    sample: sample,
    sampleId: sampleId,
    volume: volume,
    muted: muted,
    pan: pan,
    pitch: pitch,
    startFrac: startFrac,
    endFrac: endFrac,
    position: position,
  );
}
