import '../../../generated/protocol.dart';

/// Entity → response mapping for pattern notes.
extension NoteMapper on PatternNote {
  /// Maps to a [NoteResponse].
  NoteResponse toResponse() => NoteResponse(
    id: id!,
    channelId: channelId,
    tick: tick,
    lengthTicks: lengthTicks,
    pitch: pitch,
    velocity: velocity,
  );
}
