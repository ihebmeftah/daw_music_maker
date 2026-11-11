import 'package:flutter/material.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// A titled section surface (like a rack unit): eyebrow, title, optional
/// trailing action, then [child].
///
/// ```dart
/// Panel(eyebrow: 'MEMBERS', title: '3 collaborators', child: list)
/// ```
class Panel extends StatelessWidget {
  /// Creates a panel.
  const Panel({
    super.key,
    required this.child,
    this.eyebrow,
    this.title,
    this.trailing,
  });

  /// Small upper-case label.
  final String? eyebrow;

  /// Section title.
  final String? title;

  /// Action shown on the header's right.
  final Widget? trailing;

  /// Content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.dawColors.panel,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: context.dawColors.panelBorder),
      ),
      // Transparent material so ink effects (list tiles, buttons) paint above
      // the panel's background color.
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (eyebrow != null || title != null || trailing != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eyebrow != null)
                          Text(
                            eyebrow!,
                            style: styles.eyebrow.copyWith(
                              color: colors.primary,
                            ),
                          ),
                        if (title != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(title!, style: styles.headline),
                        ],
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
