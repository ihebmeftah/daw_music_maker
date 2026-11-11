import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/layout/panel.dart';
import 'person_tile.dart';
import 'project_labels.dart';

/// Actions the owner can take on a member.
enum MemberAction {
  /// Give read access.
  makeRead,

  /// Give write access.
  makeWrite,

  /// Remove from the project.
  remove,
}

/// The owner and members of a project. When [canManage] (owner), each
/// member has a menu to change their role or remove them.
class MembersPanel extends StatelessWidget {
  /// Creates the panel.
  const MembersPanel({
    super.key,
    required this.members,
    required this.canManage,
    required this.onAction,
  });

  /// Key of the action menu for [userId].
  static Key menuKey(UuidValue userId) => Key('members.menu.$userId');

  /// Owner (first) and members.
  final List<ProjectMemberResponse> members;

  /// Whether to show management menus.
  final bool canManage;

  /// Called with the chosen action for a member.
  final void Function(ProjectMemberResponse member, MemberAction action)
  onAction;

  @override
  Widget build(BuildContext context) {
    return Panel(
      eyebrow: 'MEMBERS',
      title: '${members.length} in the session',
      child: Column(
        children: [
          for (final m in members)
            PersonTile(
              highlight: m.isOwner,
              title: m.email ?? 'Collaborator',
              subtitle: m.isOwner ? 'Owner' : '${m.role.label} access',
              trailing: [
                if (canManage && !m.isOwner)
                  PopupMenuButton<MemberAction>(
                    key: menuKey(m.userId),
                    tooltip: 'Manage member',
                    onSelected: (action) => onAction(m, action),
                    itemBuilder: (_) => [
                      if (m.role != ProjectRole.write)
                        const PopupMenuItem(
                          value: MemberAction.makeWrite,
                          child: Text('Give write access'),
                        ),
                      if (m.role != ProjectRole.read)
                        const PopupMenuItem(
                          value: MemberAction.makeRead,
                          child: Text('Make read-only'),
                        ),
                      const PopupMenuItem(
                        value: MemberAction.remove,
                        child: Text('Remove from project'),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
