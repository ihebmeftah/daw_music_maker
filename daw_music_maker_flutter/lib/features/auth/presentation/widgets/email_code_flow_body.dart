import 'package:flutter/material.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../state/email_code_flow_state.dart';
import 'auth_card_header.dart';
import 'code_step_form.dart';
import 'email_step_form.dart';
import 'password_step_form.dart';
import 'step_indicator.dart';

/// Texts that differ between the registration and password-reset flows.
class EmailCodeFlowCopy {
  /// Creates the copy for a flow.
  const EmailCodeFlowCopy({
    required this.channel,
    required this.emailTitle,
    required this.emailSubtitle,
    required this.emailSubmit,
    required this.verifyTitle,
    required this.passwordTitle,
    required this.passwordSubtitle,
    required this.passwordLabel,
    required this.passwordSubmit,
  });

  /// Channel label prefix, e.g. `CH 02 — REGISTER`.
  final String channel;

  /// Title of the email step.
  final String emailTitle;

  /// Subtitle of the email step.
  final String emailSubtitle;

  /// Submit label of the email step.
  final String emailSubmit;

  /// Title of the code step.
  final String verifyTitle;

  /// Title of the password step.
  final String passwordTitle;

  /// Subtitle of the password step.
  final String passwordSubtitle;

  /// Label of the password field.
  final String passwordLabel;

  /// Submit label of the password step.
  final String passwordSubmit;
}

/// Card content of an email → code → password flow: header, step pads,
/// error banner and the current step's form, with slide transitions between
/// steps.
class EmailCodeFlowBody extends StatelessWidget {
  /// Creates the flow body.
  const EmailCodeFlowBody({
    super.key,
    required this.state,
    required this.copy,
    required this.onSubmitEmail,
    required this.onSubmitCode,
    required this.onSubmitPassword,
    required this.onResend,
    required this.onRestart,
    required this.onEdited,
    required this.footer,
  });

  /// Current flow state.
  final EmailCodeFlowState state;

  /// Flow-specific texts.
  final EmailCodeFlowCopy copy;

  /// Email step submitted.
  final ValueChanged<String> onSubmitEmail;

  /// Code step submitted.
  final ValueChanged<String> onSubmitCode;

  /// Password step submitted.
  final ValueChanged<String> onSubmitPassword;

  /// Resend the code.
  final VoidCallback onResend;

  /// Back to the email step.
  final VoidCallback onRestart;

  /// Any field edited (clears the error).
  final VoidCallback onEdited;

  /// Content below the form (e.g. a link back to sign in).
  final Widget footer;

  static const _stepLabels = ['EMAIL', 'CODE', 'PASSWORD'];

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = switch (state.step) {
      EmailCodeFlowStep.email => (copy.emailTitle, copy.emailSubtitle),
      EmailCodeFlowStep.verify => (
        copy.verifyTitle,
        'Check your inbox — the code expires in 15 minutes.',
      ),
      EmailCodeFlowStep.password => (copy.passwordTitle, copy.passwordSubtitle),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthCardHeader(eyebrow: copy.channel, title: title, subtitle: subtitle),
        const SizedBox(height: AppSpacing.lg),
        StepIndicator(labels: _stepLabels, current: state.step.index),
        const SizedBox(height: AppSpacing.lg),
        ErrorBanner(message: state.failure?.message),
        AnimatedSize(
          duration: AppDurations.medium,
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: AppDurations.slow,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.topCenter,
              children: [...previous, ?current],
            ),
            child: KeyedSubtree(
              key: ValueKey(state.step),
              child: _StepForm(
                state: state,
                copy: copy,
                onSubmitEmail: onSubmitEmail,
                onSubmitCode: onSubmitCode,
                onSubmitPassword: onSubmitPassword,
                onResend: onResend,
                onRestart: onRestart,
                onEdited: onEdited,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        footer,
      ],
    );
  }
}

class _StepForm extends StatelessWidget {
  const _StepForm({
    required this.state,
    required this.copy,
    required this.onSubmitEmail,
    required this.onSubmitCode,
    required this.onSubmitPassword,
    required this.onResend,
    required this.onRestart,
    required this.onEdited,
  });

  final EmailCodeFlowState state;
  final EmailCodeFlowCopy copy;
  final ValueChanged<String> onSubmitEmail;
  final ValueChanged<String> onSubmitCode;
  final ValueChanged<String> onSubmitPassword;
  final VoidCallback onResend;
  final VoidCallback onRestart;
  final VoidCallback onEdited;

  @override
  Widget build(BuildContext context) {
    return switch (state.step) {
      EmailCodeFlowStep.email => EmailStepForm(
        submitLabel: copy.emailSubmit,
        isSubmitting: state.isSubmitting,
        initialEmail: state.email,
        onSubmit: onSubmitEmail,
        onChanged: onEdited,
      ),
      EmailCodeFlowStep.verify => CodeStepForm(
        email: state.email,
        isSubmitting: state.isSubmitting,
        codeResent: state.codeResent,
        onSubmit: onSubmitCode,
        onResend: onResend,
        onChangeEmail: onRestart,
        onChanged: onEdited,
      ),
      EmailCodeFlowStep.password => PasswordStepForm(
        submitLabel: copy.passwordSubmit,
        passwordLabel: copy.passwordLabel,
        isSubmitting: state.isSubmitting,
        onSubmit: onSubmitPassword,
        onChanged: onEdited,
      ),
    };
  }
}
