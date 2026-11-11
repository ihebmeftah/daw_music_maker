import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/daw/tag_chip.dart';
import '../../../../shared/widgets/layout/panel.dart';
import 'access_badge.dart';

/// Top panel of the detail screen: badges, name, description, genres and
/// the role-specific [actions].
class ProjectHeader extends StatelessWidget {
  /// Creates the header.
  const ProjectHeader({
    super.key,
    required this.project,
    required this.actions,
  });

  /// The project.
  final ProjectResponse project;

  /// Buttons for what the user can do.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final narrow = MediaQuery.sizeOf(context).width < 600;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusBadge.access(context, project.access),
              StatusBadge.visibility(context, project.visibility),
              if (project.allowContributions)
                StatusBadge(
                  label: 'OPEN TO CONTRIBUTORS',
                  icon: Icons.handshake_outlined,
                  color: context.dawColors.meterLow,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            project.name,
            style: narrow ? styles.display : styles.displayLarge,
          ),
          const SizedBox(height: AppSpacing.smd),
          Text(
            project.description.isEmpty
                ? 'No description yet.'
                : project.description,
            style: styles.body.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          if (project.genres.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [for (final g in project.genres) TagChip(label: g)],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(
            '${project.memberCount + 1} IN THE SESSION',
            style: styles.eyebrow,
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.smd,
              runSpacing: AppSpacing.smd,
              children: [
                for (final action in actions)
                  SizedBox(
                    width: narrow ? double.infinity : 200,
                    child: action,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
