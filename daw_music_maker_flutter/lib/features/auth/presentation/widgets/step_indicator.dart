import 'package:flutter/material.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// Step progress drawn as step-sequencer pads: completed and current steps
/// light up, the current one glows.
class StepIndicator extends StatelessWidget {
  /// Creates an indicator for [labels], with [current] (0-based) active.
  const StepIndicator({super.key, required this.labels, required this.current});

  /// One label per step.
  final List<String> labels;

  /// Index of the active step.
  final int current;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step ${current + 1} of ${labels.length}: ${labels[current]}',
      child: ExcludeSemantics(
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _Pad(
                  index: i,
                  label: labels[i],
                  lit: i <= current,
                  active: i == current,
                ),
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
    required this.index,
    required this.label,
    required this.lit,
    required this.active,
  });

  final int index;
  final String label;
  final bool lit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final daw = context.dawColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: AppDurations.slow,
          curve: Curves.easeOutCubic,
          height: AppSpacing.sm - 2,
          decoration: BoxDecoration(
            borderRadius: AppRadii.smAll,
            color: lit ? null : colors.surfaceContainerHighest,
            gradient: lit
                ? LinearGradient(colors: [daw.waveStart, daw.waveEnd])
                : null,
            boxShadow: [
              if (active) BoxShadow(color: daw.cursorGlow, blurRadius: 12),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        AnimatedDefaultTextStyle(
          duration: AppDurations.medium,
          style: context.textStyles.eyebrow.copyWith(
            fontSize: 10,
            color: lit ? colors.onSurface : colors.onSurfaceVariant,
          ),
          child: Text('${(index + 1).toString().padLeft(2, '0')} $label'),
        ),
      ],
    );
  }
}
