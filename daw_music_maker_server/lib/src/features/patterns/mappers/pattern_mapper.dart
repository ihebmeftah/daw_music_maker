import '../../../generated/protocol.dart';

/// Entity → response mapping for patterns.
extension PatternMapper on Pattern {
  /// Maps to a [PatternResponse].
  PatternResponse toResponse() => PatternResponse(
    id: id!,
    projectId: projectId,
    name: name,
    colorIndex: colorIndex,
    lengthBars: lengthBars,
    position: position,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
