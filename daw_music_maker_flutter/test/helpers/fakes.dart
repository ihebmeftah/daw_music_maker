import 'package:daw_music_maker/core/audio/audio_engine.dart';

/// [AudioEngine] that records clicks instead of playing sound.
class FakeAudioEngine implements AudioEngine {
  /// `true` for accented clicks, in play order.
  final List<bool> clicks = [];

  /// Number of [load] calls.
  int loads = 0;

  @override
  Future<void> load() async => loads++;

  @override
  void playClick({required bool accent}) => clicks.add(accent);

  @override
  Future<void> dispose() async {}
}
