import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';

part 'login_state.freezed.dart';

/// UI state of the sign-in screen.
@freezed
abstract class LoginState with _$LoginState {
  /// Creates the sign-in state.
  const factory LoginState({
    /// Whether a sign-in request is in flight (disables the form).
    @Default(false) bool isSubmitting,

    /// Error of the last attempt, shown above the form.
    Failure? failure,
  }) = _LoginState;
}
