import 'package:daw_music_maker/core/theme/app_theme.dart';
import 'package:daw_music_maker/shared/widgets/daw/wave_cursor_background.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a WaveCursorBackground', () {
    testWidgets('when rendered, then shows its child on top of the waves', (
      tester,
    ) async {
      await tester.pumpApp(
        const WaveCursorBackground(child: Center(child: Text('Studio'))),
      );

      expect(find.text('Studio'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(WaveCursorBackground),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets(
      'when the mouse moves over it, then the child still gets taps',
      (
        tester,
      ) async {
        var taps = 0;
        await tester.pumpApp(
          WaveCursorBackground(
            child: Center(
              child: TextButton(
                onPressed: () => taps++,
                child: const Text('Go'),
              ),
            ),
          ),
        );
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        addTearDown(mouse.removePointer);
        await mouse.addPointer(location: Offset.zero);
        await mouse.moveTo(tester.getCenter(find.text('Go')));
        await tester.pump();

        await tester.tap(find.text('Go'));

        expect(taps, 1);
      },
    );

    testWidgets('when animations run, then paints frames without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const WaveCursorBackground(child: SizedBox.expand()),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: const Offset(200, 200));
      await mouse.moveTo(const Offset(320, 260));

      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(tester.takeException(), isNull);
      // Remove the ticker-driven widget so the test ends without pending frames.
      await tester.pumpWidget(const SizedBox());
    });
  });
}
