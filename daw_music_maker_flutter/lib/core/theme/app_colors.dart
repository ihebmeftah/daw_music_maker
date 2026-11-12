import 'package:flutter/painting.dart';

/// Raw color palette of the app ("midnight studio" / "paper studio").
///
/// Private to `core/theme`: widgets must use semantic tokens from
/// `Theme.of(context).colorScheme` or `context.dawColors` instead.
abstract final class AppColors {
  // ── Ink (dark surfaces) ──────────────────────────────────────────────────
  /// Near-black studio background.
  static const Color ink950 = Color(0xFF09090C);

  /// Base dark surface.
  static const Color ink900 = Color(0xFF111117);

  /// Raised dark surface (panels, cards).
  static const Color ink800 = Color(0xFF1A1A22);

  /// Dark container / input fill.
  static const Color ink700 = Color(0xFF24242E);

  /// Dark subtle outline.
  static const Color ink600 = Color(0xFF34343F);

  /// Dark strong outline.
  static const Color ink500 = Color(0xFF4C4C59);

  /// Muted text on dark.
  static const Color ash300 = Color(0xFFA6A4B0);

  /// Primary text on dark ("bone").
  static const Color bone50 = Color(0xFFF4EEE3);

  // ── Paper (light surfaces) ───────────────────────────────────────────────
  /// Warm paper background.
  static const Color paper50 = Color(0xFFF6F1E7);

  /// Light raised surface.
  static const Color paper100 = Color(0xFFFFFBF4);

  /// Light container / input fill.
  static const Color paper200 = Color(0xFFEDE5D6);

  /// Light subtle outline.
  static const Color paper300 = Color(0xFFDCD1BD);

  /// Light strong outline.
  static const Color paper500 = Color(0xFF9C927F);

  /// Muted text on light.
  static const Color graphite600 = Color(0xFF5E5A52);

  /// Primary text on light.
  static const Color graphite900 = Color(0xFF16151A);

  // ── Accents ──────────────────────────────────────────────────────────────
  /// Tape-amber accent (dark theme primary).
  static const Color amber400 = Color(0xFFFFB23E);

  /// Deep amber (dark theme primary container).
  static const Color amber800 = Color(0xFF6B4100);

  /// Burnt orange (light theme primary).
  static const Color burnt600 = Color(0xFFD4550B);

  /// Pale orange (light theme primary container).
  static const Color burnt100 = Color(0xFFFFDDC7);

  /// Signal teal (dark theme secondary / meter low).
  static const Color teal400 = Color(0xFF34E0C2);

  /// Deep teal (light theme secondary / meter low).
  static const Color teal700 = Color(0xFF0B8C76);

  /// Record red (dark).
  static const Color red400 = Color(0xFFFF5A4A);

  /// Record red (light).
  static const Color red600 = Color(0xFFCC2A1C);

  /// Meter warning yellow.
  static const Color yellow400 = Color(0xFFFFD84A);

  // ── Track / pattern palette (dark theme; light theme uses the *Deep set) ─
  /// Track color 0 — amber.
  static const Color trackAmber = Color(0xFFFFB23E);

  /// Track color 1 — coral.
  static const Color trackCoral = Color(0xFFFF6B5B);

  /// Track color 2 — teal.
  static const Color trackTeal = Color(0xFF34E0C2);

  /// Track color 3 — sky.
  static const Color trackSky = Color(0xFF5AB8FF);

  /// Track color 4 — lime.
  static const Color trackLime = Color(0xFFB6E65A);

  /// Track color 5 — pink.
  static const Color trackPink = Color(0xFFFF7EB6);

  /// Track color 6 — lavender.
  static const Color trackLavender = Color(0xFFB59CFF);

  /// Track color 7 — sand.
  static const Color trackSand = Color(0xFFE8D3A8);

  /// Track color 0 (light theme).
  static const Color trackAmberDeep = Color(0xFFC77800);

  /// Track color 1 (light theme).
  static const Color trackCoralDeep = Color(0xFFD63B2B);

  /// Track color 2 (light theme).
  static const Color trackTealDeep = Color(0xFF0B8C76);

  /// Track color 3 (light theme).
  static const Color trackSkyDeep = Color(0xFF1F6FC2);

  /// Track color 4 (light theme).
  static const Color trackLimeDeep = Color(0xFF5E8C10);

  /// Track color 5 (light theme).
  static const Color trackPinkDeep = Color(0xFFC23A7A);

  /// Track color 6 (light theme).
  static const Color trackLavenderDeep = Color(0xFF6A4FD1);

  /// Track color 7 (light theme).
  static const Color trackSandDeep = Color(0xFF8C6A2E);

  /// Pure black (used for shadows and on-accent text).
  static const Color black = Color(0xFF000000);

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);
}
