import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/inputs/daw_text_field.dart';

/// Asks for a new pattern name, pre-filled with [initial]. Resolves to the
/// trimmed name, or null when cancelled.
Future<String?> showPatternNameDialog(
  BuildContext context, {
  required String initial,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => PatternNameDialog(initial: initial),
  );
}

/// Content of [showPatternNameDialog].
class PatternNameDialog extends StatefulWidget {
  /// Creates the dialog.
  const PatternNameDialog({super.key, required this.initial});

  /// Key of the name field.
  static const fieldKey = Key('patternNameDialog.name');

  /// Key of the save button.
  static const saveKey = Key('patternNameDialog.save');

  /// Current name.
  final String initial;

  @override
  State<PatternNameDialog> createState() => _PatternNameDialogState();
}

class _PatternNameDialogState extends State<PatternNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_name.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Dialog(
      backgroundColor: context.colors.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'RENAME PATTERN',
                  style: styles.eyebrow.copyWith(color: context.colors.primary),
                ),
                const SizedBox(height: AppSpacing.md),
                DawTextField(
                  key: PatternNameDialog.fieldKey,
                  label: 'Name',
                  controller: _name,
                  autofocus: true,
                  maxLength: ValidationRules.patternNameMaxLength,
                  validator: Validators.patternName,
                  onSubmitted: (_) => _save(),
                ),
                const SizedBox(height: AppSpacing.lg),
                DawButton(
                  key: PatternNameDialog.saveKey,
                  label: 'Save',
                  icon: Icons.check_rounded,
                  onPressed: _save,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
