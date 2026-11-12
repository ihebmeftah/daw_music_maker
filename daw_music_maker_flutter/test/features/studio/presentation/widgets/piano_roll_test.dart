import 'package:daw_music_maker/features/studio/data/studio_note.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/piano_roll.dart';
import 'package:daw_music_maker/features/studio/presentation/state/grid_snap.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/snap_selector.dart';
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

  Future<void> pump(WidgetTester tester, {bool canEdit = true}) {
    final channels = testChannels();
    return tester.pumpApp(
      SizedBox(
        height: 500,
        child: PianoRoll(
          channels: channels,
          channel: channels[1],
          notes: [StudioNote(channelId: channels[1].id, tick: 0, pitch: 64)],
          steps: 16,
          canEdit: canEdit,
          playhead: playhead,
          onToggleNote: (tick, pitch) => calls.add('note $tick $pitch'),
          onPreview: (pitch) => calls.add('preview $pitch'),
          onSelectChannel: (id) =>
              calls.add('channel ${testChannelIds.indexOf(id)}'),
          onSnapChanged: (s) => calls.add('snap ${s.name}'),
        ),
      ),
    );
  }

  group('Given pitch helpers', () {
    test('when naming pitches, then 60 is C5 (FL Studio)', () {
      expect(pitchName(60), 'C5');
      expect(pitchName(61), 'C#5');
      expect(pitchName(84), 'C7');
    });

    test('when checking key colors, then sharps are black', () {
      expect(isBlackKey(61), isTrue);
      expect(isBlackKey(64), isFalse);
    });

    test('when mapping a y offset, then returns the row pitch', () {
      expect(PianoRoll.pitchAt(0), 84);
      expect(PianoRoll.pitchAt(PianoRoll.rowHeight * 24 + 1), 60);
    });
  });

  group('Given a PianoRoll', () {
    testWidgets('when clicking the grid, then reports the tick and pitch', (
      tester,
    ) async {
      await pump(tester);
      final origin = tester.getTopLeft(find.byKey(PianoRoll.gridKey));

      await tester.tapAt(
        origin +
            const Offset(
              PianoRoll.stepWidth * 3 + 5,
              PianoRoll.rowHeight * 24 + 5, // C5
            ),
      );

      expect(calls, ['note 770 60']);
    });

    testWidgets('when clicking a key, then previews its pitch', (tester) async {
      await pump(tester);

      await tester.tap(find.byKey(PianoRoll.keyFor(84)));

      expect(calls, ['preview 84']);
      expect(find.text('C5'), findsOneWidget);
    });

    testWidgets('when choosing another channel, then reports it', (
      tester,
    ) async {
      await pump(tester);

      await tester.tap(find.byKey(PianoRoll.channelPickerKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Hat').last);
      await tester.pumpAndSettle();

      expect(calls, ['channel 3']);
    });

    testWidgets('when read-only, then the grid ignores clicks', (tester) async {
      await pump(tester, canEdit: false);

      await tester.tap(find.byKey(PianoRoll.gridKey));

      expect(calls, isEmpty);
      expect(find.text('READ ONLY'), findsOneWidget);
    });

    testWidgets('when the playhead moves, then repaints without errors', (
      tester,
    ) async {
      await pump(tester);

      playhead.value = 5;
      await tester.pump();
      playhead.value = null;
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('when picking a grid snap, then reports it', (tester) async {
      await pump(tester);

      await tester.tap(find.byKey(PianoRoll.snapKey));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(SnapSelector.optionKey(PianoRoll.snapKey, GridSnap.line)),
      );
      await tester.pumpAndSettle();

      expect(calls, ['snap line']);
    });
  });
}
