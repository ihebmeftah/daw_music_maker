import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/audio/metronome.dart';
import '../../../../core/audio/transport_position.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/daw_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/layout/panel.dart';

/// Formats [elapsed] as `mm:ss.cc` (minutes, seconds, hundredths).
String formatElapsed(Duration elapsed) {
  final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
  final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
  final hundredths = ((elapsed.inMilliseconds % 1000) ~/ 10).toString().padLeft(
    2,
    '0',
  );
  return '$minutes:$seconds.$hundredths';
}

/// Formats a continuous [beatPosition] as `BAR n · BEAT m` (1-based, 4/4).
String formatBarBeat(double beatPosition) {
  final beat = beatPosition.floor();
  final bar = beat ~/ Metronome.beatsPerBar + 1;
  final beatInBar = beat % Metronome.beatsPerBar + 1;
  return 'BAR $bar · BEAT $beatInBar';
}

/// The "sound line": a looping [bars]-bar timeline with a moving playhead,
/// a waveform trail of the clicks played so far, the elapsed time and the
/// bar/beat position.
///
/// Repaints with a [Ticker] only while [isPlaying], sampling [position]
/// directly (no provider rebuilds per frame).
class PlaybackTimeline extends StatefulWidget {
  /// Creates the timeline.
  const PlaybackTimeline({
    super.key,
    required this.position,
    required this.isPlaying,
    required this.isMuted,
    this.bars = 4,
  });

  /// Key of the elapsed time text.
  static const elapsedKey = Key('studio.elapsed');

  /// Key of the bar/beat text.
  static const barBeatKey = Key('studio.barBeat');

  /// Playback position source.
  final TransportPosition position;

  /// Whether playback is running (drives the ticker).
  final bool isPlaying;

  /// Whether the clicks are muted (the trail is drawn faded).
  final bool isMuted;

  /// Loop length in bars.
  final int bars;

  @override
  State<PlaybackTimeline> createState() => _PlaybackTimelineState();
}

class _PlaybackTimelineState extends State<PlaybackTimeline>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((_) => _frame.value++);
  final ValueNotifier<int> _frame = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    if (widget.isPlaying) _ticker.start();
  }

  @override
  void didUpdateWidget(PlaybackTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_ticker.isActive) {
      _ticker.start();
    } else if (!widget.isPlaying && _ticker.isActive) {
      _ticker.stop();
      _frame.value++; // Repaint once at the start position.
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // One header row: loop label · position · duration.
          ValueListenableBuilder<int>(
            valueListenable: _frame,
            builder: (context, _, _) {
              final running = widget.position.isRunning;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // The label and position shrink with an ellipsis and the
                  // time scales down, so the row fits on phones too.
                  Expanded(
                    child: Text(
                      'TIMELINE · LOOP ${widget.bars} BARS',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.eyebrow.copyWith(color: colors.primary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      running
                          ? formatBarBeat(widget.position.beatPosition)
                          : 'STOPPED',
                      key: PlaybackTimeline.barBeatKey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.eyebrow,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatElapsed(widget.position.elapsed),
                        key: PlaybackTimeline.elapsedKey,
                        style: styles.monoLarge.copyWith(
                          fontSize: 22,
                          color: running ? colors.primary : colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 112,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _TimelinePainter(
                  position: widget.position,
                  bars: widget.bars,
                  muted: widget.isMuted,
                  palette: context.dawColors,
                  baseline: colors.outlineVariant,
                  barLine: colors.outline,
                  labelStyle: styles.eyebrow.copyWith(fontSize: 9),
                  repaint: _frame,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.position,
    required this.bars,
    required this.muted,
    required this.palette,
    required this.baseline,
    required this.barLine,
    required this.labelStyle,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final TransportPosition position;
  final int bars;
  final bool muted;
  final DawColors palette;
  final Color baseline;
  final Color barLine;
  final TextStyle labelStyle;

  static const double _rulerHeight = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final loopBeats = bars * Metronome.beatsPerBar;
    final beatWidth = size.width / loopBeats;
    final top = _rulerHeight;
    final mid = top + (size.height - top) / 2;
    final amplitude = (size.height - top) / 2 - 4;

    _paintGrid(canvas, size, loopBeats, beatWidth, top);
    canvas.drawLine(
      Offset(0, mid),
      Offset(size.width, mid),
      Paint()
        ..color = baseline
        ..strokeWidth = 1,
    );

    if (!position.isRunning) {
      _paintPlayhead(canvas, size, 0, top);
      return;
    }

    // Position inside the loop; the trail restarts each loop like a looper.
    final loopPosition = position.beatPosition % loopBeats;
    final playheadX = loopPosition * beatWidth;
    _paintTrail(canvas, playheadX, beatWidth, mid, amplitude, size);
    _paintPlayhead(canvas, size, playheadX, top);
  }

  void _paintGrid(
    Canvas canvas,
    Size size,
    int loopBeats,
    double beatWidth,
    double top,
  ) {
    final beatPaint = Paint()
      ..color = palette.gridLine
      ..strokeWidth = 1;
    final barPaint = Paint()
      ..color = barLine.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (var beat = 0; beat <= loopBeats; beat++) {
      final x = math.min(beat * beatWidth, size.width - 0.5);
      final isBar = beat % Metronome.beatsPerBar == 0;
      canvas.drawLine(
        Offset(x, isBar ? 0 : top),
        Offset(x, size.height),
        isBar ? barPaint : beatPaint,
      );
      if (isBar && beat < loopBeats) {
        final label = TextPainter(
          text: TextSpan(
            text: '${beat ~/ Metronome.beatsPerBar + 1}',
            style: labelStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        label.paint(canvas, Offset(x + 4, 1));
      }
    }
  }

  /// Waveform-like bars: every click starts loud and decays until the next
  /// beat; accents (beat 1) are taller.
  void _paintTrail(
    Canvas canvas,
    double playheadX,
    double beatWidth,
    double mid,
    double amplitude,
    Size size,
  ) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [palette.waveStart, palette.waveEnd],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = palette.waveStart.withValues(alpha: muted ? 0.3 : 1);
    const step = 3.0;
    for (double x = 0; x <= playheadX; x += step) {
      final beatIndex = (x / beatWidth).floor();
      final fraction = x / beatWidth - beatIndex;
      final accent = beatIndex % Metronome.beatsPerBar == 0;
      final envelope = math.exp(-fraction * 6) * (accent ? 1.0 : 0.65);
      // A little texture so it reads as sound, not a sawtooth.
      final texture = 0.75 + 0.25 * math.sin(x * 0.9);
      final h = math.max(1.0, amplitude * envelope * texture);
      canvas.drawLine(Offset(x, mid - h), Offset(x, mid + h), paint);
    }
  }

  void _paintPlayhead(Canvas canvas, Size size, double x, double top) {
    final color = palette.record;
    canvas.drawLine(
      Offset(x, top),
      Offset(x, size.height),
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawLine(
      Offset(x, top),
      Offset(x, size.height),
      Paint()
        ..color = color
        ..strokeWidth = 2,
    );
    final head = Path()
      ..moveTo(x - 6, top - 8)
      ..lineTo(x + 6, top - 8)
      ..lineTo(x, top)
      ..close();
    canvas.drawPath(head, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.position != position ||
      old.bars != bars ||
      old.muted != muted ||
      old.palette != palette;
}
