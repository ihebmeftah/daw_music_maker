import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';

/// Fades and slides [child] in once, delayed by [index] steps, to build
/// staggered entrance animations.
///
/// Shows [child] immediately when animations are disabled.
///
/// ```dart
/// Column(children: [
///   StaggeredReveal(index: 0, child: Title()),
///   StaggeredReveal(index: 1, child: Form()),
/// ])
/// ```
class StaggeredReveal extends StatefulWidget {
  /// Creates a reveal for the [index]-th item.
  const StaggeredReveal({
    super.key,
    required this.index,
    required this.child,
    this.step = const Duration(milliseconds: 90),
    this.offset = 24,
  });

  /// Position in the sequence; the delay is `index * step`.
  final int index;

  /// Delay between consecutive items.
  final Duration step;

  /// Vertical slide distance in logical pixels.
  final double offset;

  /// The revealed widget.
  final Widget child;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.entrance,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutQuart,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }
    Future<void>.delayed(widget.step * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, widget.offset * (1 - _curve.value)),
          child: child,
        ),
      ),
    );
  }
}
