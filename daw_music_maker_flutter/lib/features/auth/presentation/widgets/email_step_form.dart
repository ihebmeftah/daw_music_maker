import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/inputs/daw_text_field.dart';

/// First step of an email-code flow: asks for the email address.
class EmailStepForm extends StatefulWidget {
  /// Creates the form.
  const EmailStepForm({
    super.key,
    required this.submitLabel,
    required this.isSubmitting,
    required this.onSubmit,
    this.initialEmail = '',
    this.onChanged,
  });

  /// Key of the email field.
  static const emailFieldKey = Key('emailStep.email');

  /// Key of the submit button.
  static const submitKey = Key('emailStep.submit');

  /// Submit button label.
  final String submitLabel;

  /// Disables the form while a request is in flight.
  final bool isSubmitting;

  /// Called with the email once the form is valid.
  final ValueChanged<String> onSubmit;

  /// Pre-filled email (e.g. when restarting the flow).
  final String initialEmail;

  /// Called when the user edits the field.
  final VoidCallback? onChanged;

  @override
  State<EmailStepForm> createState() => _EmailStepFormState();
}

class _EmailStepFormState extends State<EmailStepForm> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) widget.onSubmit(_email.text);
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
              key: EmailStepForm.emailFieldKey,
              label: 'Email',
              hint: 'producer@studio.fm',
              controller: _email,
              prefixIcon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
              enabled: !widget.isSubmitting,
              onChanged: (_) => widget.onChanged?.call(),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            DawButton(
              key: EmailStepForm.submitKey,
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
