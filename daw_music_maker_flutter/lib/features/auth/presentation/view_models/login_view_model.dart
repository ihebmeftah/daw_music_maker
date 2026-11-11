import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/auth_repository_provider.dart';
import '../state/login_state.dart';

part 'login_view_model.g.dart';

/// ViewModel of the sign-in screen.
///
/// On success the session is stored by the repository and the router's auth
/// guard navigates to the projects screen.
@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginState build() => const LoginState();

  /// Signs in with [email] and [password]. Ignored while a request is in
  /// flight.
  Future<void> submit({required String email, required String password}) async {
    if (state.isSubmitting) return;
    state = state.copyWith(isSubmitting: true, failure: null);
    try {
      await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      if (!ref.mounted) return;
      state = state.copyWith(isSubmitting: false);
    } catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmitting: false,
        failure: mapGenericError(error),
      );
    }
  }

  /// Clears the displayed error (e.g. when the user edits the form).
  void clearFailure() {
    if (state.failure != null) state = state.copyWith(failure: null);
  }
}
