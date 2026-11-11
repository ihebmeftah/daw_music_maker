import 'package:flutter/material.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Small mono tag (e.g. a genre), optionally removable.
///
/// ```dart
/// TagChip(label: 'techno', onDeleted: () => remove('techno'))
/// ```
class TagChip extends StatelessWidget {
  /// Creates a tag.
  const TagChip({super.key, required this.label, this.onDeleted});

  /// Tag text.
  final String label;

  /// Shows a remove button when set.
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.smd,
        right: onDeleted == null ? AppSpacing.smd : AppSpacing.xs,
        top: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.12),
        borderRadius: AppRadii.pillAll,
        border: Border.all(color: colors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$label',
            style: context.textStyles.mono.copyWith(
              fontSize: 12,
              color: colors.primary,
            ),
          ),
          if (onDeleted != null)
            InkWell(
              onTap: onDeleted,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxs),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: colors.primary,
                  semanticLabel: 'Remove $label',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
