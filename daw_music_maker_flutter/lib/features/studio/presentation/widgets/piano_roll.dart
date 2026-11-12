import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/audio/metronome.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../data/studio_note.dart';

/// Note name in FL Studio's convention (60 = C5).
String pitchName(int pitch) {
  const names = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];
  return '${names[pitch % 12]}${pitch ~/ 12}';
}

/// Whether [pitch] is a black key.
bool isBlackKey(int pitch) => const {1, 3, 6, 8, 10}.contains(pitch % 12);

/// The piano roll of one channel: a keyboard (click to preview) and a
/// pitch × step grid where clicks add or remove one-step notes. The
/// playhead line follows the transport.
class PianoRoll extends StatelessWidget {
  /// Creates the piano roll.
  const PianoRoll({
    super.key,
    required this.channels,
    required this.channel,
    required this.notes,
    required this.steps,
    required this.canEdit,
    required this.playhead,
    required this.onToggleNote,
    required this.onPreview,
    required this.onSelectChannel,
  });

  /// Key of the note grid.
  static const gridKey = Key('pianoRoll.grid');

  /// Key of the channel dropdown.
  static const channelPickerKey = Key('pianoRoll.channel');

  /// Key of the piano key for [pitch].
  static Key keyFor(int pitch) => Key('pianoRoll.key.$pitch');

  /// Highest pitch shown (C7).
  static const int pitchHigh = 84;

  /// Lowest pitch shown (C4).
  static const int pitchLow = 48;

  /// Height of one pitch row.
  static const double rowHeight = 18;

  /// Width of one step column.
  static const double stepWidth = 24;

  /// Channels to choose from.
  final List<ChannelResponse> channels;

  /// The channel being edited.
  final ChannelResponse channel;

  /// Notes of the current pattern for [channel].
  final List<StudioNote> notes;

  /// Steps in the current pattern.
  final int steps;

  /// Whether the user may edit.
  final bool canEdit;

  /// Absolute transport step (null when stopped).
  final ValueListenable<int?> playhead;

  /// Grid click at a step and pitch.
  final void Function(int step, int pitch) onToggleNote;

  /// Piano key click.
  final ValueChanged<int> onPreview;

  /// Pick another channel.
  final ValueChanged<UuidValue> onSelectChannel;

  /// Number of pitch rows.
  static int get rows => pitchHigh - pitchLow + 1;

  /// Pitch at a vertical offset in the grid.
  static int pitchAt(double dy) =>
      (pitchHigh - (dy / rowHeight).floor()).clamp(pitchLow, pitchHigh);

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'PIANO ROLL',
              style: styles.eyebrow.copyWith(color: context.colors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            DropdownButton<UuidValue>(
              key: channelPickerKey,
              value: channel.id,
              underline: const SizedBox.shrink(),
              style: styles.label,
              onChanged: (id) {
                if (id != null) onSelectChannel(id);
              },
              items: [
                for (final c in channels)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
            ),
            const Spacer(),
            Flexible(
              child: Text(
                canEdit
                    ? 'CLICK TO ADD · CLICK A NOTE TO REMOVE · C5 = ORIGINAL PITCH'
                    : 'READ ONLY',
                overflow: TextOverflow.ellipsis,
                style: styles.eyebrow.copyWith(fontSize: 9),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Keyboard(onPreview: onPreview),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: GestureDetector(
                      key: gridKey,
                      onTapUp: canEdit
                          ? (d) => onToggleNote(
                              (d.localPosition.dx / stepWidth).floor().clamp(
                                0,
                                steps - 1,
                              ),
                              pitchAt(d.localPosition.dy),
                            )
                          : null,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          size: Size(steps * stepWidth, rows * rowHeight),
                          painter: _GridPainter(
                            notes: notes,
                            steps: steps,
                            playhead: playhead,
                            noteColor: context.dawColors.trackColor(
                              channels.indexOf(channel),
                            ),
                            black: context.colors.surfaceContainerHighest,
                            white: context.colors.surfaceContainerHigh,
                            beatLine: context.dawColors.gridLine,
                            barLine: context.colors.outline,
                            playheadColor: context.dawColors.record,
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
}

class _Keyboard extends StatelessWidget {
  const _Keyboard({required this.onPreview});

  final ValueChanged<int> onPreview;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          for (var p = PianoRoll.pitchHigh; p >= PianoRoll.pitchLow; p--)
            InkWell(
              key: PianoRoll.keyFor(p),
              onTap: () => onPreview(p),
              child: Container(
                height: PianoRoll.rowHeight,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isBlackKey(p) ? colors.inverseSurface : colors.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: colors.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                ),
                child: p % 12 == 0
                    ? Text(
                        pitchName(p),
                        style: context.textStyles.mono.copyWith(
                          fontSize: 9,
                          color: p == ValidationRules.rootPitch
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        ),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.notes,
    required this.steps,
    required this.playhead,
    required this.noteColor,
    required this.black,
    required this.white,
    required this.beatLine,
    required this.barLine,
    required this.playheadColor,
  }) : super(repaint: playhead);

  final List<StudioNote> notes;
  final int steps;
  final ValueListenable<int?> playhead;
  final Color noteColor;
  final Color black;
  final Color white;
  final Color beatLine;
  final Color barLine;
  final Color playheadColor;

  @override
  void paint(Canvas canvas, Size size) {
    const rowH = PianoRoll.rowHeight;
    const stepW = PianoRoll.stepWidth;
    // Rows: black-key rows darker, like a piano roll.
    for (var p = PianoRoll.pitchHigh; p >= PianoRoll.pitchLow; p--) {
      final y = (PianoRoll.pitchHigh - p) * rowH;
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, rowH),
        Paint()..color = isBlackKey(p) ? black : white,
      );
    }
    // Step / beat / bar lines.
    for (var s = 0; s <= steps; s++) {
      final x = s * stepW;
      final isBar = s % ValidationRules.stepsPerBar == 0;
      final isBeat = s % Metronome.stepsPerBeat == 0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = isBar ? barLine : beatLine
          ..strokeWidth = isBar ? 1.5 : (isBeat ? 1 : 0.5),
      );
    }
    // Notes.
    final fill = Paint()..color = noteColor;
    final edge = Paint()
      ..color = noteColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke;
    for (final n in notes) {
      if (n.pitch < PianoRoll.pitchLow || n.pitch > PianoRoll.pitchHigh) {
        continue;
      }
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          n.tick / ValidationRules.stepTicks * stepW + 1,
          (PianoRoll.pitchHigh - n.pitch) * rowH + 1,
          n.lengthTicks / ValidationRules.stepTicks * stepW - 2,
          rowH - 2,
        ),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, fill);
      canvas.drawRRect(rect, edge);
    }
    // Playhead.
    final step = playhead.value;
    if (step != null) {
      final x = (step % steps) * stepW;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = playheadColor
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.notes != notes ||
      old.steps != steps ||
      old.noteColor != noteColor ||
      old.black != black;
}
