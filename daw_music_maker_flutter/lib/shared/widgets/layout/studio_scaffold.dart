import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../buttons/theme_mode_toggle.dart';
import '../daw/brand_mark.dart';

/// Scaffold for signed-in screens: a top bar with back button or brand,
/// a mono title, [actions] and the theme toggle; content is width-capped.
///
/// ```dart
/// StudioScaffold(title: 'PROJECTS', body: list)
/// ```
class StudioScaffold extends StatelessWidget {
  /// Creates the scaffold.
  const StudioScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.maxWidth = 1200,
    this.onBack,
  });

  /// Explicit back action (e.g. `go` to the parent page). When null, a back
  /// button is shown only if the navigator can pop.
  final VoidCallback? onBack;

  /// Upper-case screen title shown in the top bar.
  final String title;

  /// Screen content.
  final Widget body;

  /// Extra top-bar actions (before the theme toggle).
  final List<Widget> actions;

  /// Maximum content width.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final narrow = MediaQuery.sizeOf(context).width < 600;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  if (onBack != null)
                    BackButton(onPressed: onBack)
                  else if (canPop)
                    const BackButton()
                  else
                    BrandMark(showWordmark: !narrow),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.eyebrow.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                  ),
                  ...actions,
                  const ThemeModeToggle(),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.outlineVariant),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
