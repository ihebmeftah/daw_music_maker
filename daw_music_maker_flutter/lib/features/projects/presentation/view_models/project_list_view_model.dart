import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/project_providers.dart';
import '../../data/project_repository.dart';
import '../state/project_list_state.dart';

part 'project_list_view_model.g.dart';

/// ViewModel of one paginated project list ([ProjectListKind]).
///
/// Errors of the first page surface as `AsyncError` with a `Failure`; errors
/// of later pages are kept in [ProjectListState.loadMoreFailure].
@riverpod
class ProjectListViewModel extends _$ProjectListViewModel {
  /// Page size requested from the server.
  static const pageSize = 20;

  ProjectRepository get _repository => ref.read(projectRepositoryProvider);

  @override
  Future<ProjectListState> build(ProjectListKind kind) => _firstPage('');

  /// Reloads the first page, keeping the current query.
  Future<void> refresh() async {
    final query = state.value?.query ?? '';
    state = await AsyncValue.guard(() => _firstPage(query));
  }

  /// Filters the discover list by [query] (ignored for other lists).
  Future<void> search(String query) async {
    if (kind != ProjectListKind.discover) return;
    final trimmed = query.trim();
    if (trimmed == (state.value?.query ?? '')) return;
    state = const AsyncLoading<ProjectListState>();
    state = await AsyncValue.guard(() => _firstPage(trimmed));
  }

  /// Appends the next page. Ignored while loading or when nothing is left.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreFailure: null),
    );
    try {
      final page = await _fetch(current.query, current.items.length);
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          isLoadingMore: false,
          loadMoreFailure: mapGenericError(error),
        ),
      );
    }
  }

  Future<ProjectListState> _firstPage(String query) async {
    try {
      final page = await _fetch(query, 0);
      return ProjectListState(
        items: page.items,
        hasMore: page.hasMore,
        query: query,
      );
    } catch (error) {
      throw mapGenericError(error);
    }
  }

  Future<ProjectPageResponse> _fetch(String query, int offset) =>
      switch (kind) {
        ProjectListKind.mine => _repository.listMine(
          limit: pageSize,
          offset: offset,
        ),
        ProjectListKind.shared => _repository.listShared(
          limit: pageSize,
          offset: offset,
        ),
        ProjectListKind.discover => _repository.discover(
          query: query.isEmpty ? null : query,
          limit: pageSize,
          offset: offset,
        ),
      };
}
