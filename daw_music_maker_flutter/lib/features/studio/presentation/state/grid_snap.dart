import '../../../../core/validation/validation_rules.dart';

/// Snap grid of the piano roll and the playlist, like FL Studio's snap
/// menu: where clicks land and how long new piano-roll notes are.
enum GridSnap {
  /// One bar (4 beats).
  bar,

  /// One beat (a quarter note).
  beat,

  /// Half a beat (an eighth note).
  halfBeat,

  /// One step (a sixteenth note).
  step,

  /// The finest grid line shown: half a step (a 32nd note). Piano roll
  /// only — playlist clips start on whole steps.
  line;

  /// Grid size in ticks (960 per quarter note).
  int get ticks => switch (this) {
    GridSnap.bar => ValidationRules.ticksPerBar,
    GridSnap.beat => ValidationRules.ppq,
    GridSnap.halfBeat => ValidationRules.ppq ~/ 2,
    GridSnap.step => ValidationRules.stepTicks,
    GridSnap.line => ValidationRules.stepTicks ~/ 2,
  };

  /// Grid size in whole steps (for the playlist; at least 1).
  int get steps => (ticks ~/ ValidationRules.stepTicks).clamp(1, 1 << 20);

  /// Menu label.
  String get label => switch (this) {
    GridSnap.bar => 'Bar',
    GridSnap.beat => 'Beat',
    GridSnap.halfBeat => '½ beat',
    GridSnap.step => 'Step',
    GridSnap.line => 'Line',
  };

  /// Options offered by the playlist (clips start on whole steps).
  static const playlistOptions = [
    GridSnap.bar,
    GridSnap.beat,
    GridSnap.halfBeat,
    GridSnap.step,
  ];

  /// Rounds [value] down to a multiple of [size].
  static int snapDown(int value, int size) =>
      value < 0 ? 0 : value - value % size;
}
