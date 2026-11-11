import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/buttons/theme_mode_toggle.dart';
import '../view_models/projects_view_model.dart';

/// `/projects` — landing screen after signing in.
///
/// Placeholder until the projects feature is built: shows an empty state and
/// a sign-out action.
class ProjectsView extends ConsumerWidget {
  /// Creates the view.
  const ProjectsView({super.key});

  /// Key of the sign-out button.
  static const signOutKey = Key('projects.signOut');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styles = context.textStyles;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.dawColors.backdrop,
        title: Text('PROJECTS', style: styles.eyebrow),
        actions: [
          const ThemeModeToggle(),
          IconButton(
            key: signOutKey,
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () =>
                ref.read(projectsViewModelProvider.notifier).signOut(),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StaggeredReveal(
                  index: 0,
                  child: Icon(
                    Icons.library_music_outlined,
                    size: AppSpacing.xxxl,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                StaggeredReveal(
                  index: 1,
                  child: Text(
                    'Your studio is ready',
                    style: styles.display,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                StaggeredReveal(
                  index: 2,
                  child: Text(
                    'Projects are coming soon. You are signed in.',
                    style: styles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                StaggeredReveal(
                  index: 3,
                  child: DawButton(
                    label: 'Sign out',
                    variant: DawButtonVariant.ghost,
                    icon: Icons.logout_rounded,
                    onPressed: () =>
                        ref.read(projectsViewModelProvider.notifier).signOut(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
