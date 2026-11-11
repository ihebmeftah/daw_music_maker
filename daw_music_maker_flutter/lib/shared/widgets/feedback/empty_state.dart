import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Centered placeholder for empty lists: icon, title, message and an
/// optional action.
///
/// ```dart
/// EmptyState(
///   icon: Icons.library_music_outlined,
///   title: 'No projects yet',
///   message: 'Start your first track.',
///   action: DawButton(label: 'New project', onPressed: _create),
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Creates an empty state.
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  /// Illustration icon.
  final IconData icon;

  /// Headline.
  final String title;

  /// Explanation.
  final String message;

  /// Optional call to action.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSpacing.xxl, color: context.colors.primary),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: styles.headline, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: styles.bodySmall,
                textAlign: TextAlign.center,
              ),
              if (action != null) ...[
                const SizedBox(height: AppSpacing.lg),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
