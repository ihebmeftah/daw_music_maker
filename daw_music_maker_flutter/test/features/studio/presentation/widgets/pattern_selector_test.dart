import 'package:daw_music_maker/features/studio/presentation/widgets/pattern_selector.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  final idA = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4eb1');
  final idB = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4eb2');
  final a = testPattern(id: idA, name: 'Intro', lengthBars: 4);
  final b = testPattern(id: idB, name: 'Drop', lengthBars: 8, colorIndex: 2);

  late List<String> calls;

  setUp(() => calls = []);

  PatternActions actions() => PatternActions(
    onSelect: (id) => calls.add('select $id'),
    onStep: (d) => calls.add('step $d'),
    onCreate: () => calls.add('create'),
    onClone: () => calls.add('clone'),
    onRename: () => calls.add('rename'),
    onColor: (i) => calls.add('color $i'),
    onLength: (bars) => calls.add('length $bars'),
    onDelete: () => calls.add('delete'),
  );

  Future<void> pump(
    WidgetTester tester, {
    List<PatternResponse>? patterns,
    bool canEdit = true,
  }) async {
    final list = patterns ?? [a, b];
    await tester.pumpApp(
      Center(
        child: PatternSelector(
          patterns: list,
          selected: list.first,
          canEdit: canEdit,
          isBusy: false,
          actions: actions(),
        ),
      ),
    );
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byKey(PatternSelector.menuKey));
    await tester.pumpAndSettle();
  }

  group('Given a PatternSelector', () {
    testWidgets('when rendered, then shows the selected pattern and length', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('Intro'), findsOneWidget);
      expect(find.text('4 BARS'), findsOneWidget);
    });

    testWidgets('when using the arrows and +, then steps and creates', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(PatternSelector.previousKey));
      await tester.tap(find.byKey(PatternSelector.nextKey));
      await tester.tap(find.byKey(PatternSelector.addKey));

      expect(calls, ['step -1', 'step 1', 'create']);
    });

    testWidgets('when picking a pattern in the menu, then selects it', (
      tester,
    ) async {
      await pump(tester);
      await openMenu(tester);

      expect(find.text('Drop · 8 bars'), findsOneWidget);
      await tester.tap(find.byKey(PatternSelector.itemKey(idB)));
      await tester.pumpAndSettle();

      expect(calls, ['select $idB']);
    });

    testWidgets('when using menu actions, then calls clone, rename, delete', (
      tester,
    ) async {
      await pump(tester);

      for (final key in [
        PatternSelector.cloneKey,
        PatternSelector.renameKey,
        PatternSelector.deleteKey,
      ]) {
        await openMenu(tester);
        await tester.tap(find.byKey(key));
        await tester.pumpAndSettle();
      }

      expect(calls, ['clone', 'rename', 'delete']);
    });

    testWidgets('when choosing a length and a color, then reports them', (
      tester,
    ) async {
      await pump(tester);

      await openMenu(tester);
      await tester.tap(find.byKey(PatternSelector.lengthMenuKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(PatternSelector.lengthKey(16)));
      await tester.pumpAndSettle();

      await openMenu(tester);
      await tester.tap(find.byKey(PatternSelector.colorMenuKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(PatternSelector.colorKey(5)));
      await tester.pumpAndSettle();

      expect(calls, ['length 16', 'color 5']);
    });

    testWidgets(
      'when only one pattern exists, then delete and arrows are off',
      (
        tester,
      ) async {
        await pump(tester, patterns: [a]);

        expect(
          tester
              .widget<IconButton>(find.byKey(PatternSelector.nextKey))
              .onPressed,
          isNull,
        );
        await openMenu(tester);
        expect(
          tester
              .widget<MenuItemButton>(find.byKey(PatternSelector.deleteKey))
              .onPressed,
          isNull,
        );
      },
    );

    testWidgets('when read-only, then only lists patterns', (tester) async {
      await pump(tester, canEdit: false);

      expect(find.byKey(PatternSelector.addKey), findsNothing);
      await openMenu(tester);
      expect(find.byKey(PatternSelector.itemKey(idB)), findsOneWidget);
      expect(find.byKey(PatternSelector.cloneKey), findsNothing);
      expect(find.byKey(PatternSelector.deleteKey), findsNothing);
    });
  });
}
