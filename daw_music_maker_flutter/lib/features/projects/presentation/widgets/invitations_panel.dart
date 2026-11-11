import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/layout/panel.dart';
import 'person_tile.dart';
import 'project_labels.dart';

/// Owner-only panel: send invitations and cancel pending ones.
class InvitationsPanel extends StatelessWidget {
  /// Creates the panel.
  const InvitationsPanel({
    super.key,
    required this.invitations,
    required this.canInvite,
    required this.onInvite,
    required this.onCancel,
  });

  /// Key of the "Invite" button.
  static const inviteKey = Key('invitations.invite');

  /// Pending invitations.
  final List<ProjectInvitationResponse> invitations;

  /// Whether contributions are open (inviting is allowed).
  final bool canInvite;

  /// Opens the invite dialog.
  final VoidCallback onInvite;

  /// Cancels an invitation.
  final ValueChanged<ProjectInvitationResponse> onCancel;

  @override
  Widget build(BuildContext context) {
    return Panel(
      eyebrow: 'INVITATIONS',
      title: invitations.isEmpty
          ? 'No pending invites'
          : '${invitations.length} pending',
      trailing: SizedBox(
        width: 140,
        child: DawButton(
          key: inviteKey,
          label: 'Invite',
          icon: Icons.person_add_alt_rounded,
          variant: DawButtonVariant.ghost,
          onPressed: canInvite ? onInvite : null,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!canInvite)
            Text(
              'Turn on “Open to contributors” to invite people.',
              style: context.textStyles.bodySmall,
            ),
          for (final i in invitations)
            PersonTile(
              title: i.email,
              subtitle: 'Invited · ${i.role.label} access',
              trailing: [
                IconButton(
                  tooltip: 'Cancel invitation',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => onCancel(i),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
