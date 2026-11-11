import 'dart:async';

import 'package:daw_music_maker/core/audio/audio_providers.dart';
import 'package:daw_music_maker/core/audio/metronome.dart';
import 'package:daw_music_maker/core/errors/failure.dart';
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

  final provider = studioViewModelProvider(testRequestId);
  StudioViewModel vm() => container.read(provider.notifier);
  StudioState state() => container.read(provider).requireValue;

  Future<void> load({ProjectAccess access = ProjectAccess.owner}) async {
    when(
      () => repository.loadProject(any()),
    ).thenAnswer((_) async => testProject(access: access, bpm: 120));
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
      ],
    );
    when(() => repository.saveTempo(any(), any())).thenAnswer(
      (inv) async => testProject(bpm: inv.positionalArguments[1] as double),
    );
  });

  group('Given the StudioViewModel', () {
    test(
      'when loaded, then shows the saved tempo and is not playing',
      () async {
        await load();

        expect(state().bpm, 120);
        expect(state().savedBpm, 120);
        expect(state().isPlaying, isFalse);
        expect(state().canEdit, isTrue);
        expect(metronome.bpm, 120);
      },
    );

    test('when loading fails, then exposes the Failure', () async {
      when(
        () => repository.loadProject(any()),
      ).thenThrow(const Failure(FailureCode.notFound));
      container.listen(provider, (_, _) {});

      await expectLater(
        container.read(provider.future),
        throwsA(isA<Failure>()),
      );
      expect(
        container.read(provider).error,
        const Failure(FailureCode.notFound),
      );
    });

    test(
      'when setting a tempo, then clamps, rounds and updates the metronome',
      () async {
        await load();

        vm().setBpm(1500);
        expect(state().bpm, 999);
        vm().setBpm(5);
        expect(state().bpm, 20);
        vm().setBpm(128.456);

        expect(state().bpm, 128.46);
        expect(state().isDirty, isTrue);
        expect(metronome.bpm, 128.46);
        verifyNever(() => repository.saveTempo(any(), any()));
      },
    );

    test('when adjusting, then changes the tempo without saving', () async {
      await load();

      vm().adjust(3);
      vm().adjust(-0.5);

      expect(state().bpm, 122.5);
      expect(metronome.bpm, 122.5);
      verifyNever(() => repository.saveTempo(any(), any()));
    });

    test('when saving, then persists and marks the tempo as saved', () async {
      await load();
      vm().setBpm(140);

      await vm().save();

      verify(() => repository.saveTempo(testRequestId, 140)).called(1);
      expect(state().savedBpm, 140);
      expect(state().isDirty, isFalse);
    });

    test('when nothing changed, then save does not call the server', () async {
      await load();

      await vm().save();

      verifyNever(() => repository.saveTempo(any(), any()));
    });

    test('when nudging, then changes by the delta and saves', () async {
      await load();

      await vm().nudge(1);
      await vm().nudge(-10);

      expect(state().bpm, 111);
      verify(() => repository.saveTempo(testRequestId, 121)).called(1);
      verify(() => repository.saveTempo(testRequestId, 111)).called(1);
    });

    test(
      'when the tempo changes during a save, then saves the latest after',
      () async {
        await load();
        final first = Completer<ProjectResponse>();
        when(
          () => repository.saveTempo(any(), 130),
        ).thenAnswer((_) => first.future);
        vm().setBpm(130);
        final saving = vm().save();

        vm().setBpm(150);
        await vm().save(); // queued while the first save is in flight
        first.complete(testProject(bpm: 130));
        await saving;

        verify(() => repository.saveTempo(testRequestId, 150)).called(1);
        expect(state().savedBpm, 150);
      },
    );

    test(
      'when saving fails, then keeps the tempo and exposes the Failure',
      () async {
        await load();
        when(
          () => repository.saveTempo(any(), any()),
        ).thenThrow(const Failure(FailureCode.forbidden));
        vm().setBpm(90);

        await vm().save();

        expect(state().failure, const Failure(FailureCode.forbidden));
        expect(state().bpm, 90);
        expect(state().isDirty, isTrue);
        expect(state().isSaving, isFalse);
      },
    );

    test(
      'when the user is a read member, then tempo changes are ignored',
      () async {
        await load(access: ProjectAccess.read);

        vm().setBpm(150);
        await vm().nudge(5);

        expect(state().canEdit, isFalse);
        expect(state().bpm, 120);
        verifyNever(() => repository.saveTempo(any(), any()));
      },
    );

    test('when toggling play, then starts and stops the metronome', () async {
      await load();

      await vm().togglePlay();
      expect(state().isPlaying, isTrue);
      expect(metronome.isRunning, isTrue);
      expect(audio.clicks, [true]);

      await vm().togglePlay();
      expect(state().isPlaying, isFalse);
      expect(metronome.isRunning, isFalse);
    });

    test(
      'when toggling mute, then the metronome goes silent and back',
      () async {
        await load();

        vm().toggleMute();
        expect(state().isMuted, isTrue);
        expect(metronome.muted, isTrue);
        await vm().togglePlay();
        expect(audio.clicks, isEmpty);
        await vm().togglePlay();

        vm().toggleMute();
        expect(state().isMuted, isFalse);
        expect(metronome.muted, isFalse);
        expect(vm().position, same(metronome));
      },
    );

    test('when the ViewModel is disposed, then the metronome stops', () async {
      await load();
      await vm().togglePlay();

      container.dispose();

      expect(metronome.isRunning, isFalse);
    });

    test('when normalizing, then clamps to 20–999 with 2 decimals', () {
      expect(StudioViewModel.normalize(0), 20);
      expect(StudioViewModel.normalize(1000), 999);
      expect(StudioViewModel.normalize(99.999), 100);
    });
  });
}
