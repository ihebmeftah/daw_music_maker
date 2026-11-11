import 'package:daw_music_maker/core/errors/failure.dart';
import 'package:daw_music_maker/features/projects/data/project_providers.dart';
import 'package:daw_music_maker/features/projects/presentation/state/project_list_state.dart';
import 'package:daw_music_maker/features/projects/presentation/view_models/project_list_view_model.dart';
import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

ProjectPageResponse _page(
  int count, {
  bool hasMore = false,
  int start = 0,
}) => ProjectPageResponse(
  items: [
    for (var i = 0; i < count; i++)
      testProject(
        id: UuidValue.fromString(
          '0190f1c2-7b7a-7cc0-8d4e-${(start + i).toString().padLeft(12, '0')}',
        ),
        name: 'P${start + i}',
      ),
  ],
  hasMore: hasMore,
);

void main() {
  late MockProjectRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockProjectRepository();
    stubEmptyProjectLists(repository);
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [projectRepositoryProvider.overrideWithValue(repository)],
    );
  });

  ProjectListViewModelProvider provider(ProjectListKind kind) {
    final p = projectListViewModelProvider(kind);
    container.listen(p, (_, _) {});
    return p;
  }

  group('Given the ProjectListViewModel', () {
    test('when built for "mine", then loads the first page', () async {
      when(
        () => repository.listMine(limit: 20, offset: 0),
      ).thenAnswer((_) async => _page(2, hasMore: true));
      final p = provider(ProjectListKind.mine);

      final state = await container.read(p.future);

      expect(state.items, hasLength(2));
      expect(state.hasMore, isTrue);
      verify(() => repository.listMine(limit: 20, offset: 0)).called(1);
    });

    test(
      'when built for "shared" and "discover", then calls their endpoints',
      () async {
        await container.read(provider(ProjectListKind.shared).future);
        await container.read(provider(ProjectListKind.discover).future);

        verify(() => repository.listShared(limit: 20, offset: 0)).called(1);
        verify(
          () => repository.discover(query: null, limit: 20, offset: 0),
        ).called(1);
      },
    );

    test(
      'when loading more, then appends the next page with the offset',
      () async {
        when(
          () => repository.listMine(limit: 20, offset: 0),
        ).thenAnswer((_) async => _page(20, hasMore: true));
        when(
          () => repository.listMine(limit: 20, offset: 20),
        ).thenAnswer((_) async => _page(3, start: 20));
        final p = provider(ProjectListKind.mine);
        await container.read(p.future);

        await container.read(p.notifier).loadMore();

        final state = container.read(p).value!;
        expect(state.items, hasLength(23));
        expect(state.hasMore, isFalse);
        expect(state.isLoadingMore, isFalse);
      },
    );

    test(
      'when nothing is left, then loadMore does not call the repository',
      () async {
        final p = provider(ProjectListKind.mine);
        await container.read(p.future);

        await container.read(p.notifier).loadMore();

        verify(() => repository.listMine(limit: 20, offset: 0)).called(1);
        verifyNever(() => repository.listMine(limit: 20, offset: 20));
      },
    );

    test(
      'when loading more fails, then keeps items and stores the failure',
      () async {
        when(
          () => repository.listMine(limit: 20, offset: 0),
        ).thenAnswer((_) async => _page(20, hasMore: true));
        when(
          () => repository.listMine(limit: 20, offset: 20),
        ).thenThrow(const Failure(FailureCode.network));
        final p = provider(ProjectListKind.mine);
        await container.read(p.future);

        await container.read(p.notifier).loadMore();

        final state = container.read(p).value!;
        expect(state.items, hasLength(20));
        expect(state.loadMoreFailure, const Failure(FailureCode.network));
        expect(state.isLoadingMore, isFalse);
      },
    );

    test(
      'when searching discover, then reloads with the trimmed query',
      () async {
        when(
          () => repository.discover(query: 'lofi', limit: 20, offset: 0),
        ).thenAnswer((_) async => _page(1));
        final p = provider(ProjectListKind.discover);
        await container.read(p.future);

        await container.read(p.notifier).search('  lofi ');

        final state = container.read(p).value!;
        expect(state.query, 'lofi');
        expect(state.items, hasLength(1));
      },
    );

    test('when searching a non-discover list, then nothing happens', () async {
      final p = provider(ProjectListKind.mine);
      await container.read(p.future);

      await container.read(p.notifier).search('lofi');

      expect(container.read(p).value!.query, '');
      verifyNever(
        () => repository.discover(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      );
    });

    test('when refreshing, then reloads the first page', () async {
      final p = provider(ProjectListKind.mine);
      await container.read(p.future);

      await container.read(p.notifier).refresh();

      verify(() => repository.listMine(limit: 20, offset: 0)).called(2);
    });

    test(
      'when the first page fails, then exposes an AsyncError with a Failure',
      () async {
        when(
          () => repository.listMine(limit: 20, offset: 0),
        ).thenThrow(const Failure(FailureCode.network));
        final p = provider(ProjectListKind.mine);

        await expectLater(container.read(p.future), throwsA(isA<Failure>()));

        expect(container.read(p).error, const Failure(FailureCode.network));
      },
    );
  });
}
