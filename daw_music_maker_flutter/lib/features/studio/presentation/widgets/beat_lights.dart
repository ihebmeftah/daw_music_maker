import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/audio/metronome.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// One pad per beat of the bar, lit while that beat plays. Beat 1 (the
/// accent) lights in the record color.
class BeatLights extends StatelessWidget {
  /// Creates the lights following [beat].
  const BeatLights({super.key, required this.beat, this.compact = false});

  /// Small LEDs without numbers (toolbar) instead of large pads.
  final bool compact;

  /// Key of the pad for [index].
  static Key padKey(int index) => Key('studio.beat.$index');

  /// Current beat (0-based), null when stopped.
  final ValueListenable<int?> beat;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ValueListenableBuilder<int?>(
        valueListenable: beat,
        builder: (context, current, _) => Row(
          // Size to the pads so the lights don't claim a whole toolbar line.
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < Metronome.beatsPerBar; i++) ...[
              if (i > 0)
                SizedBox(width: compact ? AppSpacing.xs : AppSpacing.smd),
              _Pad(
                key: padKey(i),
                index: i,
                lit: current == i,
                compact: compact,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pad extends StatelessWidget {
  const _Pad({
    super.key,
    required this.index,
    required this.lit,
    required this.compact,
  });

  final int index;
  final bool lit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final daw = context.dawColors;
    final colors = context.colors;
    final color = index == 0 ? daw.record : daw.waveStart;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 70),
      width: compact ? AppSpacing.smd : AppSpacing.xxl,
      height: compact ? AppSpacing.smd : AppSpacing.xxl,
      decoration: BoxDecoration(
        borderRadius: compact ? AppRadii.smAll : AppRadii.mdAll,
        color: lit ? color : colors.surfaceContainerHigh,
        border: Border.all(
          color: lit ? color : color.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          if (lit)
            BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 24),
        ],
      ),
      alignment: Alignment.center,
      child: compact
          ? null
          : Text(
              '${index + 1}',
              style: context.textStyles.mono.copyWith(
                color: lit ? colors.onPrimary : colors.onSurfaceVariant,
              ),
            ),
    );
  }
}
