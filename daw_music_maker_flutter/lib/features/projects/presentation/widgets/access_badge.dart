import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import 'project_labels.dart';

/// Small mono badge, e.g. the user's access (`OWNER`) or visibility.
class StatusBadge extends StatelessWidget {
  /// Creates a badge with [label], tinted with [color].
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  /// Badge for the user's [access] to a project.
  factory StatusBadge.access(BuildContext context, ProjectAccess access) =>
      StatusBadge(
        label: access.badge,
        color: switch (access) {
          ProjectAccess.owner => context.colors.primary,
          ProjectAccess.write => context.dawColors.meterLow,
          ProjectAccess.read => context.colors.secondary,
          ProjectAccess.none => context.colors.onSurfaceVariant,
        },
      );

  /// Badge for a project's [visibility].
  factory StatusBadge.visibility(
    BuildContext context,
    ProjectVisibility visibility,
  ) => StatusBadge(
    label: visibility.label.toUpperCase(),
    icon: visibility.icon,
    color: context.colors.onSurfaceVariant,
  );

  /// Text.
  final String label;

  /// Tint.
  final Color color;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs + 1,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: context.textStyles.eyebrow.copyWith(
              fontSize: 10,
              letterSpacing: 1.4,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
