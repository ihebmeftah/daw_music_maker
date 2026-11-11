// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [ProjectRepository] registered in get_it to Riverpod.

@ProviderFor(projectRepository)
final projectRepositoryProvider = ProjectRepositoryProvider._();

/// Exposes the [ProjectRepository] registered in get_it to Riverpod.

final class ProjectRepositoryProvider
    extends
        $FunctionalProvider<
          ProjectRepository,
          ProjectRepository,
          ProjectRepository
        >
    with $Provider<ProjectRepository> {
  /// Exposes the [ProjectRepository] registered in get_it to Riverpod.
  ProjectRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProjectRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectRepository create(Ref ref) {
    return projectRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectRepository>(value),
    );
  }
}

String _$projectRepositoryHash() => r'96246d605cc3750ef24cd9859ab0ec69e3dafb72';

/// Exposes the [CollaborationRepository] registered in get_it to Riverpod.

@ProviderFor(collaborationRepository)
final collaborationRepositoryProvider = CollaborationRepositoryProvider._();

/// Exposes the [CollaborationRepository] registered in get_it to Riverpod.

final class CollaborationRepositoryProvider
    extends
        $FunctionalProvider<
          CollaborationRepository,
          CollaborationRepository,
          CollaborationRepository
        >
    with $Provider<CollaborationRepository> {
  /// Exposes the [CollaborationRepository] registered in get_it to Riverpod.
  CollaborationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collaborationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collaborationRepositoryHash();

  @$internal
  @override
  $ProviderElement<CollaborationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollaborationRepository create(Ref ref) {
    return collaborationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollaborationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollaborationRepository>(value),
    );
  }
}

String _$collaborationRepositoryHash() =>
    r'40e110413ec06275412d11f57f24ca0a97210a57';
