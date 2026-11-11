import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font configuration for the app.
abstract final class AppFonts {
  /// Whether typefaces are loaded through `google_fonts`.
  ///
  /// Tests set this to `false` (see `test/flutter_test_config.dart`) so no
  /// font is fetched over the network; the platform default is used instead.
  static bool useGoogleFonts = true;

  /// Wide, bold display typeface (festival-poster energy).
  static TextStyle display(TextStyle base) =>
      useGoogleFonts ? GoogleFonts.unbounded(textStyle: base) : base;

  /// Clean body typeface.
  static TextStyle body(TextStyle base) =>
      useGoogleFonts ? GoogleFonts.dmSans(textStyle: base) : base;

  /// Monospaced typeface for BPM, timecode and numeric readouts.
  static TextStyle mono(TextStyle base) =>
      useGoogleFonts ? GoogleFonts.jetBrainsMono(textStyle: base) : base;
}

/// The app's text styles, exposed as a [ThemeExtension].
///
/// Read with `context.textStyles`:
///
/// ```dart
/// Text('128 BPM', style: context.textStyles.mono)
/// ```
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  /// Creates a set of text styles.
  const AppTextStyles({
    required this.displayLarge,
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.eyebrow,
    required this.mono,
    required this.monoLarge,
  });

  /// Builds the styles for the given text [color] and [mutedColor].
  factory AppTextStyles.build({
    required Color color,
    required Color mutedColor,
  }) {
    return AppTextStyles(
      displayLarge: AppFonts.display(
        TextStyle(
          fontSize: 56,
          height: 0.98,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
          color: color,
        ),
      ),
      display: AppFonts.display(
        TextStyle(
          fontSize: 30,
          height: 1.1,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: color,
        ),
      ),
      headline: AppFonts.display(
        TextStyle(
          fontSize: 20,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: color,
        ),
      ),
      title: AppFonts.body(
        TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
      ),
      body: AppFonts.body(
        TextStyle(fontSize: 15, height: 1.45, color: color),
      ),
      bodySmall: AppFonts.body(
        TextStyle(fontSize: 13, height: 1.4, color: mutedColor),
      ),
      label: AppFonts.body(
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: color,
        ),
      ),
      eyebrow: AppFonts.mono(
        TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.4,
          color: mutedColor,
        ),
      ),
      mono: AppFonts.mono(
        TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color),
      ),
      monoLarge: AppFonts.mono(
        TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: color,
        ),
      ),
    );
  }

  /// Hero headline (auth hero, splash).
  final TextStyle displayLarge;

  /// Screen titles.
  final TextStyle display;

  /// Section and card headings.
  final TextStyle headline;

  /// Emphasized body text.
  final TextStyle title;

  /// Default body text.
  final TextStyle body;

  /// Secondary / helper text (muted color).
  final TextStyle bodySmall;

  /// Buttons and field labels.
  final TextStyle label;

  /// Small upper-case mono captions ("● REC", "CH 01").
  final TextStyle eyebrow;

  /// Monospaced readouts (BPM, time, codes).
  final TextStyle mono;

  /// Large monospaced readouts (transport display).
  final TextStyle monoLarge;

  @override
  AppTextStyles copyWith({
    TextStyle? displayLarge,
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? eyebrow,
    TextStyle? mono,
    TextStyle? monoLarge,
  }) {
    return AppTextStyles(
      displayLarge: displayLarge ?? this.displayLarge,
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      body: body ?? this.body,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
      eyebrow: eyebrow ?? this.eyebrow,
      mono: mono ?? this.mono,
      monoLarge: monoLarge ?? this.monoLarge,
    );
  }

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other == null) return this;
    return AppTextStyles(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      display: TextStyle.lerp(display, other.display, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      eyebrow: TextStyle.lerp(eyebrow, other.eyebrow, t)!,
      mono: TextStyle.lerp(mono, other.mono, t)!,
      monoLarge: TextStyle.lerp(monoLarge, other.monoLarge, t)!,
    );
  }
}
