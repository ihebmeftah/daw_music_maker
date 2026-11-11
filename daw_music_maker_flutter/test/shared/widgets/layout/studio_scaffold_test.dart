import 'package:daw_music_maker/core/theme/app_theme.dart';
import 'package:daw_music_maker/shared/widgets/buttons/theme_mode_toggle.dart';
import 'package:daw_music_maker/shared/widgets/daw/brand_mark.dart';
import 'package:daw_music_maker/shared/widgets/layout/studio_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget home) async {
    prepareSurface(tester);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.dark, home: home),
      ),
    );
  }

  group('Given a StudioScaffold', () {
    testWidgets('when it is the root screen, then shows the brand and title', (
      tester,
    ) async {
      await pump(
        tester,
        const StudioScaffold(
          title: 'PROJECTS',
          actions: [Icon(Icons.inbox)],
          body: Text('Body'),
        ),
      );

      expect(find.byType(BrandMark), findsOneWidget);
      expect(find.text('PROJECTS'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.byType(ThemeModeToggle), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('when pushed, then shows a back button instead', (
      tester,
    ) async {
      await pump(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    const StudioScaffold(title: 'DETAIL', body: SizedBox()),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(BackButton), findsOneWidget);
      expect(find.byType(BrandMark), findsNothing);
    });
  });
}
