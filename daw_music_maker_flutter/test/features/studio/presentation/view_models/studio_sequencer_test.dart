import 'package:daw_music_maker/core/audio/audio_providers.dart';
import 'package:daw_music_maker/core/audio/metronome.dart';
import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/studio/data/studio_note.dart';
import 'package:daw_music_maker/features/studio/data/studio_providers.dart';
import 'package:daw_music_maker/features/studio/presentation/state/grid_snap.dart';
import 'package:daw_music_maker/features/studio/presentation/state/studio_state.dart';
import 'package:daw_music_maker/features/studio/presentation/view_models/studio_view_model.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fakes.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockStudioRepository repository;
  late FakeAudioEngine audio;
  late Metronome metronome;
  late ProviderContainer container;

  final kick = testChannelIds[0];
  final snare = testChannelIds[1];
  final provider = studioViewModelProvider(testRequestId);
  StudioViewModel vm() => container.read(provider.notifier);
  StudioState state() => container.read(provider).requireValue;

  Future<void> load({
    ProjectAccess access = ProjectAccess.owner,
    List<StudioNote> notes = const [],
  }) async {
    stubPatterns(repository, null, null, notes);
    when(
      () => repository.loadProject(any()),
    ).thenAnswer((_) async => testProject(access: access));
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
  }

  setUpAll(registerTestFallbacks);

  setUp(() {
    repository = MockStudioRepository();
    audio = FakeAudioEngine();
    metronome = Metronome(audio);
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        studioRepositoryProvider.overrideWithValue(repository),
        metronomeProvider.overrideWithValue(metronome),
        audioEngineProvider.overrideWithValue(audio),
      ],
    );
  });

  group('Given the studio sequencer', () {
    test('when loaded, then has the drum rack and the pattern notes', () async {
      await load(notes: [StudioNote(channelId: kick, tick: 0)]);

      expect(state().channels.map((c) => c.name), [
        'Kick',
        'Snare',
        'Hat',
        'Open Hat',
      ]);
      expect(state().selectedChannel!.id, kick);
      expect(state().currentNotes, hasLength(1));
      expect(state().patternSteps, 64);
    });

    test(
      'when toggling a step on, then adds a root note and previews it',
      () async {
        await load();

        vm().toggleStep(snare, 4);

        final note = state().currentNotes.single;
        expect(note.channelId, snare);
        expect(note.tick, 4 * 240);
        expect(note.lengthTicks, 240);
        expect(note.pitch, 60);
        expect(state().notesDirty, isTrue);
        expect(audio.samples.single.sample, SampleKind.snare);
      },
    );

    test('when toggling the same step again, then removes it', () async {
      await load();

      vm().toggleStep(kick, 0);
      vm().toggleStep(kick, 0);

      expect(state().currentNotes, isEmpty);
    });

    test(
      'when saving, then sends the pattern notes and clears dirty',
      () async {
        await load();
        vm().toggleStep(kick, 2);

        await vm().saveNotes(testPatternId);

        final sent =
            verify(
                  () => repository.saveNotes(testPatternId, captureAny()),
                ).captured.single
                as List<StudioNote>;
        expect(sent.single.tick, 480);
        expect(state().notesDirty, isFalse);
      },
    );

    test(
      'when saving fails, then exposes the failure and keeps the notes',
      () async {
        await load();
        when(
          () => repository.saveNotes(any(), any()),
        ).thenThrow(const Failure(FailureCode.network));
        vm().toggleStep(kick, 2);

        await vm().saveNotes(testPatternId);

        expect(state().failure, const Failure(FailureCode.network));
        expect(state().currentNotes, hasLength(1));
      },
    );

    test('when the transport reaches a step, then plays its notes', () async {
      await load(
        notes: [
          StudioNote(channelId: kick, tick: 0),
          StudioNote(channelId: snare, tick: 240 * 4, pitch: 72, velocity: 127),
        ],
      );

      metronome.onStep!(0);
      metronome.onStep!(4);
      // Step 68 loops back to step 4 of a 64-step pattern.
      metronome.onStep!(68);

      expect(audio.samples.map((s) => s.sample), [
        SampleKind.kick,
        SampleKind.snare,
        SampleKind.snare,
      ]);
      // C6 is one octave above C5 → double speed; full velocity → volume 0.8.
      expect(audio.samples[1].rate, closeTo(2, 1e-9));
      expect(audio.samples[1].volume, closeTo(0.8, 1e-9));
    });

    test('when a channel is muted, then its notes are silent', () async {
      when(
        () => repository.updateChannel(
          any(),
          name: any(named: 'name'),
          volume: any(named: 'volume'),
          muted: any(named: 'muted'),
          pan: any(named: 'pan'),
          pitch: any(named: 'pitch'),
          startFrac: any(named: 'startFrac'),
          endFrac: any(named: 'endFrac'),
        ),
      ).thenAnswer(
        (_) async => testChannels().first.copyWith(muted: true),
      );
      await load(notes: [StudioNote(channelId: kick, tick: 0)]);

      await vm().toggleChannelMute(kick);
      metronome.onStep!(0);

      expect(state().channels.first.muted, isTrue);
      expect(audio.samples, isEmpty);
    });

    test('when muting fails, then the channel is restored', () async {
      when(
        () => repository.updateChannel(
          any(),
          name: any(named: 'name'),
          volume: any(named: 'volume'),
          muted: any(named: 'muted'),
          pan: any(named: 'pan'),
          pitch: any(named: 'pitch'),
          startFrac: any(named: 'startFrac'),
          endFrac: any(named: 'endFrac'),
        ),
      ).thenThrow(const Failure(FailureCode.forbidden));
      await load();

      await vm().toggleChannelMute(kick);

      expect(state().channels.first.muted, isFalse);
      expect(state().failure, const Failure(FailureCode.forbidden));
    });

    test(
      'when clicking the piano roll, then adds and removes pitched notes',
      () async {
        await load();
        vm().openPianoRoll(snare);
        expect(state().workspace, StudioWorkspace.pianoRoll);

        vm().togglePianoNote(720, 67);
        expect(state().currentNotes.single.pitch, 67);
        expect(state().currentNotes.single.channelId, snare);
        expect(
          audio.samples.single.rate,
          closeTo(StudioViewModel.rateForPitch(67), 1e-9),
        );

        vm().togglePianoNote(720, 67);
        expect(state().currentNotes, isEmpty);
      },
    );

    test(
      'when the piano roll snaps to beats, then notes start on a beat and last one',
      () async {
        await load();
        vm().openPianoRoll(snare);
        vm().setPianoRollSnap(GridSnap.beat);

        vm().togglePianoNote(1500, 60); // inside beat 2 (960..1919)

        final note = state().currentNotes.single;
        expect(state().pianoRollSnap, GridSnap.beat);
        expect(note.tick, 960);
        expect(note.lengthTicks, 960);
      },
    );

    test(
      'when the piano roll snaps to lines, then notes are half a step',
      () async {
        await load();
        vm().openPianoRoll(snare);
        vm().setPianoRollSnap(GridSnap.line);

        vm().togglePianoNote(250, 60);

        final note = state().currentNotes.single;
        expect(note.tick, 240);
        expect(note.lengthTicks, 120);

        vm().togglePianoNote(300, 60); // inside the note: removes it
        expect(state().currentNotes, isEmpty);
      },
    );

    test(
      'when a bar-long note would pass the pattern end, then it is cut',
      () async {
        await load();
        vm().openPianoRoll(snare);
        vm().setPianoRollSnap(GridSnap.bar);

        vm().togglePianoNote(3 * 3840 + 10, 60); // last bar of 4

        final note = state().currentNotes.single;
        expect(note.tick, 3 * 3840);
        expect(note.lengthTicks, 3840);
        expect(note.tick + note.lengthTicks, state().patternSteps * 240);
      },
    );

    test('when previewing, then plays the channel at the pitch', () async {
      await load();

      vm().preview(kick, pitch: 48);

      expect(audio.samples.single.sample, SampleKind.kick);
      expect(audio.samples.single.rate, closeTo(0.5, 1e-9));
    });

    test(
      'when shrinking the pattern, then drops notes beyond the end',
      () async {
        when(
          () => repository.updatePattern(
            any(),
            name: any(named: 'name'),
            colorIndex: any(named: 'colorIndex'),
            lengthBars: any(named: 'lengthBars'),
          ),
        ).thenAnswer(
          (_) async => testPattern(id: testPatternId, lengthBars: 1),
        );
        await load(
          notes: [
            StudioNote(channelId: kick, tick: 0),
            StudioNote(channelId: kick, tick: 3840),
          ],
        );

        await vm().setSelectedPatternLength(1);

        expect(state().currentNotes.single.tick, 0);
        expect(state().patternSteps, 16);
      },
    );

    test('when adding and deleting channels, then the rack follows', () async {
      final added = testChannels().first.copyWith(
        id: testRequestId,
        name: 'Snare',
        sample: SampleKind.snare,
        position: 4,
      );
      when(
        () => repository.createChannel(
          any(),
          sample: any(named: 'sample'),
          sampleId: any(named: 'sampleId'),
        ),
      ).thenAnswer((_) async => added);
      when(() => repository.deleteChannel(any())).thenAnswer((_) async {});
      await load(notes: [StudioNote(channelId: kick, tick: 0)]);

      await vm().addChannel(SampleKind.snare);
      expect(state().channels, hasLength(5));

      await vm().deleteChannel(kick);
      expect(state().channels.any((c) => c.id == kick), isFalse);
      expect(state().currentNotes, isEmpty);
    });

    test(
      'when the user is a read member, then cannot edit but can preview',
      () async {
        await load(access: ProjectAccess.read);

        vm().toggleStep(kick, 0);
        vm().togglePianoNote(0, 60);
        vm().preview(kick);

        expect(state().currentNotes, isEmpty);
        expect(audio.samples, hasLength(1));
      },
    );

    test('when computing rates, then follows semitones', () {
      expect(StudioViewModel.rateForPitch(60), 1);
      expect(StudioViewModel.rateForPitch(72), closeTo(2, 1e-9));
      expect(StudioViewModel.rateForPitch(48), closeTo(0.5, 1e-9));
    });
  });
}
