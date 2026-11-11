// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel of the create / edit project form.
///
/// [projectId] is null when creating.

@ProviderFor(ProjectFormViewModel)
final projectFormViewModelProvider = ProjectFormViewModelFamily._();

/// ViewModel of the create / edit project form.
///
/// [projectId] is null when creating.
final class ProjectFormViewModelProvider
    extends $AsyncNotifierProvider<ProjectFormViewModel, ProjectFormState> {
  /// ViewModel of the create / edit project form.
  ///
  /// [projectId] is null when creating.
  ProjectFormViewModelProvider._({
    required ProjectFormViewModelFamily super.from,
    required UuidValue? super.argument,
  }) : super(
         retry: null,
         name: r'projectFormViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectFormViewModelHash();

  @override
  String toString() {
    return r'projectFormViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProjectFormViewModel create() => ProjectFormViewModel();

  @override
  bool operator ==(Object other) {
    return other is ProjectFormViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectFormViewModelHash() =>
    r'52148a456c9347b11d1d31f5ac25b125de1d812b';

/// ViewModel of the create / edit project form.
///
/// [projectId] is null when creating.

final class ProjectFormViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ProjectFormViewModel,
          AsyncValue<ProjectFormState>,
          ProjectFormState,
          FutureOr<ProjectFormState>,
          UuidValue?
        > {
  ProjectFormViewModelFamily._()
    : super(
        retry: null,
        name: r'projectFormViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ViewModel of the create / edit project form.
  ///
  /// [projectId] is null when creating.

  ProjectFormViewModelProvider call(UuidValue? projectId) =>
      ProjectFormViewModelProvider._(argument: projectId, from: this);

  @override
  String toString() => r'projectFormViewModelProvider';
}

/// ViewModel of the create / edit project form.
///
/// [projectId] is null when creating.

abstract class _$ProjectFormViewModel extends $AsyncNotifier<ProjectFormState> {
  late final _$args = ref.$arg as UuidValue?;
  UuidValue? get projectId => _$args;

  FutureOr<ProjectFormState> build(UuidValue? projectId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProjectFormState>, ProjectFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProjectFormState>, ProjectFormState>,
              AsyncValue<ProjectFormState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
