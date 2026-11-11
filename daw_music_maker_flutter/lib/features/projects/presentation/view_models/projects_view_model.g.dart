// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the projects screen.
///
/// Project listing is not built yet; for now it only handles signing out.

@ProviderFor(ProjectsViewModel)
final projectsViewModelProvider = ProjectsViewModelProvider._();

/// ViewModel of the projects screen.
///
/// Project listing is not built yet; for now it only handles signing out.
final class ProjectsViewModelProvider
    extends $NotifierProvider<ProjectsViewModel, void> {
  /// ViewModel of the projects screen.
  ///
  /// Project listing is not built yet; for now it only handles signing out.
  ProjectsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsViewModelHash();

  @$internal
  @override
  ProjectsViewModel create() => ProjectsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$projectsViewModelHash() => r'cf9c416e548dcd3de62b94bfc5acd36f1fcbfad9';

/// ViewModel of the projects screen.
///
/// Project listing is not built yet; for now it only handles signing out.

abstract class _$ProjectsViewModel extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
