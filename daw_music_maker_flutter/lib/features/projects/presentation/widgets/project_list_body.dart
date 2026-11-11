import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/feedback/empty_state.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/feedback/error_view.dart';
import '../../../../shared/widgets/feedback/loading_view.dart';
import '../state/project_list_state.dart';
import '../view_models/project_list_view_model.dart';
import 'project_card.dart';

/// The grid of one project list with loading, error, empty and
/// "load more" states.
class ProjectListBody extends ConsumerWidget {
  /// Creates the body for [kind].
  const ProjectListBody({super.key, required this.kind});

  /// Key of the "Load more" button.
  static const loadMoreKey = Key('projects.loadMore');

  /// Which list to show.
  final ProjectListKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = projectListViewModelProvider(kind);
    final viewModel = ref.read(provider.notifier);
    return switch (ref.watch(provider)) {
      AsyncData(:final value) => RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: value.items.isEmpty
            ? ListView(
                children: [_Empty(kind: kind, query: value.query)],
              )
            : _Grid(state: value, onLoadMore: viewModel.loadMore),
      ),
      AsyncError(:final error) => ErrorView(
        error: error,
        onRetry: viewModel.refresh,
      ),
      _ => const LoadingView(),
    };
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.state, required this.onLoadMore});

  final ProjectListState state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 380).floor().clamp(1, 3);
        return CustomScrollView(
          slivers: [
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 196,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: state.items.length,
                (context, i) {
                  final project = state.items[i];
                  final id = project.id.toString();
                  return ProjectCard(
                    key: ValueKey(project.id),
                    project: project,
                    onTap: () => ProjectDetailRoute(id: id).go(context),
                    onOpenStudio: () => StudioRoute(id: id).go(context),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Column(
                  children: [
                    ErrorBanner(message: state.loadMoreFailure?.message),
                    if (state.hasMore)
                      Center(
                        child: SizedBox(
                          width: 220,
                          child: DawButton(
                            key: ProjectListBody.loadMoreKey,
                            label: 'Load more',
                            variant: DawButtonVariant.ghost,
                            isLoading: state.isLoadingMore,
                            onPressed: onLoadMore,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.kind, required this.query});

  final ProjectListKind kind;
  final String query;

  @override
  Widget build(BuildContext context) {
    return switch (kind) {
      ProjectListKind.mine => EmptyState(
        icon: Icons.album_outlined,
        title: 'No projects yet',
        message: 'Lay down your first idea — every hit starts as a sketch.',
        action: DawButton(
          label: 'New project',
          icon: Icons.add_rounded,
          onPressed: () => const ProjectFormRoute().go(context),
        ),
      ),
      ProjectListKind.shared => const EmptyState(
        icon: Icons.group_outlined,
        title: 'Nothing shared yet',
        message:
            'Projects you join through invitations or accepted requests '
            'show up here.',
      ),
      ProjectListKind.discover => EmptyState(
        icon: Icons.explore_outlined,
        title: query.isEmpty ? 'No public projects' : 'No matches',
        message: query.isEmpty
            ? 'When producers publish projects, they appear here.'
            : 'No public project matches “$query”.',
      ),
    };
  }
}
