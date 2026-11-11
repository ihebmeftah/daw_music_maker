import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../view_models/forgot_password_view_model.dart';
import '../widgets/auth_link.dart';
import '../widgets/auth_shell.dart';
import '../widgets/email_code_flow_body.dart';

/// `/forgot-password` — reset a password: email → emailed code → new
/// password.
///
/// Finishing signs the user in with the new password; the router's auth
/// guard then navigates to `/projects`.
class ForgotPasswordView extends ConsumerWidget {
  /// Creates the view.
  const ForgotPasswordView({super.key});

  /// Key of the "Back to sign in" link.
  static const loginKey = Key('forgotPassword.login');

  static const _copy = EmailCodeFlowCopy(
    channel: 'CH 03 — RESET',
    emailTitle: 'Lost the master key?',
    emailSubtitle: 'Enter your account email and we will send a reset code.',
    emailSubmit: 'Send reset code',
    verifyTitle: 'Check your inbox',
    passwordTitle: 'New password',
    passwordSubtitle:
        'Choose a new password — you will be signed in right '
        'after.',
    passwordLabel: 'New password',
    passwordSubmit: 'Reset & sign in',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordViewModelProvider);
    final viewModel = ref.read(forgotPasswordViewModelProvider.notifier);

    return AuthShell(
      card: EmailCodeFlowBody(
        state: state,
        copy: _copy,
        onSubmitEmail: viewModel.submitEmail,
        onSubmitCode: viewModel.submitCode,
        onSubmitPassword: viewModel.submitPassword,
        onResend: viewModel.resendCode,
        onRestart: viewModel.restart,
        onEdited: viewModel.clearFailure,
        footer: AuthLink(
          key: loginKey,
          prompt: 'Remembered it?',
          action: 'Back to sign in',
          onTap: state.isSubmitting
              ? null
              : () => const LoginRoute().go(context),
        ),
      ),
    );
  }
}
