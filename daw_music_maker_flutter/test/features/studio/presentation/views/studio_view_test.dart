import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/presentation/views/project_detail_view.dart';
import 'package:daw_music_maker/features/studio/presentation/views/studio_view.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/beat_lights.dart';
import 'package:daw_music_maker/features/studio/data/studio_clip.dart';
import 'package:daw_music_maker/features/studio/data/studio_note.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/playlist_view.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/sample_browser.dart';
import 'package:daw_music_maker/features/studio/presentation/view_models/studio_view_model.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/bpm_display.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/channel_rack.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/piano_roll.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/pattern_name_dialog.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/pattern_selector.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/playback_timeline.dart';
import 'package:daw_music_maker/features/studio/presentation/widgets/transport_toolbar.dart';
import 'package:flutter/gestures.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockStudioRepository studio;
  late FakeAudioEngine audio;

  setUpAll(registerTestFallbacks);

  setUp(() {
    studio = MockStudioRepository();
    audio = FakeAudioEngine();
    stubPatterns(studio);
    when(() => studio.saveTempo(any(), any())).thenAnswer(
      (inv) async => testProject(bpm: inv.positionalArguments[1] as double),
    );
  });

  Future<void> open(
    WidgetTester tester, {
    ProjectAccess access = ProjectAccess.owner,
    double bpm = 120,
  }) async {
    when(
      () => studio.loadProject(any()),
    ).thenAnswer((_) async => testProject(access: access, bpm: bpm));
    await tester.pumpDawApp(
      session: FakeAuthSession(signedIn: true),
      studio: studio,
      audio: audio,
      initialLocation: '/projects/$testRequestId/studio',
    );
  }

  String shownBpm(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(BpmDisplay.valueKey)).data!;

  /// Lit pads have a solid fill; unlit ones use the container color.
  bool isLit(WidgetTester tester, int index) {
    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byKey(BeatLights.padKey(index)),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    return decoration.boxShadow!.isNotEmpty;
  }

  group('Given the studio of a project the user owns', () {
    testWidgets('when opened, then shows the project tempo and transport', (
      tester,
    ) async {
      await open(tester, bpm: 128);

      expect(find.byType(StudioView), findsOneWidget);
      expect(shownBpm(tester), '128');
      expect(find.text('SAVED'), findsOneWidget);
      expect(find.byKey(TransportToolbar.playKey), findsOneWidget);
    });

    testWidgets('when pressing play, then clicks on the beat and lights pads', (
      tester,
    ) async {
      await open(tester);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump();
      expect(audio.clicks, [true]);
      expect(isLit(tester, 0), isTrue);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 100));
      expect(audio.clicks, [true, false]);
      expect(isLit(tester, 1), isTrue);
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(isLit(tester, 0), isFalse);
      await tester.pump(const Duration(seconds: 1));
      expect(audio.clicks, hasLength(2));
    });

    testWidgets('when pressing Space, then toggles playback', (tester) async {
      await open(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(audio.clicks, hasLength(1));

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump(const Duration(seconds: 1));
      expect(audio.clicks, hasLength(1));
    });

    testWidgets('when using the arrows and ↓, then changes and saves', (
      tester,
    ) async {
      await open(tester);

      await tester.tap(find.byKey(TransportToolbar.upKey));
      await tester.pumpAndSettle();
      expect(shownBpm(tester), '121');
      verify(() => studio.saveTempo(testRequestId, 121)).called(1);

      // Move focus off the button so the studio handles the arrow key.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(shownBpm(tester), '120');
    });

    testWidgets('when holding the BPM and rolling the wheel, then saves once', (
      tester,
    ) async {
      await open(tester);
      final pointer = TestPointer(1, PointerDeviceKind.mouse);
      final center = tester.getCenter(find.byType(BpmDisplay));

      await tester.sendEventToBinding(pointer.down(center));
      for (var i = 0; i < 5; i++) {
        await tester.sendEventToBinding(pointer.scroll(const Offset(0, -40)));
      }
      await tester.pump();
      expect(shownBpm(tester), '125');
      expect(find.text('UNSAVED'), findsOneWidget);
      verifyNever(() => studio.saveTempo(any(), any()));

      await tester.sendEventToBinding(pointer.up());
      await tester.pumpAndSettle();

      verify(() => studio.saveTempo(testRequestId, 125)).called(1);
      expect(find.text('SAVED'), findsOneWidget);
    });

    testWidgets('when double-clicking the BPM and typing, then saves it', (
      tester,
    ) async {
      await open(tester);

      await tester.tap(find.byType(BpmDisplay));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(BpmDisplay));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(BpmDisplay.fieldKey), '174.5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(shownBpm(tester), '174.50');
      verify(() => studio.saveTempo(testRequestId, 174.5)).called(1);
    });

    testWidgets('when tapping tempo twice 500 ms apart, then sets 120', (
      tester,
    ) async {
      await open(tester, bpm: 90);

      await tester.tap(find.byKey(TransportToolbar.tapKey));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(TransportToolbar.tapKey));
      await tester.pumpAndSettle();

      expect(shownBpm(tester), '120');
    });

    testWidgets('when saving fails, then shows the error and UNSAVED', (
      tester,
    ) async {
      when(
        () => studio.saveTempo(any(), any()),
      ).thenThrow(const Failure(FailureCode.network));
      await open(tester);

      await tester.tap(find.byKey(TransportToolbar.upKey));
      await tester.pumpAndSettle();

      expect(find.text(FailureCode.network.message), findsOneWidget);
      expect(find.text('UNSAVED'), findsOneWidget);
    });
  });

  group('Given the studio without an app bar', () {
    testWidgets(
      'when opened, then there is no AppBar and back goes to the project',
      (
        tester,
      ) async {
        final projects = MockProjectRepository();
        final collab = MockCollaborationRepository();
        stubEmptyProjectLists(projects);
        stubEmptyInbox(collab);
        when(
          () => projects.getById(any()),
        ).thenAnswer((_) async => testProject());
        when(() => collab.listMembers(any())).thenAnswer((_) async => []);
        when(
          () => collab.listProjectInvitations(any()),
        ).thenAnswer((_) async => []);
        when(() => collab.listJoinRequests(any())).thenAnswer((_) async => []);
        when(
          () => studio.loadProject(any()),
        ).thenAnswer((_) async => testProject());
        final container = await tester.pumpDawApp(
          session: FakeAuthSession(signedIn: true),
          projects: projects,
          collaboration: collab,
          studio: studio,
          audio: audio,
          initialLocation: '/projects/$testRequestId/studio',
        );

        expect(find.byType(AppBar), findsNothing);
        expect(find.byType(BackButton), findsNothing);

        await tester.tap(find.byKey(TransportToolbar.backKey));
        await tester.pumpAndSettle();

        expect(find.byType(ProjectDetailView), findsOneWidget);
        expect(currentLocation(container), '/projects/$testRequestId');
      },
    );

    testWidgets('when muted and playing, then lights move without sound', (
      tester,
    ) async {
      await open(tester);

      await tester.tap(find.byKey(TransportToolbar.muteKey));
      await tester.pump();
      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(isLit(tester, 1), isTrue);
      expect(audio.clicks, isEmpty);

      // M unmutes: the next beat is heard.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
      await tester.pump(const Duration(milliseconds: 500));
      expect(audio.clicks, [false]);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('when playing, then the timeline shows the elapsed time', (
      tester,
    ) async {
      await open(tester);

      expect(find.byKey(PlaybackTimeline.elapsedKey), findsOneWidget);
      expect(find.text('00:00.00'), findsOneWidget);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1250));
      await tester.pump(const Duration(milliseconds: 16));

      final elapsed = tester
          .widget<Text>(find.byKey(PlaybackTimeline.elapsedKey))
          .data!;
      expect(elapsed, startsWith('00:01.'));
      expect(find.text('BAR 1 · BEAT 3'), findsOneWidget);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:00.00'), findsOneWidget);
      expect(find.text('STOPPED'), findsOneWidget);
    });
  });

  group('Given patterns in the studio toolbar', () {
    final intro = testPattern(id: testPatternId, name: 'Intro', lengthBars: 4);
    final drop = testPattern(
      id: otherTestId,
      name: 'Drop',
      lengthBars: 8,
      position: 1,
    );

    testWidgets('when switching with ] and [, then the timeline follows', (
      tester,
    ) async {
      stubPatterns(studio, [intro, drop]);
      await open(tester);

      expect(find.text('INTRO · LOOP 4 BARS'), findsOneWidget);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.sendKeyEvent(LogicalKeyboardKey.bracketRight);
      await tester.pumpAndSettle();
      expect(find.text('DROP · LOOP 8 BARS'), findsOneWidget);
      expect(find.text('Drop'), findsOneWidget);

      // Shortcuts keep working with focus anywhere in the studio.
      await tester.sendKeyEvent(LogicalKeyboardKey.bracketLeft);
      await tester.pumpAndSettle();
      expect(find.text('INTRO · LOOP 4 BARS'), findsOneWidget);
    });

    testWidgets('when renaming from the menu, then saves the new name', (
      tester,
    ) async {
      stubPatterns(studio, [intro, drop]);
      when(
        () => studio.updatePattern(
          any(),
          name: any(named: 'name'),
          colorIndex: any(named: 'colorIndex'),
          lengthBars: any(named: 'lengthBars'),
        ),
      ).thenAnswer(
        (inv) async => testPattern(
          id: testPatternId,
          name: inv.namedArguments[#name] as String,
        ),
      );
      await open(tester);

      await tester.tap(find.byKey(PatternSelector.menuKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(PatternSelector.renameKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(PatternNameDialog.fieldKey), 'Verse');
      await tester.tap(find.byKey(PatternNameDialog.saveKey));
      await tester.pumpAndSettle();

      verify(
        () => studio.updatePattern(
          testPatternId,
          name: 'Verse',
          colorIndex: 0,
          lengthBars: 4,
        ),
      ).called(1);
      expect(find.text('VERSE · LOOP 4 BARS'), findsOneWidget);
    });

    testWidgets('when adding a pattern with +, then it becomes current', (
      tester,
    ) async {
      final added = testPattern(
        id: otherTestId,
        name: 'Pattern 2',
        position: 1,
      );
      when(() => studio.createPattern(any())).thenAnswer((_) async => added);
      await open(tester);

      await tester.tap(find.byKey(PatternSelector.addKey));
      await tester.pumpAndSettle();

      expect(find.text('PATTERN 2 · LOOP 4 BARS'), findsOneWidget);
    });

    testWidgets('when a read member opens the studio, then there is no +', (
      tester,
    ) async {
      await open(tester, access: ProjectAccess.read);

      expect(find.byKey(PatternSelector.menuKey), findsOneWidget);
      expect(find.byKey(PatternSelector.addKey), findsNothing);
    });
  });

  group('Given the channel rack and piano roll', () {
    testWidgets('when clicking a step, then it plays and saves after a pause', (
      tester,
    ) async {
      await open(tester);

      expect(find.byType(ChannelRack), findsOneWidget);
      await tester.tap(find.byKey(ChannelRack.stepKey(testChannelIds[0], 0)));
      await tester.pump();
      expect(audio.samples.single.sample, SampleKind.kick);
      verifyNever(() => studio.saveNotes(any(), any()));

      await tester.pump(StudioViewModel.noteSaveDelay);
      await tester.pumpAndSettle();

      final saved =
          verify(
                () => studio.saveNotes(testPatternId, captureAny()),
              ).captured.single
              as List<StudioNote>;
      expect(saved.single.channelId, testChannelIds[0]);
    });

    testWidgets('when playing, then the drums sound on their steps', (
      tester,
    ) async {
      stubPatterns(studio, null, null, [
        StudioNote(channelId: testChannelIds[0], tick: 0),
        StudioNote(channelId: testChannelIds[1], tick: 960),
      ]);
      await open(tester);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump();
      // 120 BPM: beat 2 (step 4) is 500 ms later.
      await tester.pump(const Duration(milliseconds: 520));

      expect(audio.samples.map((s) => s.sample), [
        SampleKind.kick,
        SampleKind.snare,
      ]);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('when switching to the piano roll, then shows the channel', (
      tester,
    ) async {
      await open(tester);

      await tester.tap(find.byKey(StudioView.pianoTabKey));
      await tester.pumpAndSettle();

      expect(find.byType(PianoRoll), findsOneWidget);
      expect(find.byType(ChannelRack), findsNothing);
      await tester.tap(find.byKey(PianoRoll.keyFor(72)));
      await tester.pump();
      expect(audio.samples.single.rate, closeTo(2, 1e-9));

      await tester.tap(find.byKey(StudioView.rackTabKey));
      await tester.pumpAndSettle();
      expect(find.byType(ChannelRack), findsOneWidget);
    });
  });

  group('Given the playlist and song mode', () {
    testWidgets(
      'when placing a clip in the playlist, then saves it after a pause',
      (
        tester,
      ) async {
        await open(tester);

        await tester.tap(find.byKey(StudioView.playlistTabKey));
        await tester.pumpAndSettle();
        expect(find.byType(PlaylistView), findsOneWidget);

        final grid = tester.getTopLeft(find.byKey(PlaylistView.gridKey));
        await tester.tapAt(
          grid +
              const Offset(
                PlaylistView.barWidth * 2 + 10,
                PlaylistView.rulerHeight + 10,
              ),
        );
        await tester.pump(StudioViewModel.noteSaveDelay);
        await tester.pumpAndSettle();

        final saved =
            verify(
                  () => studio.saveClips(testRequestId, captureAny()),
                ).captured.single
                as List<StudioClip>;
        expect(saved.single.startStep, 32);
        expect(saved.single.track, 0);
      },
    );

    testWidgets(
      'when switching to SONG with L, then the timeline shows the song',
      (
        tester,
      ) async {
        stubPatterns(studio, null, null, const [], [
          StudioClip(patternId: testPatternId, track: 0, startStep: 64),
        ]);
        await open(tester);

        await tester.sendKeyEvent(LogicalKeyboardKey.keyL);
        await tester.pumpAndSettle();
        expect(find.text('SONG · LOOP 8 BARS'), findsOneWidget);

        await tester.tap(find.byKey(TransportToolbar.patModeKey));
        await tester.pumpAndSettle();
        expect(find.text('PATTERN 1 · LOOP 4 BARS'), findsOneWidget);
      },
    );

    testWidgets('when playing the song, then clips sound at their bars', (
      tester,
    ) async {
      stubPatterns(
        studio,
        null,
        null,
        [StudioNote(channelId: testChannelIds[0], tick: 0)],
        [StudioClip(patternId: testPatternId, track: 0, startStep: 16)],
      );
      await open(tester);
      await tester.tap(find.byKey(TransportToolbar.songModeKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump();
      expect(audio.samples, isEmpty); // bar 1 is empty

      // At 120 BPM, bar 2 starts after 2 s.
      await tester.pump(const Duration(milliseconds: 2010));
      expect(audio.samples.single.sample, SampleKind.kick);

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump(const Duration(seconds: 1));
    });
  });

  group('Given the toolbar and timeline layout', () {
    testWidgets('when wide, then they share a row at about 70% / 30%', (
      tester,
    ) async {
      await open(tester);

      final toolbar = tester.getRect(find.byType(TransportToolbar));
      final timeline = tester.getRect(find.byType(PlaybackTimeline));

      expect(timeline.top, toolbar.top);
      expect(timeline.left, greaterThan(toolbar.right));
      final ratio = timeline.width / (toolbar.width + timeline.width);
      expect(ratio, closeTo(0.3, 0.02));
    });

    testWidgets('when narrow, then the timeline goes below the toolbar', (
      tester,
    ) async {
      await open(tester);
      tester.view.physicalSize = const Size(800, 1100);
      await tester.pumpAndSettle();

      final toolbar = tester.getRect(find.byType(TransportToolbar));
      final timeline = tester.getRect(find.byType(PlaybackTimeline));
      expect(timeline.top, greaterThanOrEqualTo(toolbar.bottom));
      expect(tester.takeException(), isNull);
    });
  });

  group('Given the sample browser and drag & drop', () {
    final voxId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f41');

    Future<void> dragTo(WidgetTester tester, Finder from, Offset to) async {
      final gesture = await tester.startGesture(tester.getCenter(from));
      await tester.pump();
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      await gesture.moveTo(to);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
    }

    testWidgets(
      'when dropping a drum on the channel rack, then adds a channel',
      (
        tester,
      ) async {
        when(
          () => studio.createChannel(
            any(),
            sample: any(named: 'sample'),
            sampleId: any(named: 'sampleId'),
          ),
        ).thenAnswer(
          (_) async => testChannels().first.copyWith(
            id: voxId,
            name: 'Snare',
            sample: SampleKind.snare,
            position: 4,
          ),
        );
        await open(tester);

        await dragTo(
          tester,
          find.byKey(SampleBrowser.builtinKey(SampleKind.snare)),
          tester.getCenter(find.byType(ChannelRack)),
        );

        verify(
          () => studio.createChannel(testRequestId, sample: SampleKind.snare),
        ).called(1);
        expect(find.byKey(ChannelRack.channelKey(voxId)), findsOneWidget);
      },
    );

    testWidgets(
      'when dropping an upload on the playlist, then places and saves an audio clip',
      (
        tester,
      ) async {
        stubPatterns(studio, null, null, const [], const [], [
          testSample(id: voxId, name: 'Vox', durationMs: 9000),
        ]);
        await open(tester);
        await tester.tap(find.byKey(StudioView.playlistTabKey));
        await tester.pumpAndSettle();

        final grid = tester.getTopLeft(find.byKey(PlaylistView.gridKey));
        await dragTo(
          tester,
          find.byKey(SampleBrowser.sampleKey(voxId)),
          grid +
              const Offset(
                PlaylistView.barWidth * 2 + 10,
                PlaylistView.rulerHeight + PlaylistView.trackHeight + 10,
              ),
        );
        await tester.pump(StudioViewModel.noteSaveDelay);
        await tester.pumpAndSettle();

        final saved =
            verify(
                  () => studio.saveClips(testRequestId, captureAny()),
                ).captured.single
                as List<StudioClip>;
        expect(saved.single.sampleId, voxId);
        expect(saved.single.lengthBars, 5); // 9 s at 120 BPM
        expect(saved.single.track, 1);
        expect(saved.single.startStep, 32);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when the playlist has audio clips, then it paints them', (
      tester,
    ) async {
      stubPatterns(
        studio,
        null,
        null,
        const [],
        [StudioClip(sampleId: voxId, lengthBars: 3, track: 0, startStep: 0)],
        [testSample(id: voxId)],
      );
      await open(tester);

      await tester.tap(find.byKey(StudioView.playlistTabKey));
      await tester.pumpAndSettle();

      expect(find.byType(PlaylistView), findsOneWidget);
      expect(find.text('3 BARS'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Given a read member in the studio', () {
    testWidgets('when opened, then can play but not change the tempo', (
      tester,
    ) async {
      await open(tester, access: ProjectAccess.read);

      expect(find.text('READ ONLY'), findsOneWidget);
      await tester.tap(find.byKey(TransportToolbar.upKey));
      await tester.pumpAndSettle();
      expect(shownBpm(tester), '120');

      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump();
      expect(audio.clicks, hasLength(1));
      await tester.tap(find.byKey(TransportToolbar.playKey));
      await tester.pump(const Duration(seconds: 1));
    });
  });

  group('Given the studio route', () {
    testWidgets('when the project is not visible, then shows not found', (
      tester,
    ) async {
      when(
        () => studio.loadProject(any()),
      ).thenThrow(const Failure(FailureCode.notFound));
      await tester.pumpDawApp(
        session: FakeAuthSession(signedIn: true),
        studio: studio,
        initialLocation: '/projects/$testRequestId/studio',
      );

      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('when the id is not a UUID, then shows not found', (
      tester,
    ) async {
      await tester.pumpDawApp(
        session: FakeAuthSession(signedIn: true),
        initialLocation: '/projects/nope/studio',
      );

      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('when tapping "Go to studio" on a project, then opens it', (
      tester,
    ) async {
      final projects = MockProjectRepository();
      final collab = MockCollaborationRepository();
      stubEmptyProjectLists(projects);
      stubEmptyInbox(collab);
      when(
        () => projects.getById(any()),
      ).thenAnswer((_) async => testProject());
      when(() => collab.listMembers(any())).thenAnswer((_) async => []);
      when(
        () => collab.listProjectInvitations(any()),
      ).thenAnswer((_) async => []);
      when(() => collab.listJoinRequests(any())).thenAnswer((_) async => []);
      when(
        () => studio.loadProject(any()),
      ).thenAnswer((_) async => testProject());
      await tester.pumpDawApp(
        session: FakeAuthSession(signedIn: true),
        projects: projects,
        collaboration: collab,
        studio: studio,
        initialLocation: '/projects/$testRequestId',
      );

      await tester.tap(find.byKey(ProjectDetailView.studioKey));
      await tester.pumpAndSettle();

      expect(find.byType(StudioView), findsOneWidget);
    });
  });
}
