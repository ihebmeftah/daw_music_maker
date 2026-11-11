import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/studio/data/studio_repository_impl.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockEndpointProject endpoint;
  late StudioRepositoryImpl repository;

  setUpAll(() {
    registerTestFallbacks();
    registerFallbackValue(UpdateProjectTempoRequest(bpm: 120));
  });

  setUp(() {
    endpoint = MockEndpointProject();
    repository = StudioRepositoryImpl(endpoint);
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
