import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import 'role_selector.dart';

/// Key of the send button in [showJoinRequestDialog].
const joinRequestSendKey = Key('joinRequestDialog.send');

/// Asks which role to request when joining [projectName]. Resolves to the
/// chosen role, or null when cancelled.
Future<ProjectRole?> showJoinRequestDialog(
  BuildContext context, {
  required String projectName,
}) {
  return showDialog<ProjectRole>(
    context: context,
    builder: (_) => _JoinRequestDialog(projectName: projectName),
  );
}

class _JoinRequestDialog extends StatefulWidget {
  const _JoinRequestDialog({required this.projectName});

  final String projectName;

  @override
  State<_JoinRequestDialog> createState() => _JoinRequestDialogState();
}

class _JoinRequestDialogState extends State<_JoinRequestDialog> {
  ProjectRole _role = ProjectRole.read;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Dialog(
      backgroundColor: context.colors.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.formMaxWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'REQUEST TO JOIN',
                style: styles.eyebrow.copyWith(color: context.colors.primary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(widget.projectName, style: styles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'The owner will see your email and the access you ask for.',
                style: styles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              RoleSelector(
                role: _role,
                onChanged: (r) => setState(() => _role = r),
              ),
              const SizedBox(height: AppSpacing.lg),
              DawButton(
                key: joinRequestSendKey,
                label: 'Send request',
                icon: Icons.send_rounded,
                onPressed: () => Navigator.of(context).pop(_role),
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
    );
  }
}
