import 'package:daw_music_maker/core/theme/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Given the ThemeModeController', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer.test());

    test('when created, then follows the system', () {
      expect(container.read(themeModeControllerProvider), ThemeMode.system);
    });

    test('when toggled on a dark system, then switches to light', () {
      container
          .read(themeModeControllerProvider.notifier)
          .toggle(Brightness.dark);
      expect(container.read(themeModeControllerProvider), ThemeMode.light);
    });

    test('when toggled on a light system, then switches to dark', () {
      container
          .read(themeModeControllerProvider.notifier)
          .toggle(Brightness.light);
      expect(container.read(themeModeControllerProvider), ThemeMode.dark);
    });

    test('when toggled twice, then returns to the first explicit mode', () {
      final notifier = container.read(themeModeControllerProvider.notifier);
      notifier.toggle(Brightness.light);
      notifier.toggle(Brightness.light);
      expect(container.read(themeModeControllerProvider), ThemeMode.light);
    });
  });
}
