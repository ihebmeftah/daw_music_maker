import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/inputs/daw_text_field.dart';

/// Last step of an email-code flow: choose a (new) password and confirm it.
class PasswordStepForm extends StatefulWidget {
  /// Creates the form.
  const PasswordStepForm({
    super.key,
    required this.submitLabel,
    required this.isSubmitting,
    required this.onSubmit,
    this.passwordLabel = 'Password',
    this.onChanged,
  });

  /// Key of the password field.
  static const passwordFieldKey = Key('passwordStep.password');

  /// Key of the confirmation field.
  static const confirmFieldKey = Key('passwordStep.confirm');

  /// Key of the submit button.
  static const submitKey = Key('passwordStep.submit');

  /// Submit button label.
  final String submitLabel;

  /// Label of the first password field.
  final String passwordLabel;

  /// Disables the form while a request is in flight.
  final bool isSubmitting;

  /// Called with the password once the form is valid.
  final ValueChanged<String> onSubmit;

  /// Called when the user edits a field.
  final VoidCallback? onChanged;

  @override
  State<PasswordStepForm> createState() => _PasswordStepFormState();
}

class _PasswordStepFormState extends State<PasswordStepForm> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) widget.onSubmit(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DawTextField(
              key: PasswordStepForm.passwordFieldKey,
              label: widget.passwordLabel,
              controller: _password,
              obscure: true,
              autofocus: true,
              prefixIcon: Icons.lock_outline_rounded,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.newPassword,
              enabled: !widget.isSubmitting,
              onChanged: (_) {
                setState(() {}); // Refresh the strength meter.
                widget.onChanged?.call();
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            _LengthMeter(length: _password.text.length),
            const SizedBox(height: AppSpacing.md),
            DawTextField(
              key: PasswordStepForm.confirmFieldKey,
              label: 'Confirm password',
              controller: _confirm,
              obscure: true,
              prefixIcon: Icons.lock_reset_rounded,
              textInputAction: TextInputAction.done,
              validator: Validators.confirmPassword(() => _password.text),
              enabled: !widget.isSubmitting,
              onChanged: (_) => widget.onChanged?.call(),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            DawButton(
              key: PasswordStepForm.submitKey,
              label: widget.submitLabel,
              icon: Icons.arrow_forward_rounded,
              isLoading: widget.isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Level-meter style hint showing progress toward the minimum length.
class _LengthMeter extends StatelessWidget {
  const _LengthMeter({required this.length});

  final int length;

  @override
  Widget build(BuildContext context) {
    const segments = 12;
    final daw = context.dawColors;
    final colors = context.colors;
    // Segments fill up to the minimum length (2/3 of the meter), then the
    // remaining third rewards longer passwords.
    final min = ValidationRules.passwordMinLength;
    final lit = length < min
        ? (length / min * segments * 2 / 3).floor()
        : (8 + (length - min) / 2).floor().clamp(8, segments);
    final ok = length >= min;
    return Row(
      children: [
        for (var i = 0; i < segments; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: AppSpacing.xs,
              color: i < lit
                  ? (i < 4
                        ? daw.meterHigh
                        : i < 8
                        ? daw.meterMid
                        : daw.meterLow)
                  : colors.surfaceContainerHighest,
            ),
          ),
        ],
        const SizedBox(width: AppSpacing.sm),
        Text(
          ok ? 'OK' : '$length/$min',
          style: context.textStyles.eyebrow.copyWith(
            fontSize: 10,
            letterSpacing: 1,
            color: ok ? daw.meterLow : colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
