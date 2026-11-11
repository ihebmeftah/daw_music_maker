import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/daw_colors.dart';
import '../../../../core/theme/theme_context.dart';

/// Animated spectrum analyzer used as decoration on the auth hero.
///
/// Bars are colored with the meter palette (low → mid → high). Static when
/// animations are disabled.
class SpectrumBars extends StatefulWidget {
  /// Creates a spectrum with [bars] bars, [height] pixels tall.
  const SpectrumBars({super.key, this.bars = 40, this.height = 72});

  /// Number of bars.
  final int bars;

  /// Height in logical pixels.
  final double height;

  @override
  State<SpectrumBars> createState() => _SpectrumBarsState();
}

class _SpectrumBarsState extends State<SpectrumBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
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
    return ExcludeSemantics(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _SpectrumPainter(
              animation: _controller,
              bars: widget.bars,
              palette: context.dawColors,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpectrumPainter extends CustomPainter {
  _SpectrumPainter({
    required this.animation,
    required this.bars,
    required this.palette,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int bars;
  final DawColors palette;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value * 2 * math.pi * 8;
    final gap = 3.0;
    final barWidth = (size.width - gap * (bars - 1)) / bars;
    for (var i = 0; i < bars; i++) {
      final x = i * (barWidth + gap);
      // A rough "music" envelope: louder lows, moving mids, sparse highs.
      final pos = i / bars;
      final envelope = 1 - pos * 0.55;
      final level =
          (0.18 +
                  0.42 * (0.5 + 0.5 * math.sin(t * 0.9 + i * 0.55)) +
                  0.3 * (0.5 + 0.5 * math.sin(t * 1.7 - i * 0.31)))
              .clamp(0.0, 1.0) *
          envelope;
      final h = size.height * level;
      final color = level > 0.72
          ? palette.meterHigh
          : level > 0.5
          ? palette.meterMid
          : palette.meterLow;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - h, barWidth, h),
        const Radius.circular(1.5),
      );
      canvas.drawRRect(rect, Paint()..color = color.withValues(alpha: 0.85));
      // Peak cap.
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - h - 4, barWidth, 1.5),
        Paint()..color = color.withValues(alpha: 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(_SpectrumPainter oldDelegate) =>
      oldDelegate.palette != palette || oldDelegate.bars != bars;
}
