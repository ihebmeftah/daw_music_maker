import 'package:flutter/material.dart';

/// Draws a waveform outline ([peaks], 0–1) as mirrored vertical bars.
class WaveformPainter extends CustomPainter {
  /// Creates the painter.
  const WaveformPainter({
    required this.peaks,
    required this.color,
    this.from = 0,
    this.to = 1,
  });

  /// Waveform outline (0–1).
  final List<double> peaks;

  /// Bar color.
  final Color color;

  /// Part of the outline to draw (fractions), e.g. a sampler region.
  final double from;

  /// End of the part to draw (fraction).
  final double to;

  @override
  void paint(Canvas canvas, Size size) {
    if (peaks.isEmpty || size.width <= 0) return;
    final mid = size.height / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (double x = 0; x < size.width; x += 2) {
      final frac = from + (to - from) * (x / size.width);
      final index = (frac * peaks.length).floor().clamp(0, peaks.length - 1);
      final h = peaks[index] * (mid - 1);
      if (h < 0.5) continue;
      canvas.drawLine(Offset(x, mid - h), Offset(x, mid + h), paint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter old) =>
      !identical(old.peaks, peaks) ||
      old.color != color ||
      old.from != from ||
      old.to != to;
}
