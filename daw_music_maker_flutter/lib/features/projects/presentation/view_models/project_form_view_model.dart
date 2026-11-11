import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/project_providers.dart';
import '../state/project_form_state.dart';
import '../state/project_list_state.dart';
import 'project_detail_view_model.dart';
import 'project_list_view_model.dart';

part 'project_form_view_model.g.dart';

/// ViewModel of the create / edit project form.
///
/// [projectId] is null when creating.
@riverpod
class ProjectFormViewModel extends _$ProjectFormViewModel {
  @override
  Future<ProjectFormState> build(UuidValue? projectId) async {
    if (projectId == null) return const ProjectFormState();
    try {
      final project = await ref
          .read(projectRepositoryProvider)
          .getById(projectId);
      return ProjectFormState(initial: project);
    } catch (error) {
      throw mapGenericError(error);
    }
  }

  /// Creates or updates the project. Returns the saved project, or null on
  /// failure (see [ProjectFormState.failure]).
  Future<ProjectResponse?> submit({
    required String name,
    required String description,
    required List<String> genres,
    required ProjectVisibility visibility,
    required bool allowContributions,
  }) async {
    final current = state.value;
    if (current == null || current.isSubmitting) return null;
    state = AsyncData(current.copyWith(isSubmitting: true, failure: null));

    final repository = ref.read(projectRepositoryProvider);
    try {
      final saved = projectId == null
          ? await repository.create(
              CreateProjectRequest(
                name: name.trim(),
                description: description.trim(),
                genres: genres,
                visibility: visibility,
                allowContributions: allowContributions,
              ),
            )
          : await repository.update(
              projectId!,
              UpdateProjectRequest(
                name: name.trim(),
                description: description.trim(),
                genres: genres,
                visibility: visibility,
                allowContributions: allowContributions,
              ),
            );
      ref.invalidate(projectListViewModelProvider(ProjectListKind.mine));
      ref.invalidate(projectListViewModelProvider(ProjectListKind.shared));
      if (projectId != null) {
        ref.invalidate(projectDetailViewModelProvider(projectId!));
      }
      if (ref.mounted) {
        state = AsyncData(current.copyWith(isSubmitting: false));
      }
      return saved;
    } catch (error) {
      if (ref.mounted) {
        state = AsyncData(
          current.copyWith(
            isSubmitting: false,
            failure: mapGenericError(error),
          ),
        );
      }
      return null;
    }
  }

  /// Clears the displayed error (e.g. when the user edits the form).
  void clearFailure() {
    final current = state.value;
    if (current?.failure != null) {
      state = AsyncData(current!.copyWith(failure: null));
    }
  }
}
