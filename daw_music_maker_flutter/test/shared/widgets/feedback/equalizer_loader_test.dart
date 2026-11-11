import 'package:daw_music_maker/shared/widgets/feedback/equalizer_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given an EqualizerLoader', () {
    testWidgets('when rendered, then draws one bar per band and is labelled', (
      tester,
    ) async {
      await tester.pumpApp(const EqualizerLoader(color: Colors.amber, bars: 5));

      expect(
        find.descendant(
          of: find.byType(EqualizerLoader),
          matching: find.byType(Container),
        ),
        findsNWidgets(5),
      );
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    });

    testWidgets('when reduce motion is on, then the tree settles', (
      tester,
    ) async {
      await tester.pumpApp(const EqualizerLoader(color: Colors.amber));

      await tester.pumpAndSettle();

      expect(find.byType(EqualizerLoader), findsOneWidget);
    });
  });
}
