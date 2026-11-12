import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/daw_colors.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../data/studio_clip.dart';
import '../state/grid_snap.dart';
import 'browser_item.dart';
import 'snap_selector.dart';
import 'waveform.dart';

/// FL Studio–style playlist: tracks (rows) × bars (columns) with pattern
/// clips. Click places the selected pattern (or removes the clip under the
/// pointer); right-click / long-press selects a clip's pattern. In song
/// mode the playhead runs across the arrangement.
class PlaylistView extends StatelessWidget {
  /// Creates the playlist.
  const PlaylistView({
    super.key,
    required this.clips,
    required this.patterns,
    required this.selectedPattern,
    required this.songBars,
    required this.canEdit,
    required this.isSongMode,
    required this.playhead,
    required this.onToggleCell,
    required this.onPickClip,
    required this.onDropSample,
    this.samples = const [],
    this.snap = GridSnap.bar,
    this.onSnapChanged,
  });

  /// Key of the snap selector.
  static const snapKey = Key('playlist.snap');

  /// Snap grid (where clips land); also sets the drawn grid lines.
  final GridSnap snap;

  /// Called when the user picks another snap.
  final ValueChanged<GridSnap>? onSnapChanged;

  /// Uploaded samples (audio clip names, waveforms).
  final List<SampleResponse> samples;

  /// An uploaded sample was dropped on [track] at a step (unsnapped).
  final void Function(UuidValue sampleId, int track, int step) onDropSample;

  /// Key of the clip grid.
  static const gridKey = Key('playlist.grid');

  /// Height of one track row.
  static const double trackHeight = 34;

  /// Width of one bar column.
  static const double barWidth = 48;

  /// Height of the bar ruler.
  static const double rulerHeight = 20;

  /// Width of the track headers.
  static const double headerWidth = 84;

  /// Bars shown beyond the end of the song (room to keep arranging).
  static const int spareBars = 8;

  /// Minimum bars shown.
  static const int minBars = 32;

  /// Clips of the playlist.
  final List<StudioClip> clips;

  /// Patterns of the project (names, colors and lengths).
  final List<PatternResponse> patterns;

  /// The pattern a click places.
  final PatternResponse? selectedPattern;

  /// End of the arrangement in bars.
  final int songBars;

  /// Whether the user may edit.
  final bool canEdit;

  /// Whether the transport plays the song (shows the playhead).
  final bool isSongMode;

  /// Absolute transport step (null when stopped).
  final ValueListenable<int?> playhead;

  /// Click on a track at a step (unsnapped; the ViewModel snaps).
  final void Function(int track, int step) onToggleCell;

  /// Right-click / long-press on a track at a step.
  final void Function(int track, int step) onPickClip;

  /// Bars drawn in the grid.
  int get visibleBars => (songBars + spareBars)
      .clamp(minBars, ValidationRules.playlistBarsMax)
      .toInt();

  /// Width of one step (1/16 note).
  static const double stepWidth = barWidth / ValidationRules.stepsPerBar;

