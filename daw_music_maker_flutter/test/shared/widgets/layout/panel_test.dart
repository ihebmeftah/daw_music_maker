import 'package:daw_music_maker/shared/widgets/layout/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a Panel', () {
    testWidgets('when it has a header, then shows eyebrow, title, trailing', (
      tester,
    ) async {
      await tester.pumpApp(
        const Panel(
          eyebrow: 'MEMBERS',
          title: '3 people',
          trailing: Text('Invite'),
          child: Text('Body'),
        ),
      );

      expect(find.text('MEMBERS'), findsOneWidget);
      expect(find.text('3 people'), findsOneWidget);
      expect(find.text('Invite'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('when hosting a list tile, then ink paints without errors', (
      tester,
    ) async {
      await tester.pumpApp(
        Panel(
          child: SwitchListTile(value: true, onChanged: (_) {}),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
