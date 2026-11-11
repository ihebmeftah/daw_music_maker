import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// Inline, animated error message for forms. Collapses when [message] is
/// null and slides open when it is set.
///
/// ```dart
/// ErrorBanner(message: state.failure?.message)
/// ```
class ErrorBanner extends StatelessWidget {
  /// Creates a banner showing [message], or nothing when it is null.
  const ErrorBanner({super.key, required this.message});

  /// User-friendly message to show (never raw server text).
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: AppDurations.medium,
        child: message == null
            ? const SizedBox(width: double.infinity)
            : Padding(
                key: ValueKey(message),
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _BannerBody(message: message!),
              ),
      ),
    );
  }
}

class _BannerBody extends StatelessWidget {
  const _BannerBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smd,
        ),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.12),
          borderRadius: AppRadii.mdAll,
          border: Border(left: BorderSide(color: colors.error, width: 3)),
        ),
        child: Row(
          children: [
            Icon(Icons.graphic_eq_rounded, size: 18, color: colors.error),
            const SizedBox(width: AppSpacing.smd),
            Expanded(
              child: Text(
                message,
                style: context.textStyles.bodySmall.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
