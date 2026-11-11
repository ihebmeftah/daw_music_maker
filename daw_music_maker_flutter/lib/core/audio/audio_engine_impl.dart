import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../gen/assets.gen.dart';
import 'audio_engine.dart';

/// [AudioEngine] backed by `audioplayers` pools of preloaded click samples,
/// so consecutive clicks start with minimal latency.
@LazySingleton(as: AudioEngine)
class AudioEngineImpl implements AudioEngine {
  /// Asset paths are used as-is (they already start with `assets/`).
  final AudioCache _cache = AudioCache(prefix: '');
  Future<void>? _loading;
  AudioPool? _accent;
  AudioPool? _beat;

  @override
  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    final (accent, beat) = await (
      AudioPool.createFromAsset(
        path: Assets.audio.samples.metronomeAccent,
        maxPlayers: 4,
        audioCache: _cache,
      ),
      AudioPool.createFromAsset(
        path: Assets.audio.samples.metronomeBeat,
        maxPlayers: 4,
        audioCache: _cache,
      ),
    ).wait;
    _accent = accent;
    _beat = beat;
  }

  @override
  void playClick({required bool accent}) {
    final pool = accent ? _accent : _beat;
    if (pool == null) return;
    unawaited(
      pool.start().then<void>((_) {}).catchError((Object e) {
        debugPrint('Metronome click failed: $e');
      }),
    );
  }

  @override
  Future<void> dispose() async {
    await _accent?.dispose();
    await _beat?.dispose();
    _accent = null;
    _beat = null;
    _loading = null;
  }
}
