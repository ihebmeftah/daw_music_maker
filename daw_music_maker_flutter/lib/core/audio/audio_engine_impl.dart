import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../gen/assets.gen.dart';
import 'audio_engine.dart';
import 'sound_source.dart';

/// [AudioEngine] backed by `audioplayers`: pools of preloaded click samples,
/// and a few preloaded players per drum sample used round-robin so fast
/// hits overlap instead of cutting each other off.
@LazySingleton(as: AudioEngine)
class AudioEngineImpl implements AudioEngine {
  /// Asset paths are used as-is (they already start with `assets/`).
  final AudioCache _cache = AudioCache(prefix: '');
  Future<void>? _loading;
  AudioPool? _accent;
  AudioPool? _beat;

  /// Players per sound (voices that can sound at the same time).
  static const _voices = 4;
  final Map<String, List<AudioPlayer>> _players = {};
  final Map<String, int> _next = {};
  final Map<String, Duration> _durations = {};
  final Map<AudioPlayer, Timer> _stopTimers = {};

  static String _pathFor(SampleKind sample) => switch (sample) {
    SampleKind.kick => Assets.audio.samples.kick,
    SampleKind.snare => Assets.audio.samples.snare,
    SampleKind.closedHat => Assets.audio.samples.closedHat,
    SampleKind.openHat => Assets.audio.samples.openHat,
  };

  Source _sourceFor(SoundSource source) => switch (source) {
    BuiltinSound(:final kind) => AssetSource(_pathFor(kind)),
    UploadedSound(:final url) => UrlSource(url),
  };

  /// Creates (once) the voices of [source], preloaded with its file.
  Future<List<AudioPlayer>> _voicesFor(SoundSource source) async {
    final existing = _players[source.key];
    if (existing != null) return existing;
    final players = <AudioPlayer>[];
    _players[source.key] = players;
    for (var i = 0; i < _voices; i++) {
      final player = AudioPlayer()
        ..audioCache = _cache
        ..setReleaseMode(ReleaseMode.stop);
      await player.setSource(_sourceFor(source));
      players.add(player);
    }
    final duration = await players.first.getDuration();
    if (duration != null) _durations[source.key] = duration;
    return players;
  }

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
    for (final sample in SampleKind.values) {
      await _voicesFor(BuiltinSound(sample));
    }
  }

  @override
  void play(
    SoundSource source, {
    double volume = 1,
    double rate = 1,
    double pan = 0,
    double startFrac = 0,
    double endFrac = 1,
  }) {
    unawaited(() async {
      try {
        final players = await _voicesFor(source);
        if (players.isEmpty) return;
        final index = _next[source.key] ?? 0;
        _next[source.key] = (index + 1) % players.length;
        final player = players[index];
        _stopTimers.remove(player)?.cancel();
        await player.stop();
        await player.setVolume(volume.clamp(0, 1));
        await player.setBalance(pan.clamp(-1, 1));
        await player.setPlaybackRate(rate);
        final duration = _durations[source.key];
        final trimmed = startFrac > 0 || endFrac < 1;
        if (trimmed && duration != null) {
          final start = duration * startFrac;
          await player.seek(start);
          await player.resume();
          // Stop at the region end (scaled by the playback rate).
          final length = duration * (endFrac - startFrac) * (1 / rate);
          _stopTimers[player] = Timer(length, () {
            _stopTimers.remove(player);
            unawaited(player.stop());
          });
        } else {
          await player.resume();
        }
      } catch (e) {
        debugPrint('Sound playback failed: $e');
      }
    }());
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
    for (final timer in _stopTimers.values) {
      timer.cancel();
    }
    _stopTimers.clear();
    for (final players in _players.values) {
      for (final p in players) {
        await p.dispose();
      }
    }
    _players.clear();
    _accent = null;
    _beat = null;
    _loading = null;
  }
}
