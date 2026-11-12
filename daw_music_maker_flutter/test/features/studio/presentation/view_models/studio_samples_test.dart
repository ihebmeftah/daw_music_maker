import 'dart:typed_data';

import 'package:daw_music_maker/core/audio/audio_providers.dart';
import 'package:daw_music_maker/core/audio/metronome.dart';
import 'package:daw_music_maker/core/audio/sound_source.dart';
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

  final voxId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f01');
  final newId = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f02');
  final voxChannelId = UuidValue.fromString(
    '0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4f03',
  );
  final vox = testSample(id: voxId, durationMs: 2000);
  final kick = testChannelIds[0];

  ChannelResponse voxChannel({double pan = 0, int pitch = 0}) =>
      ChannelResponse(
        id: voxChannelId,
        projectId: testRequestId,
        name: 'Vox',
        sampleId: voxId,
        volume: 0.5,
        muted: false,
        pan: pan,
        pitch: pitch,
        startFrac: 0.25,
        endFrac: 0.75,
        position: 4,
      );

  final provider = studioViewModelProvider(testRequestId);
  StudioViewModel vm() => container.read(provider.notifier);
  StudioState state() => container.read(provider).requireValue;

  Future<void> load({
    ProjectAccess access = ProjectAccess.owner,
    List<ChannelResponse>? channels,
    List<StudioNote> notes = const [],
    List<StudioClip> clips = const [],
    List<SampleResponse>? samples,
  }) async {
    stubPatterns(
      repository,
      null,
      channels,
      notes,
      clips,
      samples ?? [vox],
    );
    when(
      () => repository.loadProject(any()),
    ).thenAnswer((_) async => testProject(access: access));
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
  }

  void stubUpdateChannel() =>
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
        (inv) async => state().channels.firstWhere(
          (c) => c.id == inv.positionalArguments.first,
        ),
      );

  setUpAll(() {
    registerTestFallbacks();
    registerFallbackValue(Uint8List(0));
  });

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

  group('Given the studio samples', () {
    test('when loaded, then the uploaded samples are in the state', () async {
      await load();

      expect(state().samples, [vox]);
      expect(state().sampleById(voxId), vox);
      expect(state().sampleById(null), isNull);
    });
  });

  group('Given uploadFiles', () {
    test(
      'when a file fails the client checks, then it is listed and not sent',
      () async {
        await load();

        await vm().uploadFiles([
          (name: 'notes.txt', bytes: Uint8List(10)),
          (name: 'big.wav', bytes: Uint8List(10 * 1024 * 1024 + 1)),
        ]);

        expect(state().uploads.map((u) => u.error), [
          'Use a WAV, MP3, OGG or FLAC file',
          'Files must be at most 10 MB',
        ]);
        verifyNever(
          () => repository.uploadSample(
            any(),
            fileName: any(named: 'fileName'),
            bytes: any(named: 'bytes'),
            onProgress: any(named: 'onProgress'),
          ),
        );
      },
    );

    test(
      'when a valid file uploads, then progress is reported and the sample added',
      () async {
        await load();
        final progress = <double>[];
        final uploaded = testSample(id: newId, name: 'Pad');
        when(
          () => repository.uploadSample(
            any(),
            fileName: any(named: 'fileName'),
            bytes: any(named: 'bytes'),
            onProgress: any(named: 'onProgress'),
          ),
        ).thenAnswer((inv) async {
          final report =
              inv.namedArguments[#onProgress] as void Function(double);
          report(0.5);
          progress.add(state().uploads.single.progress);
          report(1);
          progress.add(state().uploads.single.progress);
          return uploaded;
        });

        await vm().uploadFiles([(name: 'pad.wav', bytes: Uint8List(100))]);

        expect(progress, [0.5, 1]);
        expect(state().uploads, isEmpty);
        expect(state().samples.first, uploaded);
        expect(state().samples, hasLength(2));
        verify(
          () => repository.uploadSample(
            testRequestId,
            fileName: 'pad.wav',
            bytes: any(named: 'bytes'),
            onProgress: any(named: 'onProgress'),
          ),
        ).called(1);
      },
    );

    test(
      'when the server refuses, then the entry keeps a friendly error',
      () async {
        await load();
        when(
          () => repository.uploadSample(
            any(),
            fileName: any(named: 'fileName'),
            bytes: any(named: 'bytes'),
            onProgress: any(named: 'onProgress'),
          ),
        ).thenThrow(
          const Failure(
            FailureCode.validation,
            fieldErrors: {'file': 'The file is not a valid WAV'},
          ),
        );

        await vm().uploadFiles([(name: 'fake.wav', bytes: Uint8List(100))]);

        final entry = state().uploads.single;
        expect(entry.error, 'The file is not a valid WAV');
        expect(entry.failure?.code, FailureCode.validation);

        vm().dismissUpload(entry.id);
        expect(state().uploads, isEmpty);
      },
    );

    test('when the user is a read member, then nothing is uploaded', () async {
      await load(access: ProjectAccess.read);

      await vm().uploadFiles([(name: 'pad.wav', bytes: Uint8List(100))]);

      expect(state().uploads, isEmpty);
    });
  });

  group('Given sample management', () {
    test(
      'when deleting a sample, then its channels, notes and clips go too',
      () async {
        when(() => repository.deleteSample(any())).thenAnswer((_) async {});
        await load(
          channels: [...testChannels(), voxChannel()],
          notes: [
            StudioNote(channelId: voxChannelId, tick: 0),
            StudioNote(channelId: kick, tick: 0),
          ],
          clips: [
            StudioClip(sampleId: voxId, lengthBars: 1, track: 0, startBar: 0),
            StudioClip(patternId: testPatternId, track: 1, startBar: 0),
          ],
        );

        await vm().deleteSample(voxId);

        verify(() => repository.deleteSample(voxId)).called(1);
        expect(state().samples, isEmpty);
        expect(state().channels.any((c) => c.id == voxChannelId), isFalse);
        expect(state().currentNotes.single.channelId, kick);
        expect(state().clips.single.patternId, testPatternId);
      },
    );

    test(
      'when adding channels for built-in and uploaded sounds, then selects them',
      () async {
        when(
          () => repository.createChannel(
            any(),
            sample: any(named: 'sample'),
            sampleId: any(named: 'sampleId'),
          ),
        ).thenAnswer((_) async => voxChannel());
        await load();

        final id = await vm().addChannelFor(sampleId: voxId);
        expect(id, voxChannelId);
        expect(state().selectedChannelId, voxChannelId);
        verify(
          () => repository.createChannel(testRequestId, sampleId: voxId),
        ).called(1);

        await vm().addChannelFor(kind: SampleKind.snare);
        verify(
          () =>
              repository.createChannel(testRequestId, sample: SampleKind.snare),
        ).called(1);
      },
    );

    test('when chopping, then the new channels are appended', () async {
      final slices = [
        voxChannel().copyWith(id: newId, name: 'Vox 1'),
        voxChannel().copyWith(id: testRequestId, name: 'Vox 2'),
      ];
      when(
        () => repository.chopChannel(any(), any()),
      ).thenAnswer((_) async => slices);
      await load(channels: [...testChannels(), voxChannel()]);

      await vm().chopChannel(voxChannelId, 2);

      verify(() => repository.chopChannel(voxChannelId, 2)).called(1);
      expect(state().channels.map((c) => c.name).toList().sublist(5), [
        'Vox 1',
        'Vox 2',
      ]);
    });
  });

  group('Given the sampler settings', () {
    test('when values go out of range, then they are clamped', () async {
      await load(channels: [voxChannel()]);

      vm().setSamplerSettings(voxChannelId, volume: 2, pan: -3, pitch: 40);

      final c = state().channels.single;
      expect(c.volume, 1);
      expect(c.pan, -1);
      expect(c.pitch, 24);
    });

    test(
      'when the start handle passes the end, then a minimal region is kept',
      () async {
        await load(channels: [voxChannel()]);

        vm().setSamplerSettings(voxChannelId, startFrac: 0.9);

        final c = state().channels.single;
        expect(c.endFrac, 0.75);
        expect(c.endFrac - c.startFrac, closeTo(0.001, 1e-9));
      },
    );

    test('when committing, then every setting is saved', () async {
      await load(channels: [voxChannel()]);
      stubUpdateChannel();
      vm().setSamplerSettings(voxChannelId, pan: 0.5, pitch: -7);

      await vm().commitChannel(voxChannelId);

      verify(
        () => repository.updateChannel(
          voxChannelId,
          name: 'Vox',
          volume: 0.5,
          muted: false,
          pan: 0.5,
          pitch: -7,
          startFrac: 0.25,
          endFrac: 0.75,
        ),
      ).called(1);
    });

    test('when saving fails, then the previous settings come back', () async {
      await load(channels: [voxChannel()]);
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

      // A mute toggle is applied optimistically, then reverted.
      await vm().toggleChannelMute(voxChannelId);

      expect(state().channels.single.muted, isFalse);
      expect(state().failure, const Failure(FailureCode.forbidden));
    });
  });

  group('Given playback of uploaded samples', () {
    test(
      'when a note plays, then uses the upload with channel pitch, pan and region',
      () async {
        await load(
          channels: [voxChannel(pan: -0.5, pitch: 12)],
          notes: [StudioNote(channelId: voxChannelId, tick: 0, velocity: 127)],
        );

        metronome.onStep!(0);

        final played = audio.samples.single;
        expect(played.source, UploadedSound(voxId, vox.url));
        expect((played.source as UploadedSound).url, vox.url);
        // Note C5 + channel +12 st → one octave up.
        expect(played.rate, closeTo(StudioViewModel.rateForPitch(72), 1e-9));
        expect(played.pan, -0.5);
        expect(played.startFrac, 0.25);
        expect(played.endFrac, 0.75);
        expect(played.volume, closeTo(0.5, 1e-9));
      },
    );

    test(
      'when previewing a browser item, then plays the drum or the upload',
      () async {
        await load();

        vm().previewSound(kind: SampleKind.openHat);
        vm().previewSound(sampleId: voxId);

        expect(audio.samples[0].sample, SampleKind.openHat);
        expect(audio.samples[1].sampleId, voxId);
      },
    );
  });

  group('Given audio clips on the playlist', () {
    test('when computing lengths, then follows duration and tempo', () async {
      await load();

      expect(vm().audioClipBars(testSample(id: newId, durationMs: 2000)), 1);
      expect(vm().audioClipBars(testSample(id: newId, durationMs: 9000)), 5);
      expect(vm().audioClipBars(testSample(id: newId, durationMs: null)), 1);
      expect(
        vm().audioClipBars(testSample(id: newId, durationMs: 600000)),
        64,
      );
    });

    test(
      'when dropping a sample, then places an audio clip unless it overlaps',
      () async {
        await load(
          samples: [testSample(id: voxId, durationMs: 9000)],
          clips: [StudioClip(patternId: testPatternId, track: 0, startBar: 8)],
        );

        vm().placeSampleClip(voxId, 0, 2); // 5 bars → 2..7, fits before bar 8
        vm().placeSampleClip(voxId, 0, 6); // would overlap
        vm().placeSampleClip(newId, 1, 0); // unknown sample

        final audioClips = state().clips.where((c) => c.isAudio).toList();
        expect(audioClips.single.startBar, 2);
        expect(audioClips.single.lengthBars, 5);
        expect(state().playlistDirty, isTrue);
      },
    );

    test(
      'when the song plays, then an audio clip starts once on its first step',
      () async {
        await load(
          clips: [
            StudioClip(sampleId: voxId, lengthBars: 2, track: 0, startBar: 1),
          ],
        );
        vm().setMode(TransportMode.song);
        await Future<void>.delayed(Duration.zero);

        metronome.onStep!(0); // bar 1: nothing
        metronome.onStep!(16); // bar 2: the clip starts
        metronome.onStep!(17); // inside the clip: no restart

        expect(audio.samples.single.sampleId, voxId);
      },
    );

    test('when right-clicking an audio clip, then previews it', () async {
      await load(
        clips: [
          StudioClip(sampleId: voxId, lengthBars: 1, track: 3, startBar: 0),
        ],
      );

      vm().selectClipPattern(3, 0);

      expect(audio.samples.single.sampleId, voxId);
      expect(state().selectedPattern!.id, testPatternId);
    });
  });
}
