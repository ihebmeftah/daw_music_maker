import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../view_models/register_view_model.dart';
import '../widgets/auth_link.dart';
import '../widgets/auth_shell.dart';
import '../widgets/email_code_flow_body.dart';

/// `/register` — create an account: email → emailed code → password.
///
/// Finishing signs the user in; the router's auth guard then navigates to
/// `/projects`.
class RegisterView extends ConsumerWidget {
  /// Creates the view.
  const RegisterView({super.key});

  /// Key of the "Sign in" link.
  static const loginKey = Key('register.login');

  static const _copy = EmailCodeFlowCopy(
    channel: 'CH 02 — NEW ARTIST',
    emailTitle: 'Claim your studio',
    emailSubtitle: 'Start with your email — we will send a code to verify it.',
    emailSubmit: 'Send code',
    verifyTitle: 'Check your inbox',
    passwordTitle: 'Lock it in',
    passwordSubtitle: 'Pick a password for your new account.',
    passwordLabel: 'Password',
    passwordSubmit: 'Create account',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

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
          prompt: 'Already have an account?',
          action: 'Sign in',
          onTap: state.isSubmitting
              ? null
              : () => const LoginRoute().go(context),
        ),
      ),
    );
  }
}
