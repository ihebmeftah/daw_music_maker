import 'package:daw_music_maker/shared/widgets/daw/tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('Given a TagChip', () {
    testWidgets('when read-only, then shows the hashtag without remove', (
      tester,
    ) async {
      await tester.pumpApp(const TagChip(label: 'techno'));

      expect(find.text('#techno'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('when removable and tapped, then calls onDeleted', (
      tester,
    ) async {
      var deleted = false;
      await tester.pumpApp(
        TagChip(label: 'house', onDeleted: () => deleted = true),
      );

      await tester.tap(find.byIcon(Icons.close_rounded));

      expect(deleted, isTrue);
    });
  });
}
