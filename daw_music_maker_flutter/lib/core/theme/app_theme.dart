import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'daw_colors.dart';

/// Builds the app's [ThemeData] for dark ("midnight studio") and light
/// ("paper studio") modes.
abstract final class AppTheme {
  /// Dark theme — the default DAW look.
  static ThemeData get dark => _build(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.amber400,
      onPrimary: AppColors.ink950,
      primaryContainer: AppColors.amber800,
      onPrimaryContainer: AppColors.bone50,
      secondary: AppColors.teal400,
      onSecondary: AppColors.ink950,
      tertiary: AppColors.red400,
      onTertiary: AppColors.ink950,
      error: AppColors.red400,
      onError: AppColors.ink950,
      surface: AppColors.ink900,
      onSurface: AppColors.bone50,
      onSurfaceVariant: AppColors.ash300,
      surfaceContainerLowest: AppColors.ink950,
      surfaceContainerLow: AppColors.ink900,
      surfaceContainer: AppColors.ink800,
      surfaceContainerHigh: AppColors.ink700,
      surfaceContainerHighest: AppColors.ink600,
      outline: AppColors.ink500,
      outlineVariant: AppColors.ink600,
      shadow: AppColors.black,
      inverseSurface: AppColors.bone50,
      onInverseSurface: AppColors.ink900,
    ),
    dawColors: DawColors.dark,
  );

  /// Light theme.
  static ThemeData get light => _build(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.burnt600,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.burnt100,
      onPrimaryContainer: AppColors.graphite900,
      secondary: AppColors.teal700,
      onSecondary: AppColors.white,
      tertiary: AppColors.red600,
      onTertiary: AppColors.white,
      error: AppColors.red600,
      onError: AppColors.white,
      surface: AppColors.paper100,
      onSurface: AppColors.graphite900,
      onSurfaceVariant: AppColors.graphite600,
      surfaceContainerLowest: AppColors.white,
      surfaceContainerLow: AppColors.paper100,
      surfaceContainer: AppColors.paper50,
      surfaceContainerHigh: AppColors.paper200,
      surfaceContainerHighest: AppColors.paper300,
      outline: AppColors.paper500,
      outlineVariant: AppColors.paper300,
      shadow: AppColors.graphite900,
      inverseSurface: AppColors.graphite900,
      onInverseSurface: AppColors.paper50,
    ),
    dawColors: DawColors.light,
  );

  static ThemeData _build({
    required ColorScheme colorScheme,
    required DawColors dawColors,
  }) {
    final textStyles = AppTextStyles.build(
      color: colorScheme.onSurface,
      mutedColor: colorScheme.onSurfaceVariant,
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadii.mdAll,
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: dawColors.backdrop,
      textTheme: TextTheme(
        displayLarge: textStyles.displayLarge,
        headlineMedium: textStyles.display,
        titleLarge: textStyles.headline,
        titleMedium: textStyles.title,
        bodyLarge: textStyles.body,
        bodyMedium: textStyles.body,
        bodySmall: textStyles.bodySmall,
        labelLarge: textStyles.label,
      ),
      extensions: [dawColors, textStyles],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        labelStyle: textStyles.bodySmall,
        floatingLabelStyle: textStyles.eyebrow.copyWith(
          color: colorScheme.primary,
        ),
        hintStyle: textStyles.bodySmall,
        errorStyle: textStyles.bodySmall.copyWith(color: colorScheme.error),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error, width: 1.6),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.3),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textStyles.body.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
      ),
    );
  }
}
