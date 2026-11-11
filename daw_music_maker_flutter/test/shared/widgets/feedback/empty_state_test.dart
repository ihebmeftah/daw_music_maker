import 'package:daw_music_maker/shared/widgets/feedback/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given an EmptyState', () {
    testWidgets('when rendered, then shows icon, title, message and action', (
      tester,
    ) async {
      await tester.pumpApp(
        const EmptyState(
          icon: Icons.album_outlined,
          title: 'No projects',
          message: 'Start one',
          action: Text('Action'),
        ),
      );

      expect(find.byIcon(Icons.album_outlined), findsOneWidget);
      expect(find.text('No projects'), findsOneWidget);
      expect(find.text('Start one'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });
  });
}
