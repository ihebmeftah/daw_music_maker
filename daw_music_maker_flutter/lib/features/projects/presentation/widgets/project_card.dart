import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/daw/tag_chip.dart';
import 'access_badge.dart';

/// A project tile in the lists: a colored "track" stripe, name, badges,
/// description, genres and member count. Lifts and glows on hover.
class ProjectCard extends StatefulWidget {
  /// Creates a card for [project].
  const ProjectCard({super.key, required this.project, required this.onTap});

  /// The project.
  final ProjectResponse project;

  /// Opens the project.
  final VoidCallback onTap;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final colors = context.colors;
    final daw = context.dawColors;
    final styles = context.textStyles;
    // A stable per-project "track color" picked from the accent palette.
    final stripe = [
      daw.waveStart,
      daw.meterLow,
      daw.waveEnd,
      colors.secondary,
    ][project.id.hashCode.abs() % 4];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedSlide(
        duration: AppDurations.fast,
        offset: Offset(0, _hovered ? -0.015 : 0),
        child: AnimatedContainer(
          duration: AppDurations.medium,
          decoration: BoxDecoration(
            color: daw.panel,
            borderRadius: AppRadii.lgAll,
            border: Border.all(
              color: _hovered ? stripe.withValues(alpha: 0.7) : daw.panelBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered ? daw.cursorGlow : daw.shadow,
                blurRadius: _hovered ? 28 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: AppRadii.lgAll,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: AppSpacing.xs + 2,
                    decoration: BoxDecoration(
                      color: stripe,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(AppRadii.lg),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  project.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styles.headline,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              StatusBadge.access(context, project.access),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            project.description.isEmpty
                                ? 'No description yet.'
                                : project.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styles.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.smd),
                          if (project.genres.isNotEmpty)
                            Wrap(
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: [
                                for (final g in project.genres.take(4))
                                  TagChip(label: g),
                              ],
                            ),
                          const Spacer(),
                          _CardFooter(project: project),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.project});

  final ProjectResponse project;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    return Row(
      children: [
        StatusBadge.visibility(context, project.visibility),
        const SizedBox(width: AppSpacing.sm),
        Icon(Icons.group_outlined, size: 14, color: muted),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${project.memberCount + 1}',
          style: styles.mono.copyWith(fontSize: 12, color: muted),
        ),
        const Spacer(),
        if (project.hasPendingJoinRequest)
          Text(
            'REQUESTED',
            style: styles.eyebrow.copyWith(
              fontSize: 10,
              color: context.colors.primary,
            ),
          )
        else if (project.allowContributions)
          Tooltip(
            message: 'Open to contributors',
            child: Icon(
              Icons.handshake_outlined,
              size: 16,
              color: context.dawColors.meterLow,
            ),
          ),
      ],
    );
  }
}
