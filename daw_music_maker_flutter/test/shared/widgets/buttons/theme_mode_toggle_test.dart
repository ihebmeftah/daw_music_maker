import 'package:daw_music_maker/core/theme/app_theme.dart';
import 'package:daw_music_maker/core/theme/theme_mode_controller.dart';
import 'package:daw_music_maker/shared/widgets/buttons/theme_mode_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a ThemeModeToggle', () {
    testWidgets('when tapped in dark mode, then switches the app to light', (
      tester,
    ) async {
      prepareSurface(tester);
      final container = ProviderContainer.test();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: ref.watch(themeModeControllerProvider),
              home: const Scaffold(body: ThemeModeToggle()),
            ),
          ),
        ),
      );
      container
          .read(themeModeControllerProvider.notifier)
          .toggle(Brightness.light); // → dark
      await tester.pumpAndSettle();
      expect(find.byTooltip('Switch to light mode'), findsOneWidget);

      await tester.tap(find.byType(ThemeModeToggle));
      await tester.pumpAndSettle();

      expect(container.read(themeModeControllerProvider), ThemeMode.light);
      expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
    });
  });
}
