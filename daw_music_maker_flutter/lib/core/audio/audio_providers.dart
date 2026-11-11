import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/di/injection.dart';
import 'metronome.dart';

part 'audio_providers.g.dart';

/// A fresh [Metronome] (from get_it) per consumer lifetime; disposed when no
/// longer watched, which also stops it.
@riverpod
Metronome metronome(Ref ref) {
  final metronome = getIt<Metronome>();
  ref.onDispose(metronome.dispose);
  return metronome;
}
