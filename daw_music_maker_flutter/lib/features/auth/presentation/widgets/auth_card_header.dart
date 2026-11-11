import 'package:flutter/material.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// Heading of an auth card: mono channel label, title and subtitle.
///
/// Cross-fades when its texts change (e.g. between flow steps).
class AuthCardHeader extends StatelessWidget {
  /// Creates the header.
  const AuthCardHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  /// Small upper-case label, e.g. `CH 01 — SIGN IN`.
  final String eyebrow;

  /// Card title.
  final String title;

  /// Explanatory line below the title.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return AnimatedSwitcher(
      duration: AppDurations.medium,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topLeft,
        children: [...previous, ?current],
      ),
      child: Column(
        key: ValueKey(title),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: styles.eyebrow.copyWith(color: context.colors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: styles.display),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: styles.bodySmall),
        ],
      ),
    );
  }
}
