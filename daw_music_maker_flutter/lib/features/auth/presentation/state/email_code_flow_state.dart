import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'email_code_flow_state.freezed.dart';

/// Steps of a flow that verifies an email with a code before setting a
/// password (registration and password reset).
enum EmailCodeFlowStep {
  /// The user enters their email address.
  email,

  /// The user enters the code that was emailed to them.
  verify,

  /// The user chooses a (new) password.
  password,
}

/// UI state shared by the registration and forgot-password flows.
@freezed
abstract class EmailCodeFlowState with _$EmailCodeFlowState {
  /// Creates the flow state.
  const factory EmailCodeFlowState({
    /// The current step.
    @Default(EmailCodeFlowStep.email) EmailCodeFlowStep step,

    /// The email the code was sent to (normalized), empty on the first step.
    @Default('') String email,

    /// Server request id returned when the code was sent.
    UuidValue? requestId,

    /// Token returned after the code was verified; used to set the password.
    String? token,

    /// Whether a request is in flight (disables the form).
    @Default(false) bool isSubmitting,

    /// Whether a new code was just sent (shows a confirmation hint).
    @Default(false) bool codeResent,

    /// Error of the last request, shown above the form.
    Failure? failure,
  }) = _EmailCodeFlowState;
}
