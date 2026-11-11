import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/daw_colors.dart';
import '../../../core/theme/theme_context.dart';

/// Frosted-glass panel lit by the mouse cursor.
///
/// A light follows the pointer across the surface and border, and the drop
/// shadow shifts away from it as if the cursor were a lamp above the desk.
///
/// ```dart
/// SpotlightPanel(child: LoginForm())
/// ```
class SpotlightPanel extends StatefulWidget {
  /// Creates a panel around [child].
  const SpotlightPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
  });

  /// Panel content.
  final Widget child;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  @override
  State<SpotlightPanel> createState() => _SpotlightPanelState();
}

class _SpotlightPanelState extends State<SpotlightPanel> {
  /// Pointer position relative to the panel, or null when outside.
  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);
  Size _size = Size.zero;

  @override
  void dispose() {
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final daw = context.dawColors;
    return MouseRegion(
      opaque: false,
      onHover: (e) => _pointer.value = e.localPosition,
      onExit: (_) => _pointer.value = null,
      child: ValueListenableBuilder<Offset?>(
        valueListenable: _pointer,
        builder: (context, pointer, child) => _ShadowFrame(
          pointer: pointer,
          size: _size,
          shadow: daw.shadow,
          glow: daw.cursorGlow,
          child: child!,
        ),
        child: ClipRRect(
          borderRadius: AppRadii.lgAll,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Remember the size so the shadow can be offset relative to
                // the panel center.
                _size = constraints.biggest.isFinite
                    ? constraints.biggest
                    : _size;
                return CustomPaint(
                  painter: _SpotlightPainter(pointer: _pointer, palette: daw),
                  child: Padding(padding: widget.padding, child: widget.child),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Outer shadow that moves away from the pointer.
class _ShadowFrame extends StatelessWidget {
  const _ShadowFrame({
    required this.pointer,
    required this.size,
    required this.shadow,
    required this.glow,
    required this.child,
  });

  final Offset? pointer;
  final Size size;
  final Color shadow;
  final Color glow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final center = size.center(Offset.zero);
    final offset = pointer == null
        ? const Offset(0, 24)
        : (center - pointer!) / 14 + const Offset(0, 16);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        borderRadius: AppRadii.lgAll,
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 60, offset: offset),
          if (pointer != null)
            BoxShadow(color: glow, blurRadius: 40, spreadRadius: -12),
        ],
      ),
      child: child,
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({required this.pointer, required this.palette})
    : super(repaint: pointer);

  final ValueNotifier<Offset?> pointer;
  final DawColors palette;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = AppRadii.lgAll.toRRect(rect);
    canvas.drawRRect(rrect, Paint()..color = palette.panel);

    final p = pointer.value;
    if (p != null) {
      // Surface light.
      canvas.drawRRect(
        rrect,
        Paint()
          ..shader = RadialGradient(
            colors: [
              palette.cursorGlow.withValues(alpha: palette.cursorGlow.a * 0.5),
              palette.cursorGlow.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: p, radius: 260)),
      );
    }

    // Border: resting color everywhere, brightened near the pointer.
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = palette.panelBorder;
    canvas.drawRRect(rrect.deflate(0.6), border);
    if (p != null) {
      canvas.drawRRect(
        rrect.deflate(0.6),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..shader = RadialGradient(
            colors: [palette.waveStart, palette.waveStart.withValues(alpha: 0)],
          ).createShader(Rect.fromCircle(center: p, radius: 180)),
      );
    }
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.palette != palette || oldDelegate.pointer != pointer;
}
