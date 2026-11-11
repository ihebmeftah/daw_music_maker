import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../core/theme/daw_colors.dart';
import '../../../core/theme/theme_context.dart';

/// Animated studio backdrop: a field of sine waves that swell around the
/// mouse cursor, a soft glow and a circular "oscilloscope" ring that trails
/// the pointer like a shadow made of sound.
///
/// Without a mouse (touch devices) a virtual cursor drifts slowly so the
/// field stays alive. Painting is driven by a [Ticker] and a
/// [CustomPainter] (no widget rebuilds per frame). With "reduce motion"
/// enabled the waves are drawn once, at rest.
///
/// ```dart
/// WaveCursorBackground(child: MyForm())
/// ```
class WaveCursorBackground extends StatefulWidget {
  /// Paints the wave field behind [child].
  const WaveCursorBackground({super.key, required this.child});

  /// Foreground content.
  final Widget child;

  @override
  State<WaveCursorBackground> createState() => _WaveCursorBackgroundState();
}

class _WaveCursorBackgroundState extends State<WaveCursorBackground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_onTick);
  final _WaveFieldState _field = _WaveFieldState();
  Duration _last = Duration.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion && _ticker.isActive) {
      _ticker.stop();
    } else if (!reduceMotion && !_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    _field.advance(dt.clamp(0, 0.05));
  }

  @override
  void dispose() {
    _ticker.dispose();
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: (e) => _field.pointer = e.localPosition,
      onPointerMove: (e) => _field.pointer = e.localPosition,
      child: MouseRegion(
        opaque: false,
        onExit: (_) => _field.pointer = null,
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _WaveFieldPainter(
                    field: _field,
                    palette: context.dawColors,
                  ),
                ),
              ),
            ),
            widget.child,
          ],
        ),
      ),
    );
  }
}

/// Mutable animation state shared between the ticker and the painter.
class _WaveFieldState extends ChangeNotifier {
  /// Seconds since start.
  double time = 0;

  /// Latest real pointer position, or null when there is no mouse.
  Offset? pointer;

  /// Smoothed cursor (the "shadow" trails the real pointer).
  Offset? smoothed;

  /// 0 → idle drift, 1 → following a real pointer.
  double energy = 0;

  void advance(double dt) {
    time += dt;
    final hasPointer = pointer != null;
    // Ease energy toward its target so hover enter/exit fades smoothly.
    energy += ((hasPointer ? 1.0 : 0.0) - energy) * (1 - math.exp(-dt * 4));
    final target = pointer;
    if (target != null) {
      final s = smoothed ?? target;
      // Critically-damped-ish follow: ~120 ms lag gives a trailing shadow.
      final k = 1 - math.exp(-dt * 9);
      smoothed = Offset(
        lerpDouble(s.dx, target.dx, k)!,
        lerpDouble(s.dy, target.dy, k)!,
      );
    }
    notifyListeners();
  }
}

class _WaveFieldPainter extends CustomPainter {
  _WaveFieldPainter({required this.field, required this.palette})
    : super(repaint: field);

  final _WaveFieldState field;
  final DawColors palette;

  static const int _waveCount = 9;
  static const double _step = 6;

  /// Virtual cursor used when there is no mouse: a slow Lissajous drift.
  Offset _driftPoint(Size size, double t) => Offset(
    size.width * (0.5 + 0.32 * math.sin(t * 0.21)),
    size.height * (0.5 + 0.28 * math.sin(t * 0.17 + 1.3)),
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final t = field.time;
    final drift = _driftPoint(size, t);
    final real = field.smoothed ?? drift;
    final energy = field.energy;
    final cursor = Offset.lerp(drift, real, energy)!;

    _paintGrid(canvas, size);
    _paintGlow(canvas, cursor, energy);
    _paintWaves(canvas, size, cursor, t, energy);
    if (energy > 0.01) _paintCursorRing(canvas, cursor, t, energy);
  }

  /// Faint vertical bar lines, like a playlist grid.
  void _paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = palette.gridLine.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    const spacing = 96.0;
    for (var x = spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void _paintGlow(Canvas canvas, Offset cursor, double energy) {
    final radius = 220 + 120 * energy;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.cursorGlow.withValues(
            alpha: palette.cursorGlow.a * (0.45 + 0.55 * energy),
          ),
          palette.cursorGlow.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: cursor, radius: radius));
    canvas.drawCircle(cursor, radius, paint);
  }

  void _paintWaves(
    Canvas canvas,
    Size size,
    Offset cursor,
    double t,
    double energy,
  ) {
    final shader = LinearGradient(
      colors: [palette.waveStart, palette.waveEnd],
    ).createShader(Offset.zero & size);
    const sigmaX = 170.0;
    const sigmaY = 150.0;

    for (var i = 0; i < _waveCount; i++) {
      final baseY = size.height * (0.12 + 0.76 * i / (_waveCount - 1));
      final freq = 0.008 + 0.0035 * (i % 4);
      final speed = 0.7 + 0.25 * (i % 3);
      final phase = i * 0.9;
      final baseAmp = 5.0 + 3.0 * (i % 3);
      // Vertical closeness of this wave to the cursor.
      final dy = baseY - cursor.dy;
      final rowInfluence = math.exp(-(dy * dy) / (2 * sigmaY * sigmaY));

      final path = Path();
      for (double x = 0; x <= size.width + _step; x += _step) {
        final dx = x - cursor.dx;
        final g = rowInfluence * math.exp(-(dx * dx) / (2 * sigmaX * sigmaX));
        final amp = baseAmp + (28 + 46 * energy) * g;
        // Two summed partials give a richer, less "perfect" waveform.
        final y =
            baseY +
            amp *
                (math.sin(x * freq + t * speed + phase) * 0.75 +
                    math.sin(x * freq * 2.7 - t * speed * 1.6) * 0.25 * g);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      final paint = Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 + 1.2 * rowInfluence * energy
        ..color = palette.waveStart.withValues(
          alpha: 0.14 + 0.5 * rowInfluence * (0.35 + 0.65 * energy),
        );
      // `color` alpha modulates the gradient shader.
      canvas.drawPath(path, paint);
    }
  }

  /// Circular waveform ("oscilloscope ring") that trails the pointer.
  void _paintCursorRing(Canvas canvas, Offset c, double t, double energy) {
    for (var ring = 0; ring < 2; ring++) {
      final radius = 26.0 + ring * 16;
      final lobes = 7 + ring * 4;
      final amp = (5.0 - ring * 1.5) * energy;
      final path = Path();
      const segments = 96;
      for (var s = 0; s <= segments; s++) {
        final a = s / segments * 2 * math.pi;
        final r =
            radius +
            amp * math.sin(a * lobes + t * (3.2 - ring)) +
            amp * 0.4 * math.sin(a * (lobes + 3) - t * 2.1);
        final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
        if (s == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      final color = ring == 0 ? palette.waveStart : palette.waveEnd;
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6 - ring * 0.4
          ..color = color.withValues(alpha: (0.75 - ring * 0.3) * energy),
      );
    }
  }

  @override
  bool shouldRepaint(_WaveFieldPainter oldDelegate) =>
      oldDelegate.palette != palette || oldDelegate.field != field;
}
