import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/inputs/daw_text_field.dart';
import 'auth_link.dart';

/// Second step of an email-code flow: asks for the emailed code.
class CodeStepForm extends StatefulWidget {
  /// Creates the form.
  const CodeStepForm({
    super.key,
    required this.email,
    required this.isSubmitting,
    required this.codeResent,
    required this.onSubmit,
    required this.onResend,
    required this.onChangeEmail,
    this.onChanged,
  });

  /// Key of the code field.
  static const codeFieldKey = Key('codeStep.code');

  /// Key of the submit button.
  static const submitKey = Key('codeStep.submit');

  /// Key of the "send a new code" link.
  static const resendKey = Key('codeStep.resend');

  /// Email the code was sent to.
  final String email;

  /// Disables the form while a request is in flight.
  final bool isSubmitting;

  /// Shows a confirmation that a new code was sent.
  final bool codeResent;

  /// Called with the code once the form is valid.
  final ValueChanged<String> onSubmit;

  /// Requests a new code.
  final VoidCallback onResend;

  /// Goes back to the email step.
  final VoidCallback onChangeEmail;

  /// Called when the user edits the field.
  final VoidCallback? onChanged;

  @override
  State<CodeStepForm> createState() => _CodeStepFormState();
}

class _CodeStepFormState extends State<CodeStepForm> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) widget.onSubmit(_code.text);
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              text:
                  'We sent an ${ValidationRules.verificationCodeLength}-digit '
                  'code to ',
              children: [
                TextSpan(
                  text: widget.email,
                  style: styles.mono.copyWith(color: context.colors.primary),
                ),
              ],
            ),
            style: styles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          DawTextField(
            key: CodeStepForm.codeFieldKey,
            label: 'Verification code',
            controller: _code,
            monospace: true,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: ValidationRules.verificationCodeLength,
            validator: Validators.verificationCode,
            enabled: !widget.isSubmitting,
            onChanged: (_) => widget.onChanged?.call(),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          DawButton(
            key: CodeStepForm.submitKey,
            label: 'Verify code',
            icon: Icons.arrow_forward_rounded,
            isLoading: widget.isSubmitting,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AuthLink(
                prompt: '',
                action: 'Change email',
                onTap: widget.isSubmitting ? null : widget.onChangeEmail,
              ),
              AuthLink(
                key: CodeStepForm.resendKey,
                prompt: '',
                action: widget.codeResent ? 'Code sent ✓' : 'Send a new code',
                onTap: widget.isSubmitting ? null : widget.onResend,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
