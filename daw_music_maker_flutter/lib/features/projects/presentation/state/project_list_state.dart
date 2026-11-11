import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'project_list_state.freezed.dart';

/// Which project list a [ProjectListState] holds.
enum ProjectListKind {
  /// Projects owned by the user.
  mine,

  /// Projects the user collaborates on.
  shared,

  /// Public projects of other users.
  discover,
}

/// A paginated project list.
@freezed
abstract class ProjectListState with _$ProjectListState {
  /// Creates the state.
  const factory ProjectListState({
    /// Projects loaded so far.
    @Default(<ProjectResponse>[]) List<ProjectResponse> items,

    /// Whether another page can be loaded.
    @Default(false) bool hasMore,

    /// Whether the next page is loading.
    @Default(false) bool isLoadingMore,

    /// Current discover search query (empty = no filter).
    @Default('') String query,

    /// Error of the last "load more" attempt.
    Failure? loadMoreFailure,
  }) = _ProjectListState;
}
