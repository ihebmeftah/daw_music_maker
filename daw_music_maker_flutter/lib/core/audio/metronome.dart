import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'audio_engine.dart';
import 'transport_position.dart';

/// A metronome: clicks at a tempo with an accent on the first beat of each
/// bar, and publishes the current beat for UI lights.
///
/// Timing is drift-corrected: every beat is scheduled from the time of the
/// previous beat (not by accumulating timer delays), using `clock` so tests
/// can control time with `fakeAsync`.
@injectable
class Metronome implements TransportPosition {
  /// Creates a metronome playing through [engine].
  Metronome(this._engine);

  final AudioEngine _engine;
  final ValueNotifier<int?> _beat = ValueNotifier(null);

  /// Beats per bar (4/4).
  static const int beatsPerBar = 4;

  Timer? _timer;
  DateTime? _startedAt;
  DateTime? _lastBeatAt;

  int _count = 0;
  double _bpm = 120;
  bool _disposed = false;

  /// Index of the beat being played (0-based within the bar), or null when
  /// stopped. Changes once per beat — listen to it to animate lights.
  ValueListenable<int?> get beat => _beat;

  /// Whether the metronome is running.
  @override
  bool get isRunning => _timer != null;

  /// Whether clicks are silent. Beats (lights, playhead) keep going.
  bool muted = false;

  @override
  Duration get elapsed {
    final started = _startedAt;
    if (!isRunning || started == null) return Duration.zero;
    return clock.now().difference(started);
  }

  @override
  double get beatPosition {
    final last = _lastBeatAt;
    if (!isRunning || last == null || _count == 0) return 0;
    final interval = intervalFor(_bpm).inMicroseconds;
    final sinceLast = clock.now().difference(last).inMicroseconds / interval;
    // _count beats were played; the last one is at index _count - 1.
    return (_count - 1) + sinceLast.clamp(0.0, 1.0);
  }

  /// Current tempo in beats per minute.
  double get bpm => _bpm;

  /// Time between two beats at [bpm].
  static Duration intervalFor(double bpm) =>
      Duration(microseconds: (Duration.microsecondsPerMinute / bpm).round());

  /// Changes the tempo. While running, the next beat is rescheduled from the
  /// last one so the change is heard immediately without a gap or double hit.
  set bpm(double value) {
    _bpm = value;
    if (!isRunning || _lastBeatAt == null) return;
    _timer?.cancel();
    _schedule(_lastBeatAt!.add(intervalFor(_bpm)));
  }

  /// Starts at [bpm] from beat 1. Preloads sounds first. No-op if running.
  Future<void> start(double bpm) async {
    if (isRunning || _disposed) return;
    _bpm = bpm;
    _count = 0;
    // Mark as running before awaiting so double taps don't start twice.
    _timer = Timer(Duration.zero, () {});
    await _engine.load();
    if (_disposed || _timer == null) return;
    _tick();
  }

  /// Stops and resets to beat 1.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _lastBeatAt = null;
    _startedAt = null;
    if (!_disposed) _beat.value = null;
  }

  void _tick() {
    final now = clock.now();
    _startedAt ??= now;
    final position = _count % beatsPerBar;
    if (!muted) _engine.playClick(accent: position == 0);
    _beat.value = position;
    _count++;
    _lastBeatAt = now;
    _schedule(now.add(intervalFor(_bpm)));
  }

  void _schedule(DateTime at) {
    var delay = at.difference(clock.now());
    if (delay.isNegative) delay = Duration.zero;
    _timer = Timer(delay, _tick);
  }

  /// Stops and releases listeners.
  void dispose() {
    stop();
    _disposed = true;
    _beat.dispose();
  }
}
