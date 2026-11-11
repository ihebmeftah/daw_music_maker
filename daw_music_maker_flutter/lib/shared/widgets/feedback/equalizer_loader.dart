import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// A small bouncing equalizer used as a loading indicator.
///
/// Respects "reduce motion": bars are static when animations are disabled.
///
/// ```dart
/// EqualizerLoader(color: context.colors.onPrimary)
/// ```
class EqualizerLoader extends StatefulWidget {
  /// Creates a loader with [bars] bars drawn in [color].
  const EqualizerLoader({
    super.key,
    required this.color,
    this.bars = 4,
    this.height = 16,
  });

  /// Bar color.
  final Color color;

  /// Number of bars.
  final int bars;

  /// Total height in logical pixels.
  final double height;

  @override
  State<EqualizerLoader> createState() => _EqualizerLoaderState();
}

class _EqualizerLoaderState extends State<EqualizerLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < widget.bars; i++)
                _Bar(
                  color: widget.color,
                  // Each bar is phase-shifted so they bounce out of sync.
                  fraction:
                      0.3 +
                      0.7 *
                          (0.5 +
                              0.5 *
                                  math.sin(
                                    _controller.value * 2 * math.pi + i * 1.7,
                                  )),
                  maxHeight: widget.height,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.color,
    required this.fraction,
    required this.maxHeight,
  });

  final Color color;
  final double fraction;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs / 2),
      child: Container(
        width: AppSpacing.xs - 1,
        height: maxHeight * fraction,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSpacing.xxs),
        ),
      ),
    );
  }
}
