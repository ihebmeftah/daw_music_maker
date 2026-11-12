import '../../../core/validation/validation_rules.dart';
import '../../../core/validation/validator.dart';
import '../../../generated/protocol.dart';

/// Pure rules for channels (no database).
abstract final class ChannelRules {
  /// The rack every new project starts with.
  static const List<(String, SampleKind)> defaults = [
    ('Kick', SampleKind.kick),
    ('Snare', SampleKind.snare),
    ('Hat', SampleKind.closedHat),
    ('Open Hat', SampleKind.openHat),
  ];

  /// Equal slices of the region [startFrac]–[endFrac].
  static List<(double, double)> slices(
    double startFrac,
    double endFrac,
    int count,
  ) {
    final width = (endFrac - startFrac) / count;
    return [
      for (var i = 0; i < count; i++)
        (
          startFrac + width * i,
          i == count - 1 ? endFrac : startFrac + width * (i + 1),
        ),
    ];
  }

  /// Default display name for [sample].
  static String defaultName(SampleKind sample) => switch (sample) {
    SampleKind.kick => 'Kick',
    SampleKind.snare => 'Snare',
    SampleKind.closedHat => 'Hat',
    SampleKind.openHat => 'Open Hat',
  };

  /// Validates and normalizes channel settings.
  ///
  /// Throws [AppException] with [ErrorCode.validation] (`name`, `volume`,
  /// `pan`, `pitch`, `region`).
  static ({String name, double volume}) validate({
    required String name,
    required double volume,
    double pan = 0,
    int pitch = 0,
    double startFrac = 0,
    double endFrac = 1,
  }) {
    final v = Validator();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      v.add('name', 'Name is required');
    } else if (trimmed.length > ValidationRules.channelNameMaxLength) {
      v.add(
        'name',
        'Name must be at most ${ValidationRules.channelNameMaxLength} '
            'characters',
      );
    }
    if (!volume.isFinite || volume < 0 || volume > 1) {
      v.add('volume', 'Volume must be between 0 and 1');
    }
    if (!pan.isFinite || pan < -1 || pan > 1) {
      v.add('pan', 'Pan must be between -1 and 1');
    }
    if (pitch.abs() > ValidationRules.samplerPitchRange) {
      v.add(
        'pitch',
        'Pitch must be within ±${ValidationRules.samplerPitchRange} semitones',
      );
    }
    if (!startFrac.isFinite ||
        !endFrac.isFinite ||
        startFrac < 0 ||
        endFrac > 1 ||
        endFrac - startFrac < ValidationRules.regionMinFrac) {
      v.add('region', 'The region must lie within the sample (start < end)');
    }
    v.throwIfInvalid();
    return (name: trimmed, volume: volume);
  }
}
