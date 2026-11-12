import 'package:daw_music_maker/core/audio/audio_engine.dart';
import 'package:daw_music_maker/core/audio/sound_source.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';

/// One recorded [FakeAudioEngine.play] call.
typedef PlayedSample = ({
  SoundSource source,
  double volume,
  double rate,
  double pan,
  double startFrac,
  double endFrac,
});

/// Convenience accessors for [PlayedSample].
extension PlayedSampleX on PlayedSample {
  /// The built-in sample played, if it was one.
  SampleKind? get sample => switch (source) {
    BuiltinSound(:final kind) => kind,
    UploadedSound() => null,
  };

  /// The uploaded sample played, if it was one.
  UuidValue? get sampleId => switch (source) {
    BuiltinSound() => null,
    UploadedSound(:final sampleId) => sampleId,
  };
}

/// [AudioEngine] that records clicks and sounds instead of playing them.
class FakeAudioEngine implements AudioEngine {
  /// `true` for accented clicks, in play order.
  final List<bool> clicks = [];

  /// Sounds played, in order.
  final List<PlayedSample> samples = [];

  /// Number of [load] calls.
  int loads = 0;

  @override
  Future<void> load() async => loads++;

  @override
  void playClick({required bool accent}) => clicks.add(accent);

  @override
  void play(
    SoundSource source, {
    double volume = 1,
    double rate = 1,
    double pan = 0,
    double startFrac = 0,
    double endFrac = 1,
  }) => samples.add((
    source: source,
    volume: volume,
    rate: rate,
    pan: pan,
    startFrac: startFrac,
    endFrac: endFrac,
  ));

  @override
  Future<void> dispose() async {}
}
