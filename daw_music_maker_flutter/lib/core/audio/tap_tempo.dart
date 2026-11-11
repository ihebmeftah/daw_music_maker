import 'package:clock/clock.dart';

/// Derives a tempo from taps ("tap tempo"): the average interval of the
/// last [window] taps. A pause longer than [resetAfter] starts over.
class TapTempo {
  /// Creates a tap tempo detector.
  TapTempo({this.window = 4, this.resetAfter = const Duration(seconds: 2)});

  /// Number of intervals averaged.
  final int window;

  /// Pause after which taps start a new measurement.
  final Duration resetAfter;

  final List<DateTime> _taps = [];

  /// Records a tap. Returns the tempo in BPM once at least two taps exist,
  /// otherwise null.
  double? tap() {
    final now = clock.now();
    if (_taps.isNotEmpty && now.difference(_taps.last) > resetAfter) {
      _taps.clear();
    }
    _taps.add(now);
    if (_taps.length > window + 1) _taps.removeAt(0);
    if (_taps.length < 2) return null;
    final total = _taps.last.difference(_taps.first).inMicroseconds;
    final average = total / (_taps.length - 1);
    return Duration.microsecondsPerMinute / average;
  }

  /// Forgets all taps.
  void reset() => _taps.clear();
}
