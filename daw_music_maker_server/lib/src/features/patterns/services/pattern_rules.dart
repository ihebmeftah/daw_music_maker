import '../../../core/validation/validation_rules.dart';
import '../../../core/validation/validator.dart';
import '../../../generated/protocol.dart';

/// Pure validation and naming rules for patterns (no database).
abstract final class PatternRules {
  /// Validates and normalizes pattern settings.
  ///
  /// Throws [AppException] with [ErrorCode.validation] and field errors
  /// (`name`, `colorIndex`, `lengthBars`).
  static ({String name, int colorIndex, int lengthBars}) validate({
    required String name,
    required int colorIndex,
    required int lengthBars,
  }) {
    final v = Validator();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      v.add('name', 'Name is required');
    } else if (trimmed.length > ValidationRules.patternNameMaxLength) {
      v.add(
        'name',
        'Name must be at most ${ValidationRules.patternNameMaxLength} '
            'characters',
      );
    }
    if (colorIndex < 0 || colorIndex >= ValidationRules.patternColorCount) {
      v.add(
        'colorIndex',
        'Color must be between 0 and ${ValidationRules.patternColorCount - 1}',
      );
    }
    if (lengthBars < ValidationRules.patternLengthMin ||
        lengthBars > ValidationRules.patternLengthMax) {
      v.add(
        'lengthBars',
        'Length must be ${ValidationRules.patternLengthMin}–'
            '${ValidationRules.patternLengthMax} bars',
      );
    }
    v.throwIfInvalid();
    return (name: trimmed, colorIndex: colorIndex, lengthBars: lengthBars);
  }

  /// Position after the last of [existing] (0 when empty).
  static int nextPosition(List<Pattern> existing) => existing.isEmpty
      ? 0
      : existing.map((p) => p.position).reduce((a, b) => a > b ? a : b) + 1;

  /// Default name for a new pattern: one above the highest "Pattern N".
  static String defaultName(List<Pattern> existing) {
    final numbers = existing
        .map((p) => RegExp(r'^Pattern (\d+)$').firstMatch(p.name))
        .whereType<RegExpMatch>()
        .map((m) => int.parse(m.group(1)!));
    final next = numbers.isEmpty
        ? existing.length + 1
        : numbers.reduce((a, b) => a > b ? a : b) + 1;
    return 'Pattern $next';
  }

  /// Default color for a new pattern: cycles through the palette.
  static int defaultColor(List<Pattern> existing) =>
      existing.length % ValidationRules.patternColorCount;

  /// Ticks covered by a pattern of [lengthBars] bars.
  static int lengthTicks(int lengthBars) =>
      lengthBars * ValidationRules.ticksPerBar;

  /// Validates a complete note list for a pattern of [patternTicks] ticks
  /// whose project owns [channelIds].
  ///
  /// Throws [AppException] with [ErrorCode.validation] (`notes`) on the first
  /// invalid note, or [ErrorCode.limitReached] above the per-pattern cap.
  static void validateNotes(
    List<NoteInput> notes, {
    required int patternTicks,
    required Set<Object> channelIds,
  }) {
    if (notes.length > ValidationRules.notesPerPatternMax) {
      throw AppException(
        code: ErrorCode.limitReached,
        message:
            'A pattern can have at most '
            '${ValidationRules.notesPerPatternMax} notes',
      );
    }
    for (final (i, n) in notes.indexed) {
      final error = switch (n) {
        _ when !channelIds.contains(n.channelId) => 'unknown channel',
        _ when n.tick < 0 || n.tick >= patternTicks => 'starts outside the pattern',
        _ when n.lengthTicks < 1 || n.tick + n.lengthTicks > patternTicks =>
          'ends outside the pattern',
        _ when n.pitch < ValidationRules.pitchMin ||
            n.pitch > ValidationRules.pitchMax =>
          'pitch must be 0–127',
        _ when n.velocity < ValidationRules.velocityMin ||
            n.velocity > ValidationRules.velocityMax =>
          'velocity must be 1–127',
        _ => null,
      };
      if (error != null) {
        throw AppException(
          code: ErrorCode.validation,
          fieldErrors: {'notes': 'Note ${i + 1}: $error'},
        );
      }
    }
  }

  /// Name of a clone of [name], capped to the name length limit.
  static String cloneName(String name) {
    const suffix = ' (copy)';
    final max = ValidationRules.patternNameMaxLength - suffix.length;
    final base = name.length > max ? name.substring(0, max) : name;
    return '$base$suffix';
  }
}
