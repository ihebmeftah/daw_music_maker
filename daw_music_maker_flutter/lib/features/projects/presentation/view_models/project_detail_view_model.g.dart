// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the project detail screen: details, members, invitations,
/// join requests, and every collaboration action on them.

@ProviderFor(ProjectDetailViewModel)
final projectDetailViewModelProvider = ProjectDetailViewModelFamily._();

/// ViewModel of the project detail screen: details, members, invitations,
/// join requests, and every collaboration action on them.
final class ProjectDetailViewModelProvider
    extends $AsyncNotifierProvider<ProjectDetailViewModel, ProjectDetailState> {
  /// ViewModel of the project detail screen: details, members, invitations,
  /// join requests, and every collaboration action on them.
  ProjectDetailViewModelProvider._({
    required ProjectDetailViewModelFamily super.from,
    required UuidValue super.argument,
  }) : super(
         retry: null,
         name: r'projectDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectDetailViewModelHash();

  @override
  String toString() {
    return r'projectDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProjectDetailViewModel create() => ProjectDetailViewModel();

  @override
  bool operator ==(Object other) {
    return other is ProjectDetailViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectDetailViewModelHash() =>
    r'd01c23e2f87afc109dd69623a0dcdfd4ad6ae5d4';

/// ViewModel of the project detail screen: details, members, invitations,
/// join requests, and every collaboration action on them.

final class ProjectDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ProjectDetailViewModel,
          AsyncValue<ProjectDetailState>,
          ProjectDetailState,
          FutureOr<ProjectDetailState>,
          UuidValue
        > {
  ProjectDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'projectDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ViewModel of the project detail screen: details, members, invitations,
  /// join requests, and every collaboration action on them.

  ProjectDetailViewModelProvider call(UuidValue projectId) =>
      ProjectDetailViewModelProvider._(argument: projectId, from: this);

  @override
  String toString() => r'projectDetailViewModelProvider';
}

/// ViewModel of the project detail screen: details, members, invitations,
/// join requests, and every collaboration action on them.

abstract class _$ProjectDetailViewModel
    extends $AsyncNotifier<ProjectDetailState> {
  late final _$args = ref.$arg as UuidValue;
  UuidValue get projectId => _$args;

  FutureOr<ProjectDetailState> build(UuidValue projectId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProjectDetailState>, ProjectDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProjectDetailState>, ProjectDetailState>,
              AsyncValue<ProjectDetailState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
