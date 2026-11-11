/// Animation durations shared across the app.
abstract final class AppDurations {
  /// 150 ms — hover / press feedback.
  static const Duration fast = Duration(milliseconds: 150);

  /// 300 ms — state changes (field errors, buttons).
  static const Duration medium = Duration(milliseconds: 300);

  /// 500 ms — screen-level transitions and step switches.
  static const Duration slow = Duration(milliseconds: 500);

  /// 900 ms — staggered entrance reveals.
  static const Duration entrance = Duration(milliseconds: 900);
}
