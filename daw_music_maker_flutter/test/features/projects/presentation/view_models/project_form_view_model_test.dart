import 'dart:async';

import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/data/project_providers.dart';
import 'package:daw_music_maker/features/projects/presentation/view_models/project_form_view_model.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockProjectRepository repository;
  late ProviderContainer container;

  setUpAll(registerTestFallbacks);

  setUp(() {
    repository = MockProjectRepository();
    stubEmptyProjectLists(repository);
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [projectRepositoryProvider.overrideWithValue(repository)],
    );
  });

  Future<ProjectFormViewModel> ready(UuidValue? id) async {
    final p = projectFormViewModelProvider(id);
    container.listen(p, (_, _) {});
    await container.read(p.future);
    return container.read(p.notifier);
  }

  Future<ProjectResponse?> submit(ProjectFormViewModel vm) => vm.submit(
    name: '  Midnight Drive ',
    description: ' Synthwave ',
    genres: const ['synthwave'],
    visibility: ProjectVisibility.public,
    allowContributions: true,
  );

  group('Given the ProjectFormViewModel when creating', () {
    test('when built, then has no initial project', () async {
      await ready(null);

      expect(
        container.read(projectFormViewModelProvider(null)).value!.initial,
        isNull,
      );
    });

    test('when submitted, then sends a trimmed CreateProjectRequest', () async {
      when(
        () => repository.create(any()),
      ).thenAnswer((_) async => testProject());
      final vm = await ready(null);

      final saved = await submit(vm);

      expect(saved, isNotNull);
      final request =
          verify(() => repository.create(captureAny())).captured.single
              as CreateProjectRequest;
      expect(request.name, 'Midnight Drive');
      expect(request.description, 'Synthwave');
      expect(request.genres, ['synthwave']);
      expect(request.visibility, ProjectVisibility.public);
      expect(request.allowContributions, isTrue);
      expect(
        container.read(projectFormViewModelProvider(null)).value!.isSubmitting,
        isFalse,
      );
    });

    test(
      'when the server rejects it, then stores the failure with fieldErrors',
      () async {
        when(() => repository.create(any())).thenThrow(
          const Failure(
            FailureCode.validation,
            fieldErrors: {'name': 'Name is required'},
          ),
        );
        final vm = await ready(null);

        final saved = await submit(vm);

        expect(saved, isNull);
        final failure = container
            .read(projectFormViewModelProvider(null))
            .value!
            .failure;
        expect(failure?.code, FailureCode.validation);
        expect(failure?.fieldError('name'), 'Name is required');
      },
    );

    test('when clearing the failure, then it is removed', () async {
      when(
        () => repository.create(any()),
      ).thenThrow(const Failure(FailureCode.network));
      final vm = await ready(null);
      await submit(vm);

      vm.clearFailure();

      expect(
        container.read(projectFormViewModelProvider(null)).value!.failure,
        isNull,
      );
    });

    test('when submitted twice concurrently, then creates once', () async {
      final completer = Completer<ProjectResponse>();
      when(() => repository.create(any())).thenAnswer((_) => completer.future);
      final vm = await ready(null);

      final first = submit(vm);
      final second = await submit(vm);
      completer.complete(testProject());
      await first;

      expect(second, isNull);
      verify(() => repository.create(any())).called(1);
    });
  });

  group('Given the ProjectFormViewModel when editing', () {
    test('when built, then loads the project as initial', () async {
      when(
        () => repository.getById(testRequestId),
      ).thenAnswer((_) async => testProject(name: 'Old'));

      await ready(testRequestId);

      expect(
        container
            .read(projectFormViewModelProvider(testRequestId))
            .value!
            .initial
            ?.name,
        'Old',
      );
    });

    test('when submitted, then updates the project', () async {
      when(
        () => repository.getById(testRequestId),
      ).thenAnswer((_) async => testProject());
      when(
        () => repository.update(testRequestId, any()),
      ).thenAnswer((_) async => testProject(name: 'Midnight Drive'));
      final vm = await ready(testRequestId);

      final saved = await submit(vm);

      expect(saved?.name, 'Midnight Drive');
      final request =
          verify(
                () => repository.update(testRequestId, captureAny()),
              ).captured.single
              as UpdateProjectRequest;
      expect(request.name, 'Midnight Drive');
      verifyNever(() => repository.create(any()));
    });

    test(
      'when the project cannot be loaded, then build fails with a Failure',
      () async {
        when(
          () => repository.getById(testRequestId),
        ).thenThrow(const Failure(FailureCode.notFound));
        final p = projectFormViewModelProvider(testRequestId);
        container.listen(p, (_, _) {});

        await expectLater(container.read(p.future), throwsA(isA<Failure>()));
      },
    );
  });
}
