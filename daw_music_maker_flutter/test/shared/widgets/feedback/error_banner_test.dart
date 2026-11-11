import 'package:daw_music_maker/shared/widgets/feedback/error_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given an ErrorBanner', () {
    testWidgets('when the message is null, then shows nothing', (tester) async {
      await tester.pumpApp(const ErrorBanner(message: null));

      expect(find.byIcon(Icons.graphic_eq_rounded), findsNothing);
    });

    testWidgets('when a message is set, then shows it', (tester) async {
      await tester.pumpApp(const ErrorBanner(message: 'Wrong password.'));
      await tester.pumpAndSettle();

      expect(find.text('Wrong password.'), findsOneWidget);
    });
  });
}
