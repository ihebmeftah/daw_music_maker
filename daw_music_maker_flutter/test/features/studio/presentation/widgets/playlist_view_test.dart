import 'package:daw_music_maker/features/studio/data/studio_clip.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/playlist_view.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late List<String> calls;
  late ValueNotifier<int?> playhead;
  final pattern = testPattern(id: testPatternId, name: 'Intro', lengthBars: 2);

  setUp(() {
    calls = [];
    playhead = ValueNotifier(null);
  });

  tearDown(() => playhead.dispose());

  Future<void> pump(
    WidgetTester tester, {
    bool canEdit = true,
    List<StudioClip> clips = const [],
    PatternResponse? selected,
  }) => tester.pumpApp(
    SizedBox(
      height: 700,
      child: PlaylistView(
        clips: clips,
        patterns: [pattern],
        selectedPattern: selected ?? pattern,
        songBars: 6,
        canEdit: canEdit,
        isSongMode: true,
        playhead: playhead,
        onToggleCell: (t, b) => calls.add('toggle $t $b'),
        onPickClip: (t, b) => calls.add('pick $t $b'),
        onDropSample: (id, t, b) => calls.add('drop $t $b'),
      ),
    ),
  );

  Offset cell(WidgetTester tester, int track, int bar) =>
      tester.getTopLeft(find.byKey(PlaylistView.gridKey)) +
      Offset(
        bar * PlaylistView.barWidth + 10,
        PlaylistView.rulerHeight + track * PlaylistView.trackHeight + 10,
      );

  group('Given cellAt', () {
    test('when given grid offsets, then returns track and bar', () {
      expect(
        PlaylistView.cellAt(
          const Offset(
            PlaylistView.barWidth * 3 + 1,
            PlaylistView.trackHeight * 2 + 1,
          ),
        ),
        (2, 3),
      );
    });
  });

  group('Given a PlaylistView', () {
    testWidgets('when rendered, then shows tracks, hint and song length', (
      tester,
    ) async {
      await pump(
        tester,
        clips: [StudioClip(patternId: testPatternId, track: 0, startBar: 0)],
      );

      expect(find.text('Track 1'), findsOneWidget);
      expect(find.text('Track 16'), findsOneWidget);
      expect(find.text('6 BARS'), findsOneWidget);
      expect(find.textContaining('“INTRO”'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('when clicking a cell, then reports its track and bar', (
      tester,
    ) async {
      await pump(tester);

      await tester.tapAt(cell(tester, 2, 5));

      expect(calls, ['toggle 2 5']);
    });

    testWidgets('when right-clicking a cell, then picks the clip', (
      tester,
    ) async {
      await pump(tester);

      await tester.tapAt(cell(tester, 1, 3), buttons: kSecondaryButton);

      expect(calls, ['pick 1 3']);
    });

    testWidgets('when read-only, then clicks do not edit', (tester) async {
      await pump(tester, canEdit: false);

      await tester.tapAt(cell(tester, 0, 0));

      expect(calls, isEmpty);
      expect(find.text('READ ONLY'), findsOneWidget);
    });

    testWidgets('when the song plays, then the playhead repaints', (
      tester,
    ) async {
      await pump(tester);

      playhead.value = 40;
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
