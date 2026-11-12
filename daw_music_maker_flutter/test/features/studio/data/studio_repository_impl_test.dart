import 'dart:typed_data';

import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/studio/data/studio_clip.dart';
import 'package:daw_music_maker/features/studio/data/studio_note.dart';
import 'package:daw_music_maker/features/studio/data/studio_repository_impl.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockEndpointProject endpoint;
  late MockEndpointPattern patterns;
  late MockEndpointChannel channels;
  late MockEndpointPlaylist playlist;
  late MockEndpointSample samplesEndpoint;
  late StudioRepositoryImpl repository;

  setUpAll(() {
    registerTestFallbacks();
    registerFallbackValue(UpdateProjectTempoRequest(bpm: 120));
    registerFallbackValue(CreatePatternRequest(projectId: testRequestId));
    registerFallbackValue(
      UpdatePatternRequest(name: 'x', colorIndex: 0, lengthBars: 4),
    );
  });

  setUp(() {
    endpoint = MockEndpointProject();
    patterns = MockEndpointPattern();
    channels = MockEndpointChannel();
    playlist = MockEndpointPlaylist();
    samplesEndpoint = MockEndpointSample();
    repository = StudioRepositoryImpl(
      endpoint,
      patterns,
      channels,
      playlist,
      samplesEndpoint,
    );
  });

  group('Given the StudioRepository patterns', () {
    final pattern = testPattern(id: testPatternId);

    test('when listing, then returns the project patterns', () async {
      when(() => patterns.list(any())).thenAnswer((_) async => [pattern]);

      expect(await repository.listPatterns(testRequestId), [pattern]);
      verify(() => patterns.list(testRequestId)).called(1);
    });

    test(
      'when creating, then sends only the project id (server defaults)',
      () async {
        when(() => patterns.create(any())).thenAnswer((_) async => pattern);

        await repository.createPattern(testRequestId);

        final request =
            verify(() => patterns.create(captureAny())).captured.single
                as CreatePatternRequest;
        expect(request.projectId, testRequestId);
        expect(request.name, isNull);
        expect(request.colorIndex, isNull);
        expect(request.lengthBars, isNull);
      },
    );

    test('when updating, then trims the name', () async {
      when(
        () => patterns.update(any(), any()),
      ).thenAnswer((_) async => pattern);

      await repository.updatePattern(
        testPatternId,
        name: '  Drop  ',
        colorIndex: 3,
        lengthBars: 8,
      );

      final request =
          verify(
                () => patterns.update(testPatternId, captureAny()),
              ).captured.single
              as UpdatePatternRequest;
      expect(request.name, 'Drop');
      expect(request.colorIndex, 3);
      expect(request.lengthBars, 8);
    });

    test('when cloning and deleting, then delegates by id', () async {
      when(() => patterns.clone(any())).thenAnswer((_) async => pattern);
      when(() => patterns.delete(any())).thenAnswer((_) async {});

      await repository.clonePattern(testPatternId);
      await repository.deletePattern(testPatternId);

      verify(() => patterns.clone(testPatternId)).called(1);
      verify(() => patterns.delete(testPatternId)).called(1);
    });

    test('when deleting the last pattern, then throws conflict', () {
      when(
        () => patterns.delete(any()),
      ).thenThrow(AppException(code: ErrorCode.conflict));

      expect(
        repository.deletePattern(testPatternId),
        throwsA(const Failure(FailureCode.conflict)),
      );
    });
  });

  group('Given the StudioRepository channels and notes', () {
    final channel = ChannelResponse(
      id: testChannelIds[0],
      projectId: testRequestId,
      name: 'Kick',
      sample: SampleKind.kick,
      volume: 0.8,
      muted: false,
      pan: 0,
      pitch: 0,
      startFrac: 0,
      endFrac: 1,
      position: 0,
    );

    setUpAll(() {
      registerFallbackValue(
        CreateChannelRequest(projectId: testRequestId, sample: SampleKind.kick),
      );
      registerFallbackValue(
        UpdateChannelRequest(name: 'x', volume: 1, muted: false),
      );
      registerFallbackValue(SavePatternNotesRequest(notes: []));
    });

    test('when creating a channel, then sends the sample', () async {
      when(() => channels.create(any())).thenAnswer((_) async => channel);

      await repository.createChannel(testRequestId, sample: SampleKind.snare);

      final request =
          verify(() => channels.create(captureAny())).captured.single
              as CreateChannelRequest;
      expect(request.sample, SampleKind.snare);
      expect(request.name, isNull);
    });

    test('when updating a channel, then trims the name', () async {
      when(
        () => channels.update(any(), any()),
      ).thenAnswer((_) async => channel);

      await repository.updateChannel(
        channel.id,
        name: ' Big Kick ',
        volume: 0.5,
        muted: true,
      );

      final request =
          verify(
                () => channels.update(channel.id, captureAny()),
              ).captured.single
              as UpdateChannelRequest;
      expect(request.name, 'Big Kick');
      expect(request.volume, 0.5);
      expect(request.muted, isTrue);
    });

    test(
      'when saving notes, then sends them all and maps the result',
      () async {
        when(() => patterns.saveNotes(any(), any())).thenAnswer(
          (_) async => [
            NoteResponse(
              id: testRequestId,
              channelId: channel.id,
              tick: 240,
              lengthTicks: 240,
              pitch: 60,
              velocity: 100,
            ),
          ],
        );

        final saved = await repository.saveNotes(testPatternId, [
          StudioNote(channelId: channel.id, tick: 240),
        ]);

        final request =
            verify(
                  () => patterns.saveNotes(testPatternId, captureAny()),
                ).captured.single
                as SavePatternNotesRequest;
        expect(request.notes.single.tick, 240);
        expect(request.notes.single.pitch, 60);
        expect(saved.single.step, 1);
      },
    );

    test('when the server rejects notes, then throws validation', () {
      when(() => patterns.saveNotes(any(), any())).thenThrow(
        AppException(
          code: ErrorCode.validation,
          fieldErrors: {'notes': 'Note 1: pitch must be 0–127'},
        ),
      );

      expect(
        repository.saveNotes(testPatternId, const []),
        throwsA(
          isA<Failure>().having((f) => f.code, 'code', FailureCode.validation),
        ),
      );
    });
  });

  group('Given the StudioRepository playlist', () {
    setUpAll(() => registerFallbackValue(SavePlaylistRequest(clips: [])));

    test('when listing, then maps clips', () async {
      when(() => playlist.list(any())).thenAnswer(
        (_) async => [
          ClipResponse(
            id: testRequestId,
            patternId: testPatternId,
            track: 2,
            startStep: 128,
          ),
        ],
      );

      final clips = await repository.listClips(testRequestId);

      expect(
        clips.single,
        StudioClip(patternId: testPatternId, track: 2, startStep: 128),
      );
    });

    test('when saving, then sends every clip', () async {
      when(() => playlist.save(any(), any())).thenAnswer((_) async => []);

      await repository.saveClips(testRequestId, [
        StudioClip(patternId: testPatternId, track: 0, startStep: 64),
      ]);

      final request =
          verify(
                () => playlist.save(testRequestId, captureAny()),
              ).captured.single
              as SavePlaylistRequest;
      expect(request.clips.single.startStep, 64);
    });

    test('when clips overlap on the server, then throws validation', () {
      when(() => playlist.save(any(), any())).thenThrow(
        AppException(
          code: ErrorCode.validation,
          fieldErrors: {'clips': 'Clip 2: overlaps another clip on the track'},
        ),
      );

      expect(
        repository.saveClips(testRequestId, const []),
        throwsA(
          isA<Failure>().having((f) => f.code, 'code', FailureCode.validation),
        ),
      );
    });
  });

  group('Given the StudioRepository samples and sampler', () {
    final channel = ChannelResponse(
      id: testChannelIds[0],
      projectId: testRequestId,
      name: 'Vox',
      sampleId: otherTestId,
      volume: 0.8,
      muted: false,
      pan: 0,
      pitch: 0,
      startFrac: 0,
      endFrac: 1,
      position: 0,
    );

    setUpAll(() {
      registerFallbackValue(ChopChannelRequest(slices: 2));
      registerFallbackValue(
        FinishSampleUploadRequest(
          projectId: testRequestId,
          uploadId: testRequestId,
          fileName: 'a.wav',
        ),
      );
      registerFallbackValue(
        CreateChannelRequest(projectId: testRequestId, sample: SampleKind.kick),
      );
      registerFallbackValue(
        UpdateChannelRequest(name: 'x', volume: 1, muted: false),
      );
      registerFallbackValue(
        RequestSampleUploadRequest(
          projectId: testRequestId,
          fileName: 'a.wav',
          sizeBytes: 1,
        ),
      );
    });

    test('when listing samples, then delegates by project', () async {
      final sample = testSample(id: otherTestId);
      when(() => samplesEndpoint.list(any())).thenAnswer((_) async => [sample]);

      expect(await repository.listSamples(testRequestId), [sample]);
      verify(() => samplesEndpoint.list(testRequestId)).called(1);
    });

    test('when deleting a sample, then delegates by id', () async {
      when(() => samplesEndpoint.delete(any())).thenAnswer((_) async {});

      await repository.deleteSample(otherTestId);

      verify(() => samplesEndpoint.delete(otherTestId)).called(1);
    });

    test(
      'when an upload is refused, then maps the error and never finishes',
      () async {
        when(() => samplesEndpoint.requestUpload(any())).thenThrow(
          AppException(
            code: ErrorCode.validation,
            fieldErrors: {'sizeBytes': 'Files must be at most 10 MB'},
          ),
        );

        await expectLater(
          repository.uploadSample(
            testRequestId,
            fileName: 'big.wav',
            bytes: Uint8List(16),
          ),
          throwsA(
            isA<Failure>()
                .having((f) => f.code, 'code', FailureCode.validation)
                .having(
                  (f) => f.fieldError('sizeBytes'),
                  'field',
                  'Files must be at most 10 MB',
                ),
          ),
        );
        final request =
            verify(
                  () => samplesEndpoint.requestUpload(captureAny()),
                ).captured.single
                as RequestSampleUploadRequest;
        expect(request.fileName, 'big.wav');
        expect(request.sizeBytes, 16);
        expect(request.projectId, testRequestId);
        verifyNever(() => samplesEndpoint.finishUpload(any()));
      },
    );

    test(
      'when creating a channel from an upload, then sends the sample id',
      () async {
        when(() => channels.create(any())).thenAnswer((_) async => channel);

        await repository.createChannel(testRequestId, sampleId: otherTestId);

        final request =
            verify(() => channels.create(captureAny())).captured.single
                as CreateChannelRequest;
        expect(request.sampleId, otherTestId);
        expect(request.sample, isNull);
      },
    );

    test(
      'when updating sampler settings, then sends pan, pitch and region',
      () async {
        when(
          () => channels.update(any(), any()),
        ).thenAnswer((_) async => channel);

        await repository.updateChannel(
          channel.id,
          name: 'Vox',
          volume: 0.6,
          muted: false,
          pan: -0.5,
          pitch: 7,
          startFrac: 0.25,
          endFrac: 0.75,
        );

        final request =
            verify(
                  () => channels.update(channel.id, captureAny()),
                ).captured.single
                as UpdateChannelRequest;
        expect(request.pan, -0.5);
        expect(request.pitch, 7);
        expect(request.startFrac, 0.25);
        expect(request.endFrac, 0.75);
      },
    );

    test('when chopping, then sends the slice count', () async {
      when(
        () => channels.chop(any(), any()),
      ).thenAnswer((_) async => [channel]);

      final created = await repository.chopChannel(channel.id, 8);

      final request =
          verify(() => channels.chop(channel.id, captureAny())).captured.single
              as ChopChannelRequest;
      expect(request.slices, 8);
      expect(created, [channel]);
    });
  });

  group('Given the StudioRepository', () {
    test('when loading, then fetches the project by id', () async {
      when(
        () => endpoint.getById(any()),
      ).thenAnswer((_) async => testProject());

      final project = await repository.loadProject(testRequestId);

      expect(project.id, testRequestId);
      verify(() => endpoint.getById(testRequestId)).called(1);
    });

    test(
      'when saving the tempo, then sends an UpdateProjectTempoRequest',
      () async {
        when(
          () => endpoint.updateTempo(any(), any()),
        ).thenAnswer((_) async => testProject(bpm: 140));

        final saved = await repository.saveTempo(testRequestId, 140);

        expect(saved.bpm, 140);
        final request =
            verify(
                  () => endpoint.updateTempo(testRequestId, captureAny()),
                ).captured.single
                as UpdateProjectTempoRequest;
        expect(request.bpm, 140);
      },
    );

    test(
      'when the server rejects the tempo, then throws a validation Failure',
      () {
        when(() => endpoint.updateTempo(any(), any())).thenThrow(
          AppException(
            code: ErrorCode.validation,
            fieldErrors: {'bpm': 'Tempo must be between 20 and 999 BPM'},
          ),
        );

        expect(
          repository.saveTempo(testRequestId, 5),
          throwsA(
            isA<Failure>()
                .having((f) => f.code, 'code', FailureCode.validation)
                .having((f) => f.fieldError('bpm'), 'bpm', isNotNull),
          ),
        );
      },
    );

    test('when the project is not visible, then throws notFound', () {
      when(
        () => endpoint.getById(any()),
      ).thenThrow(AppException(code: ErrorCode.notFound));

      expect(
        repository.loadProject(testRequestId),
        throwsA(const Failure(FailureCode.notFound)),
      );
    });
  });
}
