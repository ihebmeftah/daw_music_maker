import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

/// Holds the app's [ThemeMode] and lets the user flip between dark and light.
///
/// Starts from [ThemeMode.system]; [toggle] resolves the system brightness to
/// an explicit mode the first time it is used.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Switches to the opposite of the currently visible brightness.
  ///
  /// [platformBrightness] is used to resolve [ThemeMode.system].
  void toggle(Brightness platformBrightness) {
    final isDarkNow = switch (state) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    state = isDarkNow ? ThemeMode.light : ThemeMode.dark;
  }
}
