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
  late ProviderContainer container;

  final idA = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4ea1');
  final idB = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4ea2');
  final idC = UuidValue.fromString('0190f1c2-7b7a-7cc0-8d4e-3f1b2c3d4ea3');
  final a = testPattern(id: idA, name: 'Intro', lengthBars: 4);
  final b = testPattern(id: idB, name: 'Drop', lengthBars: 8, position: 1);

  final provider = studioViewModelProvider(testRequestId);
  StudioViewModel vm() => container.read(provider.notifier);
  StudioState state() => container.read(provider).requireValue;

  Future<void> load({ProjectAccess access = ProjectAccess.owner}) async {
    when(
      () => repository.loadProject(any()),
    ).thenAnswer((_) async => testProject(access: access));
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
  }

  setUpAll(registerTestFallbacks);

  setUp(() {
    repository = MockStudioRepository();
    stubPatterns(repository, [a, b]);
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        studioRepositoryProvider.overrideWithValue(repository),
        metronomeProvider.overrideWithValue(Metronome(FakeAudioEngine())),
        audioEngineProvider.overrideWithValue(FakeAudioEngine()),
      ],
    );
  });

  group('Given the studio patterns', () {
    test(
      'when loaded, then the first pattern is selected and sets the loop',
      () async {
        await load();

        expect(state().patterns, [a, b]);
        expect(state().selectedPattern, a);
        expect(state().loopBars, 4);
      },
    );

    test('when selecting and stepping, then wraps around', () async {
      await load();

      vm().selectPattern(idB);
      expect(state().loopBars, 8);
      vm().stepPattern(1);
      expect(state().selectedPattern, a);
      vm().stepPattern(-1);
      expect(state().selectedPattern, b);
    });

    test('when creating, then appends and selects the new pattern', () async {
      final c = testPattern(id: idC, name: 'Pattern 3', position: 2);
      when(() => repository.createPattern(any())).thenAnswer((_) async => c);
      await load();

      await vm().createPattern();

      expect(state().patterns, [a, b, c]);
      expect(state().selectedPattern, c);
      verify(() => repository.createPattern(testRequestId)).called(1);
    });

    test('when cloning, then appends the copy and selects it', () async {
      final copy = testPattern(id: idC, name: 'Intro (copy)', position: 2);
      when(() => repository.clonePattern(any())).thenAnswer((_) async => copy);
      await load();

      await vm().cloneSelectedPattern();

      verify(() => repository.clonePattern(idA)).called(1);
      expect(state().selectedPattern, copy);
    });

    test(
      'when renaming, recoloring or resizing, then saves and replaces',
      () async {
        when(
          () => repository.updatePattern(
            any(),
            name: any(named: 'name'),
            colorIndex: any(named: 'colorIndex'),
            lengthBars: any(named: 'lengthBars'),
          ),
        ).thenAnswer(
          (inv) async => testPattern(
            id: inv.positionalArguments.first as UuidValue,
            name: inv.namedArguments[#name] as String,
            colorIndex: inv.namedArguments[#colorIndex] as int,
            lengthBars: inv.namedArguments[#lengthBars] as int,
          ),
        );
        await load();

        await vm().renameSelectedPattern('Verse');
        await vm().setSelectedPatternColor(5);
        await vm().setSelectedPatternLength(16);

        final selected = state().selectedPattern!;
        expect(selected.name, 'Verse');
        expect(selected.colorIndex, 5);
        expect(selected.lengthBars, 16);
        expect(state().loopBars, 16);
        expect(state().patterns.length, 2);
      },
    );

    test('when deleting, then removes it and selects the neighbor', () async {
      when(() => repository.deletePattern(any())).thenAnswer((_) async {});
      await load();
      vm().selectPattern(idB);

      await vm().deleteSelectedPattern();

      verify(() => repository.deletePattern(idB)).called(1);
      expect(state().patterns, [a]);
      expect(state().selectedPattern, a);
    });

    test(
      'when the server refuses, then exposes the failure and keeps the list',
      () async {
        when(
          () => repository.deletePattern(any()),
        ).thenThrow(const Failure(FailureCode.conflict));
        await load();

        await vm().deleteSelectedPattern();

        expect(state().failure, const Failure(FailureCode.conflict));
        expect(state().patterns, [a, b]);
        expect(state().isPatternBusy, isFalse);
      },
    );

    test(
      'when the user is a read member, then can select but not change',
      () async {
        await load(access: ProjectAccess.read);

        vm().selectPattern(idB);
        await vm().createPattern();
        await vm().setSelectedPatternLength(1);

        expect(state().selectedPattern, b);
        verifyNever(() => repository.createPattern(any()));
        verifyNever(
          () => repository.updatePattern(
            any(),
            name: any(named: 'name'),
            colorIndex: any(named: 'colorIndex'),
            lengthBars: any(named: 'lengthBars'),
          ),
        );
      },
    );

    test(
      'when patterns fail to load, then the studio shows the Failure',
      () async {
        when(
          () => repository.listPatterns(any()),
        ).thenThrow(const Failure(FailureCode.notFound));
        when(
          () => repository.loadProject(any()),
        ).thenAnswer((_) async => testProject());
        container.listen(provider, (_, _) {});

        await expectLater(
          container.read(provider.future),
          throwsA(isA<Failure>()),
        );
        expect(
          container.read(provider).error,
          const Failure(FailureCode.notFound),
        );
      },
    );
  });
}
