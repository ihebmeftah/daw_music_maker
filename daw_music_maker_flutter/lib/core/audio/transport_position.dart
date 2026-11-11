/// Read-only playback position of a transport, sampled by UI at frame rate
/// (e.g. a moving playhead) without rebuilding providers.
abstract interface class TransportPosition {
  /// Whether playback is running.
  bool get isRunning;

  /// Wall-clock time since playback started (zero when stopped).
  Duration get elapsed;

  /// Continuous position in beats since playback started: 0 at the first
  /// beat, 1.5 halfway between beats 2 and 3, … (0 when stopped).
  double get beatPosition;
}
