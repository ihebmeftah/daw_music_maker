import 'package:daw_music_maker/shared/widgets/buttons/daw_button.dart';
import 'package:daw_music_maker/shared/widgets/feedback/equalizer_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a DawButton', () {
    testWidgets('when rendered, then shows its label in upper case', (
      tester,
    ) async {
      await tester.pumpApp(DawButton(label: 'Sign in', onPressed: () {}));

      expect(find.text('SIGN IN'), findsOneWidget);
    });

    testWidgets('when tapped, then calls onPressed', (tester) async {
      var taps = 0;
      await tester.pumpApp(DawButton(label: 'Go', onPressed: () => taps++));

      await tester.tap(find.byType(DawButton));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('when loading, then shows the equalizer and ignores taps', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpApp(
        DawButton(label: 'Go', isLoading: true, onPressed: () => taps++),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DawButton));
      await tester.pump();

      expect(find.byType(EqualizerLoader), findsOneWidget);
      expect(find.text('GO'), findsNothing);
      expect(taps, 0);
    });

    testWidgets('when focused and Enter is pressed, then activates', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpApp(DawButton(label: 'Go', onPressed: () => taps++));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('when onPressed is null, then is reported as disabled', (
      tester,
    ) async {
      await tester.pumpApp(const DawButton(label: 'Go', onPressed: null));

      expect(
        tester.getSemantics(find.byType(DawButton)),
        isSemantics(isButton: true, isEnabled: false, hasEnabledState: true),
      );
    });

    testWidgets('when it is the ghost variant, then still renders', (
      tester,
    ) async {
      await tester.pumpApp(
        DawButton(
          label: 'Sign out',
          variant: DawButtonVariant.ghost,
          icon: Icons.logout,
          onPressed: () {},
        ),
      );

      expect(find.text('SIGN OUT'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });
  });
}
