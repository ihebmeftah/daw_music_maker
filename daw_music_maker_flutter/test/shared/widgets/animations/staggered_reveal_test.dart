import 'package:daw_music_maker/core/theme/app_theme.dart';
import 'package:daw_music_maker/shared/widgets/animations/staggered_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  double opacityOf(WidgetTester tester) => tester
      .widget<Opacity>(
        find.descendant(
          of: find.byType(StaggeredReveal),
          matching: find.byType(Opacity),
        ),
      )
      .opacity;

  group('Given a StaggeredReveal', () {
    testWidgets('when reduce motion is on, then the child is visible at once', (
      tester,
    ) async {
      await tester.pumpApp(const StaggeredReveal(index: 3, child: Text('Hi')));

      expect(opacityOf(tester), 1);
    });

    testWidgets('when animations run, then fades in after its delay', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: const StaggeredReveal(index: 2, child: Text('Hi')),
        ),
      );

      expect(opacityOf(tester), 0);
      // Index 2 × 90 ms step: still hidden before the delay elapses.
      await tester.pump(const Duration(milliseconds: 150));
      expect(opacityOf(tester), 0);
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pumpAndSettle();

      expect(opacityOf(tester), 1);
    });
  });
}