  /// Track and (unsnapped) step at a position in the grid.
  static (int track, int step) cellAt(Offset position) => (
    (position.dy / trackHeight).floor().clamp(
      0,
      ValidationRules.playlistTracks - 1,
    ),
    (position.dx / stepWidth).floor().clamp(
      0,
      ValidationRules.playlistBarsMax * ValidationRules.stepsPerBar - 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    final pattern = selectedPattern;
    final bars = visibleBars;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'PLAYLIST',
              style: styles.eyebrow.copyWith(color: colors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Text(
                !canEdit
                    ? 'READ ONLY'
                    : pattern == null
                    ? 'SELECT A PATTERN TO PLACE'
                    : 'CLICK TO PLACE “${pattern.name.toUpperCase()}” · '
                          'CLICK A CLIP TO REMOVE · RIGHT-CLICK TO EDIT ITS PATTERN',
                overflow: TextOverflow.ellipsis,
                style: styles.eyebrow.copyWith(fontSize: 9),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (onSnapChanged != null)
              SnapSelector(
                key: snapKey,
                value: snap,
                options: GridSnap.playlistOptions,
                onChanged: onSnapChanged!,
              ),
            const SizedBox(width: AppSpacing.sm),
            Text('$songBars BARS', style: styles.mono),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TrackHeaders(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DragTarget<BrowserItem>(
                      onWillAcceptWithDetails: (d) =>
                          canEdit && d.data.sampleId != null,
                      onAcceptWithDetails: (d) {
                        final box = context.findRenderObject() as RenderBox?;
                        final grid = _gridKeyBox(context);
                        if (box == null || grid == null) return;
                        final local =
                            grid.globalToLocal(d.offset) -
                            const Offset(0, rulerHeight);
                        if (local.dy < 0) return;
                        final (track, bar) = cellAt(local);
                        onDropSample(d.data.sampleId!, track, bar);
                      },
                      builder: (context, _, _) => GestureDetector(
                        key: gridKey,
                        behavior: HitTestBehavior.opaque,
                        onTapUp: canEdit
                            ? (d) {
                                final (track, bar) = cellAt(
                                  d.localPosition -
                                      const Offset(0, rulerHeight),
                                );
                                if (d.localPosition.dy >= rulerHeight) {
                                  onToggleCell(track, bar);
                                }
                              }
                            : null,
                        onSecondaryTapUp: (d) {
                          final (track, bar) = cellAt(
                            d.localPosition - const Offset(0, rulerHeight),
                          );
                          onPickClip(track, bar);
                        },
                        onLongPressStart: (d) {
                          final (track, bar) = cellAt(
                            d.localPosition - const Offset(0, rulerHeight),
                          );
                          onPickClip(track, bar);
                        },
                        child: RepaintBoundary(
                          child: CustomPaint(
                            size: Size(
                              bars * barWidth,
                              rulerHeight +
                                  ValidationRules.playlistTracks * trackHeight,
                            ),
                            painter: _PlaylistPainter(
                              clips: clips,
                              patterns: {for (final p in patterns) p.id: p},
                              samples: {for (final s in samples) s.id: s},
                              audioColor: colors.secondary,
                              bars: bars,
                              songBars: songBars,
                              isSongMode: isSongMode,
                              playhead: playhead,
                              snapSteps: snap.steps,
                              palette: context.dawColors,
                              rowA: colors.surfaceContainerHigh,
                              rowB: colors.surfaceContainer,
                              barLine: colors.outlineVariant,
                              text: colors.onSurfaceVariant,
                              clipText: colors.inverseSurface,
                              labelStyle: styles.mono.copyWith(fontSize: 10),
                              clipStyle: styles.label.copyWith(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Render box of the clip grid, for converting drop positions.
  static RenderBox? _gridKeyBox(BuildContext context) {
    RenderBox? found;
    void visit(Element element) {
      if (found != null) return;
      if (element.widget.key == gridKey) {
        found = element.findRenderObject() as RenderBox?;
        return;
      }
      element.visitChildren(visit);
    }

    (context as Element).visitChildren(visit);
    return found;
  }
}

class _TrackHeaders extends StatelessWidget {
  const _TrackHeaders();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: PlaylistView.headerWidth,
      child: Column(
        children: [
          const SizedBox(height: PlaylistView.rulerHeight),
          for (var t = 0; t < ValidationRules.playlistTracks; t++)
            Container(
              height: PlaylistView.trackHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                border: Border(
                  bottom: BorderSide(color: colors.outlineVariant, width: 0.5),
                ),
              ),
              child: Text(
                'Track ${t + 1}',
                style: context.textStyles.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaylistPainter extends CustomPainter {
  _PlaylistPainter({
    required this.clips,
    required this.patterns,
    required this.samples,
    required this.audioColor,
    required this.bars,
    required this.songBars,
    required this.isSongMode,
    required this.playhead,
    required this.snapSteps,
    required this.palette,
    required this.rowA,
    required this.rowB,
    required this.barLine,
    required this.text,
    required this.clipText,
    required this.labelStyle,
    required this.clipStyle,
  }) : super(repaint: playhead);

  final List<StudioClip> clips;
  final Map<UuidValue, PatternResponse> patterns;
  final Map<UuidValue, SampleResponse> samples;
  final Color audioColor;
  final int bars;
  final int songBars;
  final bool isSongMode;
  final ValueListenable<int?> playhead;
  final int snapSteps;
  final DawColors palette;
  final Color rowA;
  final Color rowB;
  final Color barLine;
  final Color text;
  final Color clipText;
  final TextStyle labelStyle;
  final TextStyle clipStyle;

  @override
  void paint(Canvas canvas, Size size) {
    const top = PlaylistView.rulerHeight;
    const rowH = PlaylistView.trackHeight;
    const barW = PlaylistView.barWidth;

    // Tracks.
    for (var t = 0; t < ValidationRules.playlistTracks; t++) {
      canvas.drawRect(
        Rect.fromLTWH(0, top + t * rowH, size.width, rowH),
        Paint()..color = t.isEven ? rowA : rowB,
      );
    }
    // Snap lines (beats / steps) under the bar lines.
    if (snapSteps < ValidationRules.stepsPerBar) {
      final snapPaint = Paint()
        ..color = barLine.withValues(alpha: snapSteps >= 4 ? 0.45 : 0.2)
        ..strokeWidth = 0.5;
      final totalSteps = bars * ValidationRules.stepsPerBar;
      for (var st = snapSteps; st < totalSteps; st += snapSteps) {
        if (st % ValidationRules.stepsPerBar == 0) continue;
        final x = st * PlaylistView.stepWidth;
        canvas.drawLine(Offset(x, top), Offset(x, size.height), snapPaint);
      }
    }
    // Bars + ruler numbers; the song end is marked.
    for (var b = 0; b <= bars; b++) {
      final x = b * barW;
      canvas.drawLine(
        Offset(x, top),
        Offset(x, size.height),
        Paint()
          ..color = b == songBars
              ? palette.record.withValues(alpha: 0.6)
              : barLine
          ..strokeWidth = b % 4 == 0 ? 1.2 : 0.5,
      );
      if (b < bars) {
        (TextPainter(
          text: TextSpan(
            text: '${b + 1}',
            style: labelStyle.copyWith(color: text),
          ),
          textDirection: TextDirection.ltr,
        )..layout()).paint(canvas, Offset(x + 3, 3));
      }
    }
    // Clips: patterns in their color, audio clips with their waveform.
    for (final clip in clips) {
      final String name;
      final Color color;
      final int length;
      final List<double>? peaks;
      if (clip.isAudio) {
        final sample = samples[clip.sampleId];
        if (sample == null) continue;
        name = sample.name;
        color = audioColor;
        length = clip.lengthBars ?? 1;
        peaks = sample.peaks;
      } else {
        final pattern = patterns[clip.patternId];
        if (pattern == null) continue;
        name = pattern.name;
        color = palette.trackColor(pattern.colorIndex);
        length = pattern.lengthBars;
        peaks = null;
      }
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          clip.startStep * PlaylistView.stepWidth + 1,
          top + clip.track * rowH + 2,
          length * barW - 2,
          rowH - 4,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, Paint()..color = color.withValues(alpha: 0.85));
      canvas.save();
      canvas.clipRRect(rect);
      if (peaks != null) {
        canvas.save();
        canvas.translate(rect.left, rect.top);
        WaveformPainter(
          peaks: peaks,
          color: clipText.withValues(alpha: 0.35),
        ).paint(canvas, rect.outerRect.size);
        canvas.restore();
      }
      (TextPainter(
        text: TextSpan(
          text: name,
          style: clipStyle.copyWith(color: clipText),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout()).paint(canvas, rect.outerRect.topLeft + const Offset(6, 7));
      canvas.restore();
    }
    // Song playhead.
    final step = playhead.value;
    if (isSongMode && step != null) {
      final songSteps = songBars * ValidationRules.stepsPerBar;
      final x = (step % songSteps) / ValidationRules.stepsPerBar * barW;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = palette.record
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_PlaylistPainter old) =>
      old.clips != clips ||
      old.patterns != patterns ||
      old.samples != samples ||
      old.bars != bars ||
      old.songBars != songBars ||
      old.isSongMode != isSongMode ||
      old.snapSteps != snapSteps ||
      old.palette != palette;
}
