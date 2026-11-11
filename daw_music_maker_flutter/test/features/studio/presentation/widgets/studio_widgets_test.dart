import 'package:daw_music_maker/features/studio/presentation/state/studio_state.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/beat_lights.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/play_button.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/transport_toolbar.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  group('Given BeatLights', () {
    testWidgets('when the beat changes, then the matching pad lights up', (
      tester,
    ) async {
      final beat = ValueNotifier<int?>(null);
      addTearDown(beat.dispose);
      await tester.pumpApp(BeatLights(beat: beat, compact: true));
      bool lit(int i) =>
          ((tester
                          .widget<AnimatedContainer>(
                            find.descendant(
                              of: find.byKey(BeatLights.padKey(i)),
                              matching: find.byType(AnimatedContainer),
                            ),
                          )
                          .decoration!
                      as BoxDecoration)
                  .boxShadow!)
              .isNotEmpty;

      expect([for (var i = 0; i < 4; i++) lit(i)], everyElement(isFalse));

      beat.value = 2;
      await tester.pumpAndSettle();

      expect(lit(2), isTrue);
      expect(lit(0), isFalse);
    });

    testWidgets('when not compact, then pads show beat numbers', (
      tester,
    ) async {
      final beat = ValueNotifier<int?>(null);
      addTearDown(beat.dispose);
      await tester.pumpApp(BeatLights(beat: beat));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });
  });

  group('Given a PlayButton', () {
    testWidgets('when stopped, then shows play and calls onPressed', (
      tester,
    ) async {
      var presses = 0;
      await tester.pumpApp(
        PlayButton(isPlaying: false, size: 52, onPressed: () => presses++),
      );

      await tester.tap(find.byType(PlayButton));

      expect(presses, 1);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.bySemanticsLabel('Play metronome'), findsOneWidget);
    });

    testWidgets('when playing, then shows pause', (tester) async {
      await tester.pumpApp(PlayButton(isPlaying: true, onPressed: () {}));

      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
      expect(find.bySemanticsLabel('Pause metronome'), findsOneWidget);
    });
  });

  group('Given a TransportToolbar', () {
    Future<void> pump(
      WidgetTester tester,
      StudioState state,
      double width, {
      VoidCallback? onBack,
      VoidCallback? onToggleMute,
    }) {
      final beat = ValueNotifier<int?>(null);
      addTearDown(beat.dispose);
      return tester.pumpApp(
        Center(
          child: SizedBox(
            width: width,
            child: TransportToolbar(
              state: state,
              beat: beat,
              onBack: onBack ?? () {},
              onTogglePlay: () {},
              onToggleMute: onToggleMute ?? () {},
              onAdjust: (_) {},
              onCommit: () {},
              onNudge: (_) {},
              onTap: () {},
              onSubmitted: (_) {},
            ),
          ),
        ),
      );
    }

    final state = StudioState(project: testProject(), bpm: 120, savedBpm: 120);

    testWidgets('when wide, then shows everything on one line', (
      tester,
    ) async {
      await pump(tester, state, 1000);

      expect(find.text('SAVED'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('when narrow, then scrolls instead of overflowing', (
      tester,
    ) async {
      for (final width in [320.0, 640.0, 860.0]) {
        await pump(
          tester,
          StudioState(
            project: testProject(access: ProjectAccess.read),
            bpm: 120,
            savedBpm: 120,
          ),
          width,
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(tester.takeException(), isNull, reason: '$width px');
      }
    });

    testWidgets('when read-only, then arrows and TAP are disabled', (
      tester,
    ) async {
      await pump(
        tester,
        StudioState(
          project: testProject(access: ProjectAccess.read),
          bpm: 120,
          savedBpm: 120,
        ),
        1000,
      );

      expect(find.text('READ ONLY'), findsOneWidget);
      expect(
        tester.widget<IconButton>(find.byKey(TransportToolbar.upKey)).onPressed,
        isNull,
      );
      expect(
        tester
            .widget<IconButton>(find.byKey(TransportToolbar.tapKey))
            .onPressed,
        isNull,
      );
    });

    testWidgets('when tapping back, then calls onBack', (tester) async {
      var back = 0;
      await pump(tester, state, 1000, onBack: () => back++);

      await tester.tap(find.byKey(TransportToolbar.backKey));

      expect(back, 1);
      expect(find.text(state.project.name), findsOneWidget);
    });

    testWidgets('when sound is on, then the toggle is selected', (
      tester,
    ) async {
      var toggles = 0;
      await pump(tester, state, 1000, onToggleMute: () => toggles++);

      final button = tester.widget<IconButton>(
        find.byKey(TransportToolbar.muteKey),
      );
      expect(button.isSelected, isTrue);
      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

      await tester.tap(find.byKey(TransportToolbar.muteKey));
      expect(toggles, 1);
    });

    testWidgets('when muted, then the toggle is not selected', (tester) async {
      await pump(
        tester,
        StudioState(
          project: testProject(),
          bpm: 120,
          savedBpm: 120,
          isMuted: true,
        ),
        1000,
      );

      expect(
        tester
            .widget<IconButton>(find.byKey(TransportToolbar.muteKey))
            .isSelected,
        isFalse,
      );
      expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
      expect(find.byTooltip('Unmute metronome (M)'), findsOneWidget);
    });

    testWidgets('when TAP is shown, then it is an icon button', (tester) async {
      await pump(tester, state, 1000);

      expect(
        find.descendant(
          of: find.byKey(TransportToolbar.tapKey),
          matching: find.byIcon(Icons.touch_app_outlined),
        ),
        findsOneWidget,
      );
      expect(find.text('TAP'), findsNothing);
    });

    testWidgets('when there are unsaved changes, then says UNSAVED', (
      tester,
    ) async {
      await pump(
        tester,
        StudioState(project: testProject(), bpm: 121, savedBpm: 120),
        900,
      );

      expect(find.text('UNSAVED'), findsOneWidget);
    });
  });
}
