import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/inputs/daw_segmented_control.dart';
import '../../../../shared/widgets/layout/studio_scaffold.dart';
import '../state/project_list_state.dart';
import '../view_models/inbox_view_model.dart';
import '../view_models/project_list_view_model.dart';
import '../view_models/projects_view_model.dart';
import '../widgets/project_list_body.dart';

/// `/projects` — the user's studio: their projects, projects shared with
/// them, and public projects to discover.
class ProjectsView extends ConsumerStatefulWidget {
  /// Creates the view.
  const ProjectsView({super.key});

  /// Key of the sign-out button.
  static const signOutKey = Key('projects.signOut');

  /// Key of the "New project" button.
  static const newProjectKey = Key('projects.new');

  /// Key of the inbox button.
  static const inboxKey = Key('projects.inbox');

  /// Key of the discover search field.
  static const searchKey = Key('projects.search');

  /// Key of the tab for [kind].
  static Key tabKey(ProjectListKind kind) => Key('projects.tab.${kind.name}');

  @override
  ConsumerState<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  ProjectListKind _kind = ProjectListKind.mine;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref
          .read(projectListViewModelProvider(ProjectListKind.discover).notifier)
          .search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final narrow = MediaQuery.sizeOf(context).width < 600;

    return StudioScaffold(
      title: 'PROJECTS',
      actions: [
        const _InboxButton(),
        IconButton(
          key: ProjectsView.signOutKey,
          tooltip: 'Sign out',
          icon: const Icon(Icons.logout_rounded),
          onPressed: () =>
              ref.read(projectsViewModelProvider.notifier).signOut(),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StaggeredReveal(
              index: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR STUDIO',
                          style: styles.eyebrow.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Sessions',
                          style: narrow ? styles.display : styles.displayLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: narrow ? 150 : 240,
                    child: DawButton(
                      key: ProjectsView.newProjectKey,
                      label: narrow ? 'New' : 'New project',
                      icon: Icons.add_rounded,
                      onPressed: () => const ProjectFormRoute().go(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            StaggeredReveal(
              index: 1,
              child: DawSegmentedControl<ProjectListKind>(
                selected: _kind,
                onChanged: (kind) => setState(() => _kind = kind),
                segments: [
                  DawSegment(
                    key: ProjectsView.tabKey(ProjectListKind.mine),
                    value: ProjectListKind.mine,
                    label: 'Mine',
                    icon: Icons.album_outlined,
                  ),
                  DawSegment(
                    key: ProjectsView.tabKey(ProjectListKind.shared),
                    value: ProjectListKind.shared,
                    label: 'Shared',
                    icon: Icons.group_outlined,
                  ),
                  DawSegment(
                    key: ProjectsView.tabKey(ProjectListKind.discover),
                    value: ProjectListKind.discover,
                    label: 'Discover',
                    icon: Icons.explore_outlined,
                  ),
                ],
              ),
            ),
            if (_kind == ProjectListKind.discover) ...[
              const SizedBox(height: AppSpacing.md),
              TextField(
                key: ProjectsView.searchKey,
                maxLength: ValidationRules.searchQueryMaxLength,
                onChanged: _onSearch,
                style: styles.body,
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: 'Search public projects by name',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: StaggeredReveal(
                index: 2,
                child: ProjectListBody(key: ValueKey(_kind), kind: _kind),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inbox button with a badge counting pending invitations.
class _InboxButton extends ConsumerWidget {
  const _InboxButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      inboxViewModelProvider.select((s) => s.value?.invitations.length ?? 0),
    );
    return IconButton(
      key: ProjectsView.inboxKey,
      tooltip: 'Inbox',
      onPressed: () => const InboxRoute().go(context),
      icon: Badge(
        isLabelVisible: count > 0,
        backgroundColor: context.dawColors.record,
        label: Text('$count'),
        child: const Icon(Icons.inbox_outlined),
      ),
    );
  }
}
