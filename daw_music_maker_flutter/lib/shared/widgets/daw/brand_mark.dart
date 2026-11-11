import 'package:flutter/material.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// The app's logo: a gradient waveform tile with the mono wordmark.
///
/// ```dart
/// const BrandMark()
/// ```
class BrandMark extends StatelessWidget {
  /// Creates the brand mark; [showWordmark] hides the text on tight layouts.
  const BrandMark({super.key, this.showWordmark = true});

  /// Whether to show `DAW/MUSIC/MAKER` next to the tile.
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final daw = context.dawColors;
    return Semantics(
      label: 'DAW Music Maker',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            decoration: BoxDecoration(
              borderRadius: AppRadii.mdAll,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [daw.waveStart, daw.waveEnd],
              ),
            ),
            child: Icon(
              Icons.graphic_eq_rounded,
              size: 20,
              color: context.colors.onPrimary,
            ),
          ),
          if (showWordmark) ...[
            const SizedBox(width: AppSpacing.smd),
            ExcludeSemantics(
              child: Text(
                'DAW/MUSIC/MAKER',
                style: context.textStyles.eyebrow.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
