import 'package:flutter/material.dart';

import 'app_text_styles.dart';
import 'daw_colors.dart';

/// Shortcuts to the app's theme tokens.
extension ThemeContext on BuildContext {
  /// Material color roles of the current theme.
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// DAW-specific color roles of the current theme.
  DawColors get dawColors => Theme.of(this).extension<DawColors>()!;

  /// Text styles of the current theme.
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;

  /// Whether the current theme is dark.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
