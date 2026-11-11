import 'package:daw_music_maker/features/studio/presentation/widgets/bpm_display.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  late double bpm;
  late int commits;
  late List<double> submitted;

  setUp(() {
    bpm = 120;
    commits = 0;
    submitted = [];
  });

  /// Pumps the display inside a scrollable, so we can check the page does
  /// not scroll while the wheel adjusts the tempo.
  Future<ScrollController> pump(
    WidgetTester tester, {
    bool enabled = true,
  }) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    await tester.pumpApp(
      StatefulBuilder(
        builder: (context, setState) => ListView(
          controller: scroll,
          children: [
            const SizedBox(height: 200),
            Center(
              child: BpmDisplay(
                bpm: bpm,
                enabled: enabled,
                onAdjust: (d) => setState(() => bpm += d),
                onCommit: () => commits++,
                onSubmitted: submitted.add,
              ),
            ),
            const SizedBox(height: 2000),
          ],
        ),
      ),
    );
    return scroll;
  }

  Offset center(WidgetTester tester) =>
      tester.getCenter(find.byType(BpmDisplay));

  group('Given formatBpm', () {
    test('when whole, then has no decimals', () {
      expect(formatBpm(120), '120');
    });

    test('when fractional, then shows 2 decimals', () {
      expect(formatBpm(128.5), '128.50');
    });
  });

  group('Given a BpmDisplay', () {
    testWidgets('when held and the wheel rolls, then adjusts and commits', (
      tester,
    ) async {
      final scroll = await pump(tester);
      final pointer = TestPointer(1, PointerDeviceKind.mouse);

      await tester.sendEventToBinding(pointer.down(center(tester)));
      await tester.sendEventToBinding(pointer.scroll(const Offset(0, -50)));
      await tester.sendEventToBinding(pointer.scroll(const Offset(0, -50)));
      await tester.sendEventToBinding(pointer.scroll(const Offset(0, 50)));
      await tester.pump();

      expect(bpm, 121);
      expect(commits, 0);
      expect(scroll.offset, 0, reason: 'the page must not scroll');
      expect(find.text('121'), findsOneWidget);

      await tester.sendEventToBinding(pointer.up());
      await tester.pump(kDoubleTapTimeout);
      expect(commits, 1);
    });

    testWidgets('when held with Shift, then the wheel fine-tunes by 0.1', (
      tester,
    ) async {
      await pump(tester);
      final pointer = TestPointer(1, PointerDeviceKind.mouse);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendEventToBinding(pointer.down(center(tester)));
      await tester.sendEventToBinding(pointer.scroll(const Offset(0, -50)));
      await tester.sendEventToBinding(pointer.up());
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump(kDoubleTapTimeout);

      expect(bpm, closeTo(120.1, 1e-9));
    });

    testWidgets('when the wheel rolls without holding, then the page scrolls', (
      tester,
    ) async {
      final scroll = await pump(tester);
      final pointer = TestPointer(1, PointerDeviceKind.mouse);
      pointer.hover(center(tester));

      await tester.sendEventToBinding(pointer.scroll(const Offset(0, 100)));
      await tester.pump();

      expect(bpm, 120);
      expect(scroll.offset, greaterThan(0));
    });

    testWidgets('when held and dragged up, then raises the tempo', (
      tester,
    ) async {
      await pump(tester);

      final gesture = await tester.startGesture(
        center(tester),
        kind: PointerDeviceKind.mouse,
      );
      await gesture.moveBy(const Offset(0, -20));
      await gesture.moveBy(const Offset(0, -20));
      await gesture.up();
      await tester.pump(kDoubleTapTimeout);

      expect(bpm, 130);
      expect(commits, 1);
    });

    testWidgets('when double-clicked, then an exact value can be typed', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byType(BpmDisplay));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(BpmDisplay));
      await tester.pumpAndSettle();
      expect(find.byKey(BpmDisplay.fieldKey), findsOneWidget);

      await tester.enterText(find.byKey(BpmDisplay.fieldKey), '5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('20–999 BPM'), findsOneWidget);
      expect(submitted, isEmpty);

      await tester.enterText(find.byKey(BpmDisplay.fieldKey), '87,5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(submitted, [87.5]);
      expect(find.byKey(BpmDisplay.fieldKey), findsNothing);
    });

    testWidgets(
      'when disabled, then holding, scrolling and editing do nothing',
      (
        tester,
      ) async {
        await pump(tester, enabled: false);
        final pointer = TestPointer(1, PointerDeviceKind.mouse);

        await tester.sendEventToBinding(pointer.down(center(tester)));
        await tester.sendEventToBinding(pointer.scroll(const Offset(0, -50)));
        await tester.sendEventToBinding(pointer.up());
        await tester.tap(find.byType(BpmDisplay));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.byType(BpmDisplay));
        await tester.pumpAndSettle();

        expect(bpm, 120);
        expect(commits, 0);
        expect(find.byKey(BpmDisplay.fieldKey), findsNothing);
      },
    );
  });
}
