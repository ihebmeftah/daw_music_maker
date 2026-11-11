// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of one paginated project list ([ProjectListKind]).
///
/// Errors of the first page surface as `AsyncError` with a `Failure`; errors
/// of later pages are kept in [ProjectListState.loadMoreFailure].

@ProviderFor(ProjectListViewModel)
final projectListViewModelProvider = ProjectListViewModelFamily._();

/// ViewModel of one paginated project list ([ProjectListKind]).
///
/// Errors of the first page surface as `AsyncError` with a `Failure`; errors
/// of later pages are kept in [ProjectListState.loadMoreFailure].
final class ProjectListViewModelProvider
    extends $AsyncNotifierProvider<ProjectListViewModel, ProjectListState> {
  /// ViewModel of one paginated project list ([ProjectListKind]).
  ///
  /// Errors of the first page surface as `AsyncError` with a `Failure`; errors
  /// of later pages are kept in [ProjectListState.loadMoreFailure].
  ProjectListViewModelProvider._({
    required ProjectListViewModelFamily super.from,
    required ProjectListKind super.argument,
  }) : super(
         retry: null,
         name: r'projectListViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectListViewModelHash();

  @override
  String toString() {
    return r'projectListViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProjectListViewModel create() => ProjectListViewModel();

  @override
  bool operator ==(Object other) {
    return other is ProjectListViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectListViewModelHash() =>
    r'3d436439a84ca51a722373681c1ecb06d43ab4d2';

/// ViewModel of one paginated project list ([ProjectListKind]).
///
/// Errors of the first page surface as `AsyncError` with a `Failure`; errors
/// of later pages are kept in [ProjectListState.loadMoreFailure].

final class ProjectListViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ProjectListViewModel,
          AsyncValue<ProjectListState>,
          ProjectListState,
          FutureOr<ProjectListState>,
          ProjectListKind
        > {
  ProjectListViewModelFamily._()
    : super(
        retry: null,
        name: r'projectListViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ViewModel of one paginated project list ([ProjectListKind]).
  ///
  /// Errors of the first page surface as `AsyncError` with a `Failure`; errors
  /// of later pages are kept in [ProjectListState.loadMoreFailure].

  ProjectListViewModelProvider call(ProjectListKind kind) =>
      ProjectListViewModelProvider._(argument: kind, from: this);

  @override
  String toString() => r'projectListViewModelProvider';
}

/// ViewModel of one paginated project list ([ProjectListKind]).
///
/// Errors of the first page surface as `AsyncError` with a `Failure`; errors
/// of later pages are kept in [ProjectListState.loadMoreFailure].

abstract class _$ProjectListViewModel extends $AsyncNotifier<ProjectListState> {
  late final _$args = ref.$arg as ProjectListKind;
  ProjectListKind get kind => _$args;

  FutureOr<ProjectListState> build(ProjectListKind kind);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProjectListState>, ProjectListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProjectListState>, ProjectListState>,
              AsyncValue<ProjectListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
