import 'package:daw_music_maker/core/audio/audio_providers.dart';
import 'package:daw_music_maker/core/audio/metronome.dart';
import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/studio/data/studio_clip.dart';
import 'package:daw_music_maker/features/studio/data/studio_note.dart';
import 'package:daw_music_maker/features/studio/data/studio_providers.dart';
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

  final introId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4ed1');
  final dropId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4ed2');
  final intro = testPattern(id: introId, name: 'Intro', lengthBars: 2);
  final drop = testPattern(
    id: dropId,
    name: 'Drop',
    lengthBars: 4,
    position: 1,
  );
  final kick = testChannelIds[0];
  final snare = testChannelIds[1];

  final provider = studioViewModelProvider(testRequestId);
  StudioViewModel vm() => container.read(provider.notifier);
  StudioState state() => container.read(provider).requireValue;

  Future<void> load({
    ProjectAccess access = ProjectAccess.owner,
    List<StudioClip> clips = const [],
  }) async {
    stubPatterns(repository, [intro, drop], null, const [], clips);
    when(() => repository.listNotes(introId)).thenAnswer(
      (_) async => [StudioNote(channelId: kick, tick: 0)],
    );
    when(() => repository.listNotes(dropId)).thenAnswer(
      (_) async => [StudioNote(channelId: snare, tick: 0)],
    );
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

  group('Given the playlist', () {
    test('when loaded, then has the saved clips and the song length', () async {
      await load(
        clips: [
          StudioClip(patternId: introId, track: 0, startBar: 0),
          StudioClip(patternId: dropId, track: 1, startBar: 2),
        ],
      );

      expect(state().clips, hasLength(2));
      expect(state().songBars, 6);
      expect(state().mode, TransportMode.pattern);
      expect(state().loopBars, 2);
    });

    test('when switching to SONG, then the loop follows the song', () async {
      await load(clips: [StudioClip(patternId: dropId, track: 0, startBar: 4)]);

      vm().setMode(TransportMode.song);
      await Future<void>.delayed(Duration.zero);

      expect(state().loopBars, 8);
      expect(state().notes.containsKey(dropId), isTrue);
      vm().toggleMode();
      expect(state().mode, TransportMode.pattern);
    });

    test(
      'when clicking an empty cell, then places the selected pattern',
      () async {
        await load();

        vm().togglePlaylistCell(3, 5);

        expect(
          state().clips.single,
          StudioClip(patternId: introId, track: 3, startBar: 5),
        );
        expect(state().playlistDirty, isTrue);
      },
    );

    test('when clicking inside a clip, then removes it', () async {
      await load(clips: [StudioClip(patternId: dropId, track: 0, startBar: 0)]);

      vm().togglePlaylistCell(0, 3); // bar 3 is inside the 4-bar Drop clip

      expect(state().clips, isEmpty);
    });

    test(
      'when a clip would overlap or pass the end, then nothing is placed',
      () async {
        await load(
          clips: [StudioClip(patternId: dropId, track: 0, startBar: 4)],
        );

        vm().togglePlaylistCell(0, 3); // Intro (2 bars) at 3 would cover bar 4
        vm().togglePlaylistCell(1, 255); // would end after bar 256

        expect(state().clips, hasLength(1));
      },
    );

    test('when right-clicking a clip, then selects its pattern', () async {
      await load(clips: [StudioClip(patternId: dropId, track: 2, startBar: 0)]);

      vm().selectClipPattern(2, 1);

      expect(state().selectedPattern, drop);
    });

    test('when saving, then sends the clips', () async {
      await load();
      vm().togglePlaylistCell(0, 0);

      await vm().savePlaylist();

      final sent =
          verify(
                () => repository.saveClips(testRequestId, captureAny()),
              ).captured.single
              as List<StudioClip>;
      expect(sent.single.patternId, introId);
      expect(state().playlistDirty, isFalse);
    });

    test('when saving fails, then exposes the failure', () async {
      await load();
      when(
        () => repository.saveClips(any(), any()),
      ).thenThrow(const Failure(FailureCode.validation));
      vm().togglePlaylistCell(0, 0);

      await vm().savePlaylist();

      expect(state().failure, const Failure(FailureCode.validation));
    });

    test(
      'when playing the song, then each clip plays its pattern at its bar',
      () async {
        await load(
          clips: [
            StudioClip(patternId: introId, track: 0, startBar: 0),
            StudioClip(patternId: dropId, track: 1, startBar: 2),
          ],
        );
        vm().setMode(TransportMode.song);
        await Future<void>.delayed(Duration.zero);

        metronome.onStep!(0); // bar 1: Intro → kick
        metronome.onStep!(16); // bar 2: Intro step 16 → nothing on that step
        metronome.onStep!(32); // bar 3: Drop starts → snare
        metronome.onStep!(96 + 32); // song is 6 bars (96 steps): loops → snare

        expect(audio.samples.map((s) => s.sample), [
          SampleKind.kick,
          SampleKind.snare,
          SampleKind.snare,
        ]);
      },
    );

    test('when in PAT mode, then the playlist is not played', () async {
      await load(clips: [StudioClip(patternId: dropId, track: 0, startBar: 0)]);

      metronome.onStep!(0);

      // Only the selected pattern (Intro → kick) plays.
      expect(audio.samples.single.sample, SampleKind.kick);
    });

    test('when a pattern is deleted, then its clips go too', () async {
      when(() => repository.deletePattern(any())).thenAnswer((_) async {});
      await load(
        clips: [
          StudioClip(patternId: introId, track: 0, startBar: 0),
          StudioClip(patternId: dropId, track: 1, startBar: 0),
        ],
      );

      await vm().deleteSelectedPattern(); // Intro is selected

      expect(state().clips.single.patternId, dropId);
    });

    test(
      'when a pattern grows into the next clip, then the later clip is dropped',
      () async {
        when(
          () => repository.updatePattern(
            any(),
            name: any(named: 'name'),
            colorIndex: any(named: 'colorIndex'),
            lengthBars: any(named: 'lengthBars'),
          ),
        ).thenAnswer(
          (_) async => testPattern(id: introId, name: 'Intro', lengthBars: 8),
        );
        await load(
          clips: [
            StudioClip(patternId: introId, track: 0, startBar: 0),
            StudioClip(patternId: dropId, track: 0, startBar: 4),
            StudioClip(patternId: dropId, track: 1, startBar: 4),
          ],
        );

        await vm().setSelectedPatternLength(8);

        expect(state().clips, hasLength(2));
        expect(
          state().clips.any((c) => c.track == 0 && c.startBar == 4),
          isFalse,
        );
      },
    );

    test(
      'when the user is a read member, then cannot change the playlist',
      () async {
        await load(access: ProjectAccess.read);

        vm().togglePlaylistCell(0, 0);
        vm().setMode(TransportMode.song);

        expect(state().clips, isEmpty);
        expect(state().mode, TransportMode.song);
      },
    );
  });
}
