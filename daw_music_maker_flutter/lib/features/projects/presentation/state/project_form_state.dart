import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'project_form_state.freezed.dart';

/// UI state of the create / edit project form.
@freezed
abstract class ProjectFormState with _$ProjectFormState {
  /// Creates the state.
  const factory ProjectFormState({
    /// The project being edited, or null when creating.
    ProjectResponse? initial,

    /// Whether a save is in flight.
    @Default(false) bool isSubmitting,

    /// Error of the last save (may carry server field errors).
    Failure? failure,
  }) = _ProjectFormState;
}
