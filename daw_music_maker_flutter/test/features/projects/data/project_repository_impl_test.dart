import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/data/project_repository_impl.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockEndpointProject endpoint;
  late ProjectRepositoryImpl repository;

  setUpAll(registerTestFallbacks);

  setUp(() {
    endpoint = MockEndpointProject();
    repository = ProjectRepositoryImpl(endpoint);
  });

  group('Given the ProjectRepositoryImpl', () {
    test('when creating, then delegates the request', () async {
      final request = CreateProjectRequest(
        name: 'A',
        description: '',
        genres: const [],
        visibility: ProjectVisibility.public,
        allowContributions: true,
      );
      when(
        () => endpoint.create(request),
      ).thenAnswer((_) async => testProject());

      final result = await repository.create(request);

      expect(result.id, testRequestId);
      verify(() => endpoint.create(request)).called(1);
    });

    test('when getting by id, then delegates the id', () async {
      when(
        () => endpoint.getById(testRequestId),
      ).thenAnswer((_) async => testProject());

      await repository.getById(testRequestId);

      verify(() => endpoint.getById(testRequestId)).called(1);
    });

    test('when listing, then passes limit and offset', () async {
      when(
        () => endpoint.listMine(limit: 20, offset: 40),
      ).thenAnswer((_) async => emptyPage);
      when(
        () => endpoint.listShared(limit: 10, offset: 0),
      ).thenAnswer((_) async => emptyPage);

      await repository.listMine(limit: 20, offset: 40);
      await repository.listShared(limit: 10, offset: 0);

      verify(() => endpoint.listMine(limit: 20, offset: 40)).called(1);
      verify(() => endpoint.listShared(limit: 10, offset: 0)).called(1);
    });

    test('when discovering, then passes the query', () async {
      when(
        () => endpoint.discover(query: 'lofi', limit: 20, offset: 0),
      ).thenAnswer((_) async => emptyPage);

      await repository.discover(query: 'lofi', limit: 20, offset: 0);

      verify(
        () => endpoint.discover(query: 'lofi', limit: 20, offset: 0),
      ).called(1);
    });

    test('when updating and deleting, then delegates', () async {
      final request = UpdateProjectRequest(
        name: 'B',
        description: '',
        genres: const [],
        visibility: ProjectVisibility.private,
        allowContributions: false,
      );
      when(
        () => endpoint.update(testRequestId, request),
      ).thenAnswer((_) async => testProject());
      when(() => endpoint.delete(testRequestId)).thenAnswer((_) async {});

      await repository.update(testRequestId, request);
      await repository.delete(testRequestId);

      verify(() => endpoint.update(testRequestId, request)).called(1);
      verify(() => endpoint.delete(testRequestId)).called(1);
    });

    test(
      'when the server rejects input, then maps to validation with fieldErrors',
      () {
        when(() => endpoint.create(any())).thenThrow(
          AppException(
            code: ErrorCode.validation,
            fieldErrors: {'name': 'Name is required'},
          ),
        );

        expect(
          repository.create(
            CreateProjectRequest(
              name: '',
              description: '',
              genres: const [],
              visibility: ProjectVisibility.private,
              allowContributions: false,
            ),
          ),
          throwsA(
            isA<Failure>()
                .having((f) => f.code, 'code', FailureCode.validation)
                .having(
                  (f) => f.fieldError('name'),
                  'name error',
                  'Name is required',
                ),
          ),
        );
      },
    );

    test('when the project is not visible, then maps to notFound', () {
      when(
        () => endpoint.getById(any()),
      ).thenThrow(AppException(code: ErrorCode.notFound));

      expect(
        repository.getById(testRequestId),
        throwsA(const Failure(FailureCode.notFound)),
      );
    });

    test('when offline, then maps to network', () {
      when(
        () => endpoint.delete(any()),
      ).thenThrow(const ServerpodClientNetworkException('offline'));

      expect(
        repository.delete(testRequestId),
        throwsA(const Failure(FailureCode.network)),
      );
    });
  });
}
