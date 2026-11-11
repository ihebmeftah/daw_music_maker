import 'package:daw_music_maker/shared/widgets/inputs/daw_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const segments = [
    DawSegment(value: 1, label: 'One', key: Key('one')),
    DawSegment(value: 2, label: 'Two', icon: Icons.looks_two, key: Key('two')),
  ];

  group('Given a DawSegmentedControl', () {
    testWidgets('when a segment is tapped, then reports its value', (
      tester,
    ) async {
      int? changed;
      await tester.pumpApp(
        DawSegmentedControl<int>(
          segments: segments,
          selected: 1,
          onChanged: (v) => changed = v,
        ),
      );

      await tester.tap(find.byKey(const Key('two')));

      expect(changed, 2);
      expect(find.byIcon(Icons.looks_two), findsOneWidget);
    });

    testWidgets('when rendered, then marks the selected segment', (
      tester,
    ) async {
      await tester.pumpApp(
        DawSegmentedControl<int>(
          segments: segments,
          selected: 2,
          onChanged: (_) {},
        ),
      );

      expect(
        tester.getSemantics(find.byKey(const Key('two'))),
        isSemantics(isSelected: true, isButton: true),
      );
    });

    testWidgets('when disabled, then taps do nothing', (tester) async {
      await tester.pumpApp(
        const DawSegmentedControl<int>(
          segments: segments,
          selected: 1,
          onChanged: null,
        ),
      );

      await tester.tap(find.byKey(const Key('two')));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
