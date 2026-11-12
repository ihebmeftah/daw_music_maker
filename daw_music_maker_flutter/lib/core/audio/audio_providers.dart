import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../gen/assets.gen.dart';

import '../../app/di/injection.dart';
import 'audio_engine.dart';
import 'metronome.dart';
import 'wav_peaks.dart';

part 'audio_providers.g.dart';

/// The app's [AudioEngine] (from get_it), e.g. for previewing notes.
@Riverpod(keepAlive: true)
AudioEngine audioEngine(Ref ref) => getIt<AudioEngine>();

/// A fresh [Metronome] (from get_it) per consumer lifetime; disposed when no
/// longer watched, which also stops it.
@riverpod
Metronome metronome(Ref ref) {
  final metronome = getIt<Metronome>();
  ref.onDispose(metronome.dispose);
  return metronome;
}

/// Waveform outline of a built-in sample (read from the bundled WAV).
@Riverpod(keepAlive: true)
Future<List<double>?> builtinPeaks(Ref ref, SampleKind kind) async {
  final path = switch (kind) {
    SampleKind.kick => Assets.audio.samples.kick,
    SampleKind.snare => Assets.audio.samples.snare,
    SampleKind.closedHat => Assets.audio.samples.closedHat,
    SampleKind.openHat => Assets.audio.samples.openHat,
  };
  final data = await rootBundle.load(path);
  return wavPeaks(
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );
}
