import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/inputs/daw_text_field.dart';
import '../view_models/login_view_model.dart';
import '../widgets/auth_card_header.dart';
import '../widgets/auth_link.dart';
import '../widgets/auth_shell.dart';

/// `/login` — sign in with email and password.
///
/// On success the router's auth guard navigates to `/projects`.
class LoginView extends ConsumerStatefulWidget {
  /// Creates the view.
  const LoginView({super.key});

  /// Key of the email field.
  static const emailFieldKey = Key('login.email');

  /// Key of the password field.
  static const passwordFieldKey = Key('login.password');

  /// Key of the submit button.
  static const submitKey = Key('login.submit');

  /// Key of the "Forgot password?" link.
  static const forgotPasswordKey = Key('login.forgotPassword');

  /// Key of the "Create an account" link.
  static const registerKey = Key('login.register');

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginViewModelProvider.notifier)
        .submit(email: _email.text, password: _password.text);
  }

  void _clearFailure() =>
      ref.read(loginViewModelProvider.notifier).clearFailure();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    return AuthShell(
      card: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const AuthCardHeader(
                eyebrow: 'CH 01 — SIGN IN',
                title: 'Back in the booth',
                subtitle:
                    'Sign in to pick up your projects where you left '
                    'them.',
              ),
              const SizedBox(height: AppSpacing.xl),
              ErrorBanner(message: state.failure?.message),
              DawTextField(
                key: LoginView.emailFieldKey,
                label: 'Email',
                hint: 'producer@studio.fm',
                controller: _email,
                prefixIcon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
                enabled: !state.isSubmitting,
                onChanged: (_) => _clearFailure(),
              ),
              const SizedBox(height: AppSpacing.md),
              DawTextField(
                key: LoginView.passwordFieldKey,
                label: 'Password',
                controller: _password,
                obscure: true,
                prefixIcon: Icons.lock_outline_rounded,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: Validators.loginPassword,
                enabled: !state.isSubmitting,
                onChanged: (_) => _clearFailure(),
                onSubmitted: (_) => _submit(),
              ),
              AuthLink(
                key: LoginView.forgotPasswordKey,
                prompt: '',
                action: 'Forgot password?',
                alignment: MainAxisAlignment.end,
                onTap: state.isSubmitting
                    ? null
                    : () => const ForgotPasswordRoute().go(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              DawButton(
                key: LoginView.submitKey,
                label: 'Sign in',
                icon: Icons.play_arrow_rounded,
                isLoading: state.isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.lg),
              AuthLink(
                key: LoginView.registerKey,
                prompt: 'New to the studio?',
                action: 'Create an account',
                onTap: state.isSubmitting
                    ? null
                    : () => const RegisterRoute().go(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
