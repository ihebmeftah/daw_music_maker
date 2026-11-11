import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// Pulses per quarter note used for the bars:beats:ticks display.
const int _kPpq = 960;

/// Formats elapsed [ticks] at 4/4 as `BBB:B:TTT` (bar, beat, tick), 1-based.
String formatBarsBeatsTicks(int ticks) {
  final bar = ticks ~/ (_kPpq * 4) + 1;
  final beat = (ticks ~/ _kPpq) % 4 + 1;
  final tick = ticks % _kPpq;
  return '${bar.toString().padLeft(3, '0')}:$beat:'
      '${tick.toString().padLeft(3, '0')}';
}

/// Decorative DAW transport display: a blinking record light, the tempo and
/// a running bars:beats:ticks position.
class TransportReadout extends StatefulWidget {
  /// Creates a readout running at [bpm].
  const TransportReadout({super.key, this.bpm = 128});

  /// Tempo in beats per minute.
  final double bpm;

  @override
  State<TransportReadout> createState() => _TransportReadoutState();
}

class _TransportReadoutState extends State<TransportReadout>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_onTick);
  final ValueNotifier<int> _ticks = ValueNotifier(0);

  void _onTick(Duration elapsed) {
    // ticks = seconds × (bpm / 60) × PPQ, kept as an integer.
    _ticks.value = (elapsed.inMicroseconds / 1e6 * widget.bpm / 60 * _kPpq)
        .floor();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion && _ticker.isActive) {
      _ticker.stop();
    } else if (!reduceMotion && !_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _ticks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.smd,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainer.withValues(alpha: 0.7),
        borderRadius: AppRadii.mdAll,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _ticks,
        builder: (context, ticks, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RecLight(on: (ticks ~/ _kPpq).isEven),
            const SizedBox(width: AppSpacing.smd),
            Text(widget.bpm.toStringAsFixed(2), style: styles.mono),
            const SizedBox(width: AppSpacing.xs),
            Text('BPM', style: styles.eyebrow),
            const SizedBox(width: AppSpacing.md),
            Text(
              formatBarsBeatsTicks(ticks),
              style: styles.mono.copyWith(color: colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecLight extends StatelessWidget {
  const _RecLight({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final record = context.dawColors.record;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: AppSpacing.smd - 2,
      height: AppSpacing.smd - 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? record : record.withValues(alpha: 0.25),
        boxShadow: [
          if (on)
            BoxShadow(color: record.withValues(alpha: 0.6), blurRadius: 8),
        ],
      ),
    );
  }
}
