import 'package:daw_music_maker/core/theme/app_spacing.dart';
import 'package:daw_music_maker/features/studio/presentation/state/studio_state.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/bpm_display.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/beat_lights.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/pattern_selector.dart';
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
              onSetMode: (_) {},
              patternActions: PatternActions(
                onSelect: (_) {},
                onStep: (_) {},
                onCreate: () {},
                onClone: () {},
                onRename: () {},
                onColor: (_) {},
                onLength: (_) {},
                onDelete: () {},
              ),
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

    testWidgets('when narrow, then wraps instead of overflowing', (
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

        expect(find.byType(Wrap), findsOneWidget);
        expect(tester.takeException(), isNull, reason: '$width px');
        // Every control stays on screen (none scrolled away).
        final right = tester.getBottomRight(
          find.byKey(TransportToolbar.tapKey),
        );
        expect(right.dx, lessThanOrEqualTo(tester.view.physicalSize.width));
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

    testWidgets('when rendered, then every control has the same height', (
      tester,
    ) async {
      await pump(tester, state, 1100);

      final finders = {
        'back': find.byKey(TransportToolbar.backKey),
        'play': find.byKey(TransportToolbar.playKey),
        'mute': find.byKey(TransportToolbar.muteKey),
        'pattern box': find.byKey(PatternSelector.menuKey),
        'previous': find.byKey(PatternSelector.previousKey),
        'add': find.byKey(PatternSelector.addKey),
        'bpm': find.byType(BpmDisplay),
        'tap': find.byKey(TransportToolbar.tapKey),
      };
      for (final MapEntry(:key, :value) in finders.entries) {
        expect(
          tester.getSize(value).height,
          AppSpacing.toolbarControl,
          reason: key,
        );
      }
      // Play and mute are the same circle size.
      expect(
        tester.getSize(find.byKey(TransportToolbar.playKey)),
        tester.getSize(find.byKey(TransportToolbar.muteKey)),
      );
    });

    testWidgets('when the mode switch is shown, then it uses icons, not text', (
      tester,
    ) async {
      await pump(tester, state, 1100);

      expect(find.text('PAT'), findsNothing);
      expect(find.text('SONG'), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(TransportToolbar.patModeKey),
          matching: find.byIcon(Icons.grid_view_rounded),
        ),
        findsOneWidget,
      );
      expect(find.byTooltip('Song mode: play the playlist'), findsOneWidget);
    });

    testWidgets('when 70% of a 1440 px screen wide, then fits on one line', (
      tester,
    ) async {
      // 1440 px screen − 32 px padding − 8 px gap → 70% ≈ 975 px.
      await pump(tester, state, 975);

      final first = tester.getCenter(find.byKey(TransportToolbar.backKey)).dy;
      final last = tester.getCenter(find.byKey(TransportToolbar.tapKey)).dy;
      expect(last, closeTo(first, 1));
      expect(tester.takeException(), isNull);
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
