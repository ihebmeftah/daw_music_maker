import 'package:daw_music_maker/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Future<bool?> open(WidgetTester tester) async {
    bool? result;
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async => result = await showConfirmDialog(
            context,
            title: 'Delete?',
            message: 'Gone forever',
            confirmLabel: 'Delete',
            destructive: true,
          ),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return result;
  }

  group('Given showConfirmDialog', () {
    testWidgets('when confirmed, then resolves to true', (tester) async {
      bool? result;
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showConfirmDialog(
              context,
              title: 'Delete?',
              message: 'Gone forever',
              confirmLabel: 'Delete',
            ),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Gone forever'), findsOneWidget);
      await tester.tap(find.byKey(confirmDialogConfirmKey));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('when cancelled, then resolves to false', (tester) async {
      await open(tester);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Gone forever'), findsNothing);
    });
  });
}
