import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/theme_mode_controller.dart';

/// Icon button that flips between the dark and light themes, with a
/// rotating sun/moon transition.
///
/// ```dart
/// const ThemeModeToggle()
/// ```
class ThemeModeToggle extends ConsumerWidget {
  /// Creates the toggle.
  const ThemeModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: () => ref
          .read(themeModeControllerProvider.notifier)
          .toggle(MediaQuery.platformBrightnessOf(context)),
      icon: AnimatedSwitcher(
        duration: AppDurations.slow,
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween<double>(begin: 0.6, end: 1).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey(isDark),
          color: context.colors.onSurface,
        ),
      ),
    );
  }
}
