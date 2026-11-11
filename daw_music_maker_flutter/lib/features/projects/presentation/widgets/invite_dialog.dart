import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/inputs/daw_text_field.dart';
import 'role_selector.dart';

/// Invites someone by email with a role. [onInvite] returns null on success
/// (the dialog closes) or a [Failure] shown inside the dialog.
///
/// Returns true when an invitation was sent.
Future<bool> showInviteDialog(
  BuildContext context, {
  required Future<Failure?> Function(String email, ProjectRole role) onInvite,
}) async {
  final sent = await showDialog<bool>(
    context: context,
    builder: (_) => InviteDialog(onInvite: onInvite),
  );
  return sent ?? false;
}

/// Content of [showInviteDialog].
class InviteDialog extends StatefulWidget {
  /// Creates the dialog.
  const InviteDialog({super.key, required this.onInvite});

  /// Key of the email field.
  static const emailFieldKey = Key('inviteDialog.email');

  /// Key of the send button.
  static const sendKey = Key('inviteDialog.send');

  /// Sends the invitation.
  final Future<Failure?> Function(String email, ProjectRole role) onInvite;

  @override
  State<InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends State<InviteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  ProjectRole _role = ProjectRole.read;
  bool _sending = false;
  Failure? _failure;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _failure = null;
    });
    final failure = await widget.onInvite(_email.text, _role);
    if (!mounted) return;
    if (failure == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _sending = false;
        _failure = failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final fieldError = _failure?.fieldError('email');
    return Dialog(
      backgroundColor: context.colors.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.formMaxWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'SEND INVITE',
                  style: styles.eyebrow.copyWith(color: context.colors.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Bring someone into the session', style: styles.headline),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'They will see the invitation in their inbox once they sign '
                  'in with this email.',
                  style: styles.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                ErrorBanner(
                  message: _failure == null || fieldError != null
                      ? fieldError
                      : _failure!.message,
                ),
                DawTextField(
                  key: InviteDialog.emailFieldKey,
                  label: 'Email',
                  hint: 'collaborator@studio.fm',
                  controller: _email,
                  autofocus: true,
                  prefixIcon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  enabled: !_sending,
                  onSubmitted: (_) => _send(),
                ),
                const SizedBox(height: AppSpacing.md),
                RoleSelector(
                  role: _role,
                  onChanged: _sending ? null : (r) => setState(() => _role = r),
                ),
                const SizedBox(height: AppSpacing.lg),
                DawButton(
                  key: InviteDialog.sendKey,
                  label: 'Send invite',
                  icon: Icons.send_rounded,
                  isLoading: _sending,
                  onPressed: _send,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: _sending
                      ? null
                      : () => Navigator.of(context).pop(false),
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
