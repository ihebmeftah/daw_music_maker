import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/buttons/theme_mode_toggle.dart';
import '../../../../shared/widgets/daw/brand_mark.dart';
import '../../../../shared/widgets/daw/wave_cursor_background.dart';
import '../../../../shared/widgets/layout/spotlight_panel.dart';
import 'auth_hero.dart';

/// Shared layout of every auth screen: the cursor-reactive wave backdrop, a
/// top bar with the brand and theme toggle, the [AuthHero] and a
/// [SpotlightPanel] holding [card].
///
/// Side-by-side on wide screens, stacked and scrollable on narrow ones.
class AuthShell extends StatelessWidget {
  /// Creates the shell around the form [card].
  const AuthShell({super.key, required this.card});

  /// Form content shown inside the lit panel.
  final Widget card;

  @override
  Widget build(BuildContext context) {
    final panel = StaggeredReveal(
      index: 2,
      offset: 40,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.formMaxWidth),
        child: SpotlightPanel(child: card),
      ),
    );

    return Scaffold(
      body: WaveCursorBackground(
        child: SafeArea(
          child: Column(
            children: [
              const _TopBar(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) =>
                      constraints.maxWidth >= AppSpacing.wideBreakpoint
                      ? _WideLayout(panel: panel)
                      : _NarrowLayout(panel: panel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.panel});

  final Widget panel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            child: Align(alignment: Alignment.centerLeft, child: AuthHero()),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: panel,
            ),
          ),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.panel});

  final Widget panel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.formMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHero(compact: true),
              const SizedBox(height: AppSpacing.lg),
              panel,
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          BrandMark(),
          Spacer(),
          ThemeModeToggle(),
        ],
      ),
    );
  }
}
