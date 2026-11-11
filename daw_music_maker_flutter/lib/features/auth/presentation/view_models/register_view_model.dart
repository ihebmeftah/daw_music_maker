import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_repository_provider.dart';
import '../state/email_code_flow_state.dart';

part 'register_view_model.g.dart';

/// ViewModel of the three-step registration flow:
/// email → verification code → password.
///
/// Finishing the flow signs the user in; the router's auth guard then
/// navigates to the projects screen.
@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  EmailCodeFlowState build() => const EmailCodeFlowState();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  /// Sends a verification code to [email] and moves to the code step.
  Future<void> submitEmail(String email) => _run(() async {
    final normalized = email.trim().toLowerCase();
    final requestId = await _repository.startRegistration(email: normalized);
    return state.copyWith(
      step: EmailCodeFlowStep.verify,
      email: normalized,
      requestId: requestId,
    );
  });

  /// Verifies the emailed [code] and moves to the password step.
  Future<void> submitCode(String code) => _run(() async {
    final token = await _repository.verifyRegistrationCode(
      requestId: state.requestId!,
      code: code,
    );
    return state.copyWith(step: EmailCodeFlowStep.password, token: token);
  });

  /// Creates the account with [password] and signs the user in.
  Future<void> submitPassword(String password) => _run(() async {
    await _repository.finishRegistration(
      registrationToken: state.token!,
      password: password,
    );
    return state;
  });

  /// Sends a fresh verification code to the same email.
  Future<void> resendCode() => _run(() async {
    final requestId = await _repository.startRegistration(email: state.email);
    return state.copyWith(requestId: requestId, codeResent: true);
  });

  /// Returns to the email step and discards the pending request.
  void restart() => state = const EmailCodeFlowState();

  /// Clears the displayed error (e.g. when the user edits the form).
  void clearFailure() {
    if (state.failure != null) state = state.copyWith(failure: null);
  }

  /// Runs [action] with in-flight and error handling. [action] returns the
  /// next state on success.
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
