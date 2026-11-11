import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_repository_provider.dart';
import '../state/email_code_flow_state.dart';

part 'forgot_password_view_model.g.dart';

/// ViewModel of the three-step password reset flow:
/// email → verification code → new password.
///
/// After the new password is set the user is signed in with it, so the
/// router's auth guard navigates straight to the projects screen.
@riverpod
class ForgotPasswordViewModel extends _$ForgotPasswordViewModel {
  @override
  EmailCodeFlowState build() => const EmailCodeFlowState();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  /// Requests a reset code for [email] and moves to the code step.
  ///
  /// The server answers the same way for unknown emails, so the flow always
  /// advances (no account enumeration).
  Future<void> submitEmail(String email) => _run(() async {
    final normalized = email.trim().toLowerCase();
    final requestId = await _repository.startPasswordReset(email: normalized);
    return state.copyWith(
      step: EmailCodeFlowStep.verify,
      email: normalized,
      requestId: requestId,
    );
  });

  /// Verifies the emailed [code] and moves to the new-password step.
  Future<void> submitCode(String code) => _run(() async {
    final token = await _repository.verifyPasswordResetCode(
      requestId: state.requestId!,
      code: code,
    );
    return state.copyWith(step: EmailCodeFlowStep.password, token: token);
  });

  /// Sets [newPassword], then signs in with it.
  Future<void> submitPassword(String newPassword) => _run(() async {
    await _repository.finishPasswordReset(
      resetToken: state.token!,
      newPassword: newPassword,
    );
    await _repository.login(email: state.email, password: newPassword);
    return state;
  });

  /// Sends a fresh reset code to the same email.
  Future<void> resendCode() => _run(() async {
    final requestId = await _repository.startPasswordReset(email: state.email);
    return state.copyWith(requestId: requestId, codeResent: true);
  });

  /// Returns to the email step and discards the pending request.
  void restart() => state = const EmailCodeFlowState();

  /// Clears the displayed error (e.g. when the user edits the form).
  void clearFailure() {
    if (state.failure != null) state = state.copyWith(failure: null);
  }

  Future<void> _run(Future<EmailCodeFlowState> Function() action) async {
    if (state.isSubmitting) return;
    state = state.copyWith(
      isSubmitting: true,
      failure: null,
      codeResent: false,
    );
    try {
      final next = await action();
      if (!ref.mounted) return;
      state = next.copyWith(isSubmitting: false);
    } catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmitting: false,
        failure: mapGenericError(error),
      );
    }
  }
}
