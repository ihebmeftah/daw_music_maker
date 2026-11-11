import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/dialogs/confirm_dialog.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/feedback/error_view.dart';
import '../../../../shared/widgets/feedback/loading_view.dart';
import '../../../../shared/widgets/layout/studio_scaffold.dart';
import '../state/project_detail_state.dart';
import '../view_models/project_detail_view_model.dart';
import '../widgets/invitations_panel.dart';
import '../widgets/invite_dialog.dart';
import '../widgets/join_request_dialog.dart';
import '../widgets/join_requests_panel.dart';
import '../widgets/members_panel.dart';
import '../widgets/project_header.dart';

/// `/projects/:id` — a project with its members and, for the owner,
/// invitations and join requests. Actions depend on the user's access.
class ProjectDetailView extends ConsumerWidget {
  /// Creates the view for [projectId].
  const ProjectDetailView({super.key, required this.projectId});

  /// Key of the edit button.
  static const editKey = Key('projectDetail.edit');

  /// Key of the delete button.
  static const deleteKey = Key('projectDetail.delete');

  /// Key of the leave button.
  static const leaveKey = Key('projectDetail.leave');

  /// Key of the "Request to join" button.
  static const requestJoinKey = Key('projectDetail.requestJoin');

  /// Key of the "Cancel request" button.
  static const cancelRequestKey = Key('projectDetail.cancelRequest');

  /// The project.
  final UuidValue projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = projectDetailViewModelProvider(projectId);
    return StudioScaffold(
      title: 'PROJECT',
      maxWidth: 900,
      body: switch (ref.watch(provider)) {
        AsyncData(:final value) => _Detail(projectId: projectId, state: value),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(provider),
        ),
        _ => const LoadingView(),
      },
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.projectId, required this.state});

  final UuidValue projectId;
  final ProjectDetailState state;

  ProjectDetailViewModel _vm(WidgetRef ref) =>
      ref.read(projectDetailViewModelProvider(projectId).notifier);

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete “${state.project.name}”?',
      message:
          'The project, its members, invitations and requests are removed. '
          'This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;
    final failure = await _vm(ref).deleteProject();
    if (failure == null && context.mounted) const ProjectsRoute().go(context);
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Leave “${state.project.name}”?',
      message: 'You will lose access unless you are invited again.',
      confirmLabel: 'Leave',
      destructive: true,
    );
    if (!confirmed) return;
    final failure = await _vm(ref).leave();
    if (failure == null && context.mounted) const ProjectsRoute().go(context);
  }

  Future<void> _requestJoin(BuildContext context, WidgetRef ref) async {
    final role = await showJoinRequestDialog(
      context,
      projectName: state.project.name,
    );
    if (role != null) await _vm(ref).requestToJoin(role);
  }

  List<Widget> _actions(BuildContext context, WidgetRef ref) {
    final busy = state.isBusy;
    return [
      if (state.canEdit)
        DawButton(
          key: ProjectDetailView.editKey,
          label: 'Edit',
          icon: Icons.tune_rounded,
          variant: DawButtonVariant.ghost,
          onPressed: busy
              ? null
              : () => EditProjectRoute(id: projectId.toString()).push(context),
        ),
      if (state.isOwner)
        DawButton(
          key: ProjectDetailView.deleteKey,
          label: 'Delete',
          icon: Icons.delete_outline_rounded,
          variant: DawButtonVariant.ghost,
          onPressed: busy ? null : () => _delete(context, ref),
        ),
      if (state.isMember)
        DawButton(
          key: ProjectDetailView.leaveKey,
          label: 'Leave',
          icon: Icons.logout_rounded,
          variant: DawButtonVariant.ghost,
          onPressed: busy ? null : () => _leave(context, ref),
        ),
      if (state.project.hasPendingJoinRequest)
        DawButton(
          key: ProjectDetailView.cancelRequestKey,
          label: 'Cancel request',
          icon: Icons.hourglass_top_rounded,
          variant: DawButtonVariant.ghost,
          isLoading: busy,
          onPressed: () => _vm(ref).cancelJoinRequest(),
        )
      else if (state.canRequestToJoin)
        DawButton(
          key: ProjectDetailView.requestJoinKey,
          label: 'Request to join',
          icon: Icons.handshake_outlined,
          isLoading: busy,
          onPressed: () => _requestJoin(context, ref),
        ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = _vm(ref);
    var index = 0;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ErrorBanner(message: state.actionFailure?.message),
        StaggeredReveal(
          index: index++,
          child: ProjectHeader(
            project: state.project,
            actions: _actions(context, ref),
          ),
        ),
        if (state.members.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          StaggeredReveal(
            index: index++,
            child: MembersPanel(
              members: state.members,
              canManage: state.isOwner,
              onAction: (member, action) => switch (action) {
                MemberAction.makeRead => vm.updateMemberRole(
                  member.userId,
                  ProjectRole.read,
                ),
                MemberAction.makeWrite => vm.updateMemberRole(
                  member.userId,
                  ProjectRole.write,
                ),
                MemberAction.remove => vm.removeMember(member.userId),
              },
            ),
          ),
        ],
        if (state.isOwner) ...[
          const SizedBox(height: AppSpacing.md),
          StaggeredReveal(
            index: index++,
            child: InvitationsPanel(
              invitations: state.invitations,
              canInvite: state.project.allowContributions,
              onInvite: () => showInviteDialog(context, onInvite: vm.invite),
              onCancel: (i) => vm.cancelInvitation(i.id),
            ),
          ),
          if (state.joinRequests.isNotEmpty ||
              state.project.visibility == ProjectVisibility.public) ...[
            const SizedBox(height: AppSpacing.md),
            StaggeredReveal(
              index: index++,
              child: JoinRequestsPanel(
                requests: state.joinRequests,
                onRespond: (r, accept) =>
                    vm.respondToJoinRequest(r.id, accept: accept),
              ),
            ),
          ],
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
