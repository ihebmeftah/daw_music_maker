import 'package:daw_music_maker/features/studio/data/studio_note.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/channel_rack.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late List<String> calls;
  late ValueNotifier<int?> playhead;

  setUp(() {
    calls = [];
    playhead = ValueNotifier(null);
  });

  tearDown(() => playhead.dispose());

  ChannelRackActions actions() => ChannelRackActions(
    onToggleStep: (id, step) =>
        calls.add('step ${testChannelIds.indexOf(id)} $step'),
    onSelect: (id) => calls.add('select ${testChannelIds.indexOf(id)}'),
    onOpenPianoRoll: (id) => calls.add('piano ${testChannelIds.indexOf(id)}'),
    onToggleMute: (id) => calls.add('mute ${testChannelIds.indexOf(id)}'),
    onVolume: (id, v) => calls.add('volume'),
    onVolumeEnd: (id) => calls.add('volumeEnd'),
    onAdd: (s) => calls.add('add ${s.name}'),
    onDelete: (id) => calls.add('delete ${testChannelIds.indexOf(id)}'),
    onOpenSampler: (id) => calls.add('sampler ${testChannelIds.indexOf(id)}'),
    onDropItem: (item) => calls.add('drop ${item.kind?.name ?? item.sampleId}'),
  );

  Future<void> pump(
    WidgetTester tester, {
    bool canEdit = true,
    List<StudioNote> notes = const [],
  }) => tester.pumpApp(
    SizedBox(
      height: 400,
      child: ChannelRack(
        channels: testChannels(),
        notes: notes,
        steps: 16,
        selectedChannelId: testChannelIds[0],
        canEdit: canEdit,
        playhead: playhead,
        actions: actions(),
      ),
    ),
  );

  Color stepColor(WidgetTester tester, int channel, int step) {
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byKey(ChannelRack.stepKey(testChannelIds[channel], step)),
        matching: find.byType(Container),
      ),
    );
    return (container.decoration! as BoxDecoration).color!;
  }

  group('Given a ChannelRack', () {
    testWidgets('when rendered, then shows each channel with 16 steps', (
      tester,
    ) async {
      await pump(tester);

      for (final name in ['Kick', 'Snare', 'Hat', 'Open Hat']) {
        expect(find.text(name), findsOneWidget);
      }
      expect(
        find.byKey(ChannelRack.stepKey(testChannelIds[3], 15)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('when a step has a note, then it is lit in the track color', (
      tester,
    ) async {
      await pump(
        tester,
        notes: [StudioNote(channelId: testChannelIds[0], tick: 960)],
      );

      expect(stepColor(tester, 0, 4), isNot(stepColor(tester, 0, 5)));
      expect(stepColor(tester, 0, 4), isNot(stepColor(tester, 1, 4)));
    });

    testWidgets('when tapping steps and channels, then reports them', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(ChannelRack.stepKey(testChannelIds[1], 4)));
      await tester.tap(find.byKey(ChannelRack.muteKey(testChannelIds[2])));
      await tester.tap(find.byKey(ChannelRack.channelKey(testChannelIds[3])));
      await tester.pump(kDoubleTapTimeout);

      expect(calls, ['step 1 4', 'mute 2', 'select 3']);
    });

    testWidgets('when double-tapping a channel, then opens the sampler', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(ChannelRack.channelKey(testChannelIds[1])));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byKey(ChannelRack.channelKey(testChannelIds[1])));
      await tester.pumpAndSettle();

      expect(calls, contains('sampler 1'));
    });

    testWidgets(
      'when adding a channel from the menu, then reports the sample',
      (
        tester,
      ) async {
        await pump(tester);

        await tester.tap(find.byKey(ChannelRack.addKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open hat').last);
        await tester.pumpAndSettle();

        expect(calls, ['add openHat']);
      },
    );

    testWidgets('when the playhead moves, then its step column is outlined', (
      tester,
    ) async {
      await pump(tester);

      playhead.value = 18; // loops to step 2 of 16
      await tester.pump();

      final border =
          (tester
                          .widget<Container>(
                            find.descendant(
                              of: find.byKey(
                                ChannelRack.stepKey(testChannelIds[0], 2),
                              ),
                              matching: find.byType(Container),
                            ),
                          )
                          .decoration!
                      as BoxDecoration)
                  .border!
              as Border;
      expect(border.top.width, 2);
    });

    testWidgets('when read-only, then steps and add are disabled', (
      tester,
    ) async {
      await pump(tester, canEdit: false);

      await tester.tap(find.byKey(ChannelRack.stepKey(testChannelIds[0], 0)));

      expect(calls, isEmpty);
      expect(find.byKey(ChannelRack.addKey), findsNothing);
    });
  });
}
