import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/audio/metronome.dart';
import '../../../../core/audio/transport_position.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/daw_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/validation/validation_rules.dart';
import 'timeline_wave.dart';

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

/// The "sound line": the loop the transport plays (pattern or song) drawn as
/// a waveform of its actual notes, a moving playhead, the elapsed time and the
/// bar/beat position. The whole loop is shown faintly; the part already
/// played is lit.
///
/// Repaints with a [Ticker] only while [isPlaying], sampling [position]
/// directly (no provider rebuilds per frame).
class PlaybackTimeline extends StatefulWidget {
  /// Creates the timeline.
  const PlaybackTimeline({
    super.key,
    required this.position,
    required this.isPlaying,
    required this.hits,
    this.bars = 4,
    this.title = 'TIMELINE',
  });

  /// Key of the elapsed time text.
  static const elapsedKey = Key('studio.elapsed');

  /// Key of the bar/beat text.
  static const barBeatKey = Key('studio.barBeat');

  /// Key of the waveform.
  static const waveKey = Key('studio.wave');

  /// Height of the waveform area.
  static const double waveHeight = 56;

  /// Playback position source.
  final TransportPosition position;

  /// Whether playback is running (drives the ticker).
  final bool isPlaying;

  /// Sounds of the loop (see `timelineHits`).
  final List<TimelineHit> hits;

  /// Loop length in bars.
  final int bars;

  /// Label shown before the loop length (pattern name or SONG).
  final String title;

  @override
  State<PlaybackTimeline> createState() => _PlaybackTimelineState();
}

class _PlaybackTimelineState extends State<PlaybackTimeline>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((_) => _frame.value++);
  final ValueNotifier<int> _frame = ValueNotifier(0);
  late List<double> _envelope = _buildEnvelope();

  int get _totalSteps => widget.bars * ValidationRules.stepsPerBar;

  List<double> _buildEnvelope() => waveformEnvelope(widget.hits, _totalSteps);

  @override
  void initState() {
    super.initState();
    if (widget.isPlaying) _ticker.start();
  }

  @override
  void didUpdateWidget(PlaybackTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.hits, widget.hits) ||
        oldWidget.bars != widget.bars) {
      _envelope = _buildEnvelope();
    }
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.smd,
      ),
      decoration: BoxDecoration(
        color: context.dawColors.panel,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: context.dawColors.panelBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // One header row: loop label · position · duration.
          ValueListenableBuilder<int>(
            valueListenable: _frame,
            builder: (context, _, _) {
              final running = widget.position.isRunning;
              return Row(
                children: [
                  // Label and position shrink with an ellipsis and the time
                  // scales down, so the row fits in a narrow column.
                  Expanded(
                    child: Text(
                      '${widget.title} · LOOP ${widget.bars} '
                      'BAR${widget.bars == 1 ? '' : 'S'}',
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
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatElapsed(widget.position.elapsed),
                        key: PlaybackTimeline.elapsedKey,
                        style: styles.monoLarge.copyWith(
                          fontSize: 20,
                          color: running ? colors.primary : colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            key: PlaybackTimeline.waveKey,
            height: PlaybackTimeline.waveHeight,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _WavePainter(
                  envelope: _envelope,
                  totalSteps: _totalSteps,
                  position: widget.position,
                  palette: context.dawColors,
                  baseline: colors.outlineVariant,
                  barLine: colors.outline,
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

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.envelope,
    required this.totalSteps,
    required this.position,
    required this.palette,
    required this.baseline,
    required this.barLine,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<double> envelope;
  final int totalSteps;
  final TransportPosition position;
  final DawColors palette;
  final Color baseline;
  final Color barLine;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.height / 2;
    final amplitude = mid - 2;

    // Bar lines.
    final bars = totalSteps ~/ ValidationRules.stepsPerBar;
    final barPaint = Paint()
      ..color = barLine.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    for (var b = 0; b <= bars; b++) {
      final x = math.min(b / bars * size.width, size.width - 0.5);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), barPaint);
    }
    canvas.drawLine(
      Offset(0, mid),
      Offset(size.width, mid),
      Paint()
        ..color = baseline
        ..strokeWidth = 1,
    );

    // Playhead position inside the loop (the transport starts at step 0).
    final playedSteps = position.isRunning
        ? (position.beatPosition * Metronome.stepsPerBeat) % totalSteps
        : 0.0;
    final playheadX = playedSteps / totalSteps * size.width;

    // Waveform: one vertical line per 2 px, sampled from the envelope.
    final faint = Paint()
      ..color = palette.waveStart.withValues(alpha: 0.25)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final lit = Paint()
      ..shader = LinearGradient(
        colors: [palette.waveStart, palette.waveEnd],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    if (envelope.isNotEmpty) {
      for (double x = 0; x < size.width; x += 2) {
        final index = (x / size.width * envelope.length).floor().clamp(
          0,
          envelope.length - 1,
        );
        final h = envelope[index] * amplitude;
        if (h < 0.5) continue;
        canvas.drawLine(
          Offset(x, mid - h),
          Offset(x, mid + h),
          x <= playheadX ? lit : faint,
        );
      }
    }

    // Playhead.
    final color = palette.record;
    canvas.drawLine(
      Offset(playheadX, 0),
      Offset(playheadX, size.height),
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawLine(
      Offset(playheadX, 0),
      Offset(playheadX, size.height),
      Paint()
        ..color = color
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      !identical(old.envelope, envelope) ||
      old.totalSteps != totalSteps ||
      old.position != position ||
      old.palette != palette;
}
