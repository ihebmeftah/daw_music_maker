/// Spacing scale (logical pixels) used for padding, gaps and margins.
///
/// Use these instead of numeric literals in widgets.
abstract final class AppSpacing {
  /// 2 px — hairline gaps.
  static const double xxs = 2;

  /// 4 px.
  static const double xs = 4;

  /// 8 px.
  static const double sm = 8;

  /// 12 px.
  static const double smd = 12;

  /// 16 px — default gap.
  static const double md = 16;

  /// 24 px.
  static const double lg = 24;

  /// 32 px.
  static const double xl = 32;

  /// 48 px.
  static const double xxl = 48;

  /// 64 px — section breathing room.
  static const double xxxl = 64;

  /// Size of every control in the studio toolbar (buttons, boxes, LCDs).
  static const double toolbarControl = 36;

  /// Maximum width of auth / form cards.
  static const double formMaxWidth = 440;

  /// Width at which layouts switch from stacked to side-by-side.
  static const double wideBreakpoint = 960;
}
