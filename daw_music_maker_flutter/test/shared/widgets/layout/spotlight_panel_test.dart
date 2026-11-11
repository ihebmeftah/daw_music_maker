import 'package:daw_music_maker/shared/widgets/layout/spotlight_panel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a SpotlightPanel', () {
    testWidgets('when rendered, then shows its child', (tester) async {
      await tester.pumpApp(
        const Center(
          child: SizedBox(
            width: 300,
            child: SpotlightPanel(child: Text('Form')),
          ),
        ),
      );

      expect(find.text('Form'), findsOneWidget);
    });

    testWidgets('when hovered and left, then repaints without errors', (
      tester,
    ) async {
      await tester.pumpApp(
        const Center(
          child: SizedBox(
            width: 300,
            height: 200,
            child: SpotlightPanel(child: SizedBox.expand()),
          ),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);

      await mouse.moveTo(tester.getCenter(find.byType(SpotlightPanel)));
      await tester.pumpAndSettle();
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
