import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/feedback/error_view.dart';
import '../../../../shared/widgets/feedback/loading_view.dart';
import '../../../../shared/widgets/layout/panel.dart';
import '../../../../shared/widgets/layout/studio_scaffold.dart';
import '../state/inbox_state.dart';
import '../view_models/inbox_view_model.dart';
import '../widgets/person_tile.dart';
import '../widgets/project_labels.dart';

/// `/inbox` — invitations the user received and join requests they sent.
class InboxView extends ConsumerWidget {
  /// Creates the view.
  const InboxView({super.key});

  /// Key of the accept button for an invitation id.
  static Key acceptKey(Object id) => Key('inbox.accept.$id');

  /// Key of the decline button for an invitation id.
  static Key declineKey(Object id) => Key('inbox.decline.$id');

  /// Key of the cancel button for a join request id.
  static Key cancelRequestKey(Object id) => Key('inbox.cancelRequest.$id');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StudioScaffold(
      title: 'INBOX',
      onBack: () => const ProjectsRoute().go(context),
      maxWidth: 760,
      body: switch (ref.watch(inboxViewModelProvider)) {
        AsyncData(:final value) => _Inbox(state: value),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(inboxViewModelProvider),
        ),
        _ => const LoadingView(),
      },
    );
  }
}

class _Inbox extends ConsumerWidget {
  const _Inbox({required this.state});

  final InboxState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(inboxViewModelProvider.notifier);
    final colors = context.colors;
    final styles = context.textStyles;
    final busy = state.isBusy;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ErrorBanner(message: state.actionFailure?.message),
        StaggeredReveal(
          index: 0,
          child: Panel(
            eyebrow: 'INVITATIONS',
            title: state.invitations.isEmpty
                ? 'No invitations'
                : '${state.invitations.length} waiting for you',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.invitations.isEmpty)
                  Text(
                    'When someone invites you to a project, it lands here.',
                    style: styles.bodySmall,
                  ),
                for (final i in state.invitations)
                  PersonTile(
                    highlight: true,
                    title: i.projectName,
                    subtitle:
                        'Invites you with ${i.role.label.toLowerCase()} '
                        'access',
                    trailing: [
                      IconButton(
                        key: InboxView.declineKey(i.id),
                        tooltip: 'Decline',
                        icon: Icon(Icons.close_rounded, color: colors.error),
                        onPressed: busy
                            ? null
                            : () => vm.respondToInvitation(i.id, accept: false),
                      ),
                      IconButton(
                        key: InboxView.acceptKey(i.id),
                        tooltip: 'Accept',
                        icon: Icon(
                          Icons.check_rounded,
                          color: context.dawColors.meterLow,
                        ),
                        onPressed: busy
                            ? null
                            : () => vm.respondToInvitation(i.id, accept: true),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        StaggeredReveal(
          index: 1,
          child: Panel(
            eyebrow: 'YOUR REQUESTS',
            title: state.joinRequests.isEmpty
                ? 'No pending requests'
                : '${state.joinRequests.length} pending',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.joinRequests.isEmpty)
                  Text(
                    'Ask to join public projects from Discover.',
                    style: styles.bodySmall,
                  ),
                for (final r in state.joinRequests)
                  InkWell(
                    onTap: () => ProjectDetailRoute(
                      id: r.projectId.toString(),
                    ).go(context),
                    child: PersonTile(
                      title: r.projectName,
                      subtitle:
                          'Asked for ${r.role.label.toLowerCase()} access',
                      trailing: [
                        IconButton(
                          key: InboxView.cancelRequestKey(r.id),
                          tooltip: 'Cancel request',
                          icon: const Icon(Icons.undo_rounded),
                          onPressed: busy
                              ? null
                              : () => vm.cancelJoinRequest(r.id),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
