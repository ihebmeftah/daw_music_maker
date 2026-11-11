import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import 'spectrum_bars.dart';
import 'transport_readout.dart';

/// Brand side of the auth screens: tilted REC sticker, poster headline with
/// a gradient "drop.", tagline, transport readout and a spectrum analyzer.
///
/// [compact] renders a shorter version above the form on narrow screens.
class AuthHero extends StatelessWidget {
  /// Creates the hero.
  const AuthHero({super.key, this.compact = false});

  /// Narrow-screen variant (smaller headline, no tagline).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final headline = compact
        ? styles.display
        : styles.displayLarge.copyWith(
            fontSize: MediaQuery.sizeOf(context).width > 1280 ? 72 : 56,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const StaggeredReveal(index: 0, child: _RecSticker()),
        SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
        StaggeredReveal(
          index: 1,
          child: _Headline(style: headline),
        ),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.lg),
          StaggeredReveal(
            index: 2,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                'Your pattern-based studio in the cloud. Sequence beats, '
                'roll out melodies, arrange and mix — from any desk.',
                style: styles.body.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const StaggeredReveal(index: 3, child: TransportReadout()),
          const SizedBox(height: AppSpacing.xl),
          const StaggeredReveal(
            index: 4,
            child: SizedBox(width: 440, child: SpectrumBars()),
          ),
        ],
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final daw = context.dawColors;
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Make the\nnext '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                colors: [daw.waveStart, daw.waveEnd],
              ).createShader(bounds),
              child: Text('drop.', style: style),
            ),
          ),
        ],
      ),
      style: style,
    );
  }
}

/// Small tilted "● REC — SESSION 001" sticker.
class _RecSticker extends StatelessWidget {
  const _RecSticker();

  @override
  Widget build(BuildContext context) {
    final record = context.dawColors.record;
    return Transform.rotate(
      angle: -0.05,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smd,
          vertical: AppSpacing.xs + 1,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: record, width: 1.4),
          borderRadius: AppRadii.smAll,
        ),
        child: Text(
          '●  REC  —  SESSION 001',
          style: context.textStyles.eyebrow.copyWith(color: record),
        ),
      ),
    );
  }
}
