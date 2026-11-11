import 'package:flutter/material.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/theme_context.dart';

/// Key of the confirm button in [showConfirmDialog].
const confirmDialogConfirmKey = Key('confirmDialog.confirm');

/// Asks the user to confirm an action. Resolves to true when confirmed.
///
/// ```dart
/// if (await showConfirmDialog(context,
///     title: 'Delete project?', message: '…', confirmLabel: 'Delete',
///     destructive: true)) { … }
/// ```
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      backgroundColor: context.colors.surfaceContainer,
      title: Text(title, style: context.textStyles.headline),
      content: Text(message, style: context.textStyles.body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          key: confirmDialogConfirmKey,
          style: TextButton.styleFrom(
            foregroundColor: destructive
                ? context.colors.error
                : context.colors.primary,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
