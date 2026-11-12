import 'sound_source.dart';

/// Plays the app's sounds. Kept behind an interface so ViewModels and the
/// [Metronome] stay testable without audio hardware.
abstract interface class AudioEngine {
  /// Preloads the metronome clicks and built-in samples. Safe to call more
  /// than once.
  Future<void> load();

  /// Plays a metronome click; [accent] marks the first beat of a bar.
  ///
  /// Fire-and-forget: never throws (audio failures are swallowed so timing
  /// code is not interrupted).
  void playClick({required bool accent});

  /// Plays [source] at [volume] (0–1), playback [rate] (1 = original pitch,
  /// 2 = one octave up), stereo [pan] (-1 left … 1 right), limited to the
  /// region [startFrac]–[endFrac] of the file. Fire-and-forget, never throws.
  void play(
    SoundSource source, {
    double volume = 1,
    double rate = 1,
    double pan = 0,
    double startFrac = 0,
    double endFrac = 1,
  });

  /// Releases audio resources.
  Future<void> dispose();
}
