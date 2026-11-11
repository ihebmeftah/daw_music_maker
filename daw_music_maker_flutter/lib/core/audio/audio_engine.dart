/// Plays the app's sounds. Kept behind an interface so ViewModels and the
/// [Metronome] stay testable without audio hardware.
abstract interface class AudioEngine {
  /// Preloads sounds. Safe to call more than once.
  Future<void> load();

  /// Plays a metronome click; [accent] marks the first beat of a bar.
  ///
  /// Fire-and-forget: never throws (audio failures are swallowed so timing
  /// code is not interrupted).
  void playClick({required bool accent});

  /// Releases audio resources.
  Future<void> dispose();
}
