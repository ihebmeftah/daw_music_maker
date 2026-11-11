import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// A line of muted text followed by an accent text link, e.g.
/// "No account yet? Create one".
class AuthLink extends StatelessWidget {
  /// Creates the link row.
  const AuthLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
    this.alignment = MainAxisAlignment.center,
  });

  /// Leading muted text (may be empty).
  final String prompt;

  /// Link label.
  final String action;

  /// Called when the link is tapped (disabled when null).
  final VoidCallback? onTap;

  /// Row alignment.
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Wrap(
      alignment: switch (alignment) {
        MainAxisAlignment.end => WrapAlignment.end,
        MainAxisAlignment.start => WrapAlignment.start,
        _ => WrapAlignment.center,
      },
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (prompt.isNotEmpty) Text(prompt, style: styles.bodySmall),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            textStyle: styles.label,
            foregroundColor: context.colors.primary,
          ),
          child: Text(action),
        ),
      ],
    );
  }
}
