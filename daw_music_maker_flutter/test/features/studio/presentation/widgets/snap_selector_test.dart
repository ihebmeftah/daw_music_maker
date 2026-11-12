import 'package:daw_music_maker/features/studio/presentation/state/grid_snap.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/snap_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  const key = Key('snap');

  group('Given a SnapSelector', () {
    testWidgets('when rendered, then shows the current snap', (tester) async {
      await tester.pumpApp(
        SnapSelector(
          key: key,
          value: GridSnap.beat,
          options: GridSnap.values,
          onChanged: (_) {},
        ),
      );

      expect(find.text('GRID · '), findsOneWidget);
      expect(find.text('Beat'), findsOneWidget);
    });

    testWidgets('when picking an option, then reports it', (tester) async {
      GridSnap? picked;
      await tester.pumpApp(
        SnapSelector(
          key: key,
          value: GridSnap.bar,
          options: GridSnap.playlistOptions,
          onChanged: (s) => picked = s,
        ),
      );

      await tester.tap(find.byKey(key));
      await tester.pumpAndSettle();
      expect(
        find.byKey(SnapSelector.optionKey(key, GridSnap.line)),
        findsNothing,
      );
      await tester.tap(find.byKey(SnapSelector.optionKey(key, GridSnap.step)));
      await tester.pumpAndSettle();

      expect(picked, GridSnap.step);
    });
  });
}
