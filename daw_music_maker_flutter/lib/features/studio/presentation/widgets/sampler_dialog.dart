import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio_providers.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../shared/widgets/buttons/daw_button.dart';
import '../../../../shared/widgets/inputs/daw_segmented_control.dart';
import '../view_models/studio_view_model.dart';
import 'waveform.dart';

/// Opens the sampler of [channelId] (waveform, trim, volume, pan, pitch,
/// chop).
Future<void> showSamplerDialog(
  BuildContext context, {
  required UuidValue projectId,
  required UuidValue channelId,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => SamplerDialog(projectId: projectId, channelId: channelId),
  );
}

/// The sampler of one channel. Changes are heard immediately and saved when
/// a slider or trim handle is released.
class SamplerDialog extends ConsumerStatefulWidget {
  /// Creates the dialog.
  const SamplerDialog({
    super.key,
    required this.projectId,
    required this.channelId,
  });

  /// Key of the waveform / trim area.
  static const waveKey = Key('sampler.wave');

  /// Key of the volume slider.
  static const volumeKey = Key('sampler.volume');

  /// Key of the pan slider.
  static const panKey = Key('sampler.pan');

  /// Key of the pitch slider.
  static const pitchKey = Key('sampler.pitch');

  /// Key of the preview button.
  static const previewKey = Key('sampler.preview');

  /// Key of the chop button.
  static const chopKey = Key('sampler.chop');

  /// Key of the slice option [n].
  static Key slicesKey(int n) => Key('sampler.slices.$n');

  /// Height of the waveform.
  static const double waveHeight = 120;

  /// The project.
  final UuidValue projectId;

  /// The channel being edited.
  final UuidValue channelId;

  @override
  ConsumerState<SamplerDialog> createState() => _SamplerDialogState();
}

class _SamplerDialogState extends ConsumerState<SamplerDialog> {
  int _slices = 4;
  bool _draggingStart = true;

  StudioViewModel get _vm =>
      ref.read(studioViewModelProvider(widget.projectId).notifier);

  void _commit() => _vm.commitChannel(widget.channelId);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studioViewModelProvider(widget.projectId)).value;
    final channel = state?.channels
        .where((c) => c.id == widget.channelId)
        .firstOrNull;
    if (state == null || channel == null) {
      return const SizedBox.shrink();
    }
    final canEdit = state.canEdit;
    final sample = state.sampleById(channel.sampleId);
    final List<double>? peaks = sample != null
        ? sample.peaks
        : ref.watch(builtinPeaksProvider(channel.sample!)).value;
    final styles = context.textStyles;
    final colors = context.colors;
    final daw = context.dawColors;

    return Dialog(
      backgroundColor: colors.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'SAMPLER',
                style: styles.eyebrow.copyWith(color: colors.primary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(channel.name, style: styles.headline),
              Text(
                sample == null
                    ? 'Built-in drum'
                    : '${sample.name} · ${sample.format.name.toUpperCase()}',
                style: styles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              _TrimArea(
                peaks: peaks,
                startFrac: channel.startFrac,
                endFrac: channel.endFrac,
                color: daw.waveStart,
                regionColor: colors.primary,
                dimColor: colors.onSurfaceVariant.withValues(alpha: 0.3),
                handleColor: daw.record,
                enabled: canEdit,
                onDragStart: (frac) => _draggingStart =
                    (frac - channel.startFrac).abs() <=
                    (frac - channel.endFrac).abs(),
                onDrag: (frac) => _vm.setSamplerSettings(
                  widget.channelId,
                  startFrac: _draggingStart ? frac : null,
                  endFrac: _draggingStart ? null : frac,
                ),
                onDragEnd: _commit,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                canEdit
                    ? 'DRAG THE RED HANDLES TO TRIM · '
                          '${(channel.startFrac * 100).round()}%–'
                          '${(channel.endFrac * 100).round()}%'
                    : 'READ ONLY',
                style: styles.eyebrow.copyWith(fontSize: 9),
              ),
              const SizedBox(height: AppSpacing.md),
              _LabeledSlider(
                key: SamplerDialog.volumeKey,
                label: 'VOLUME',
                value: channel.volume,
                min: 0,
                max: 1,
                display: '${(channel.volume * 100).round()}%',
                onChanged: canEdit
                    ? (v) => _vm.setSamplerSettings(widget.channelId, volume: v)
                    : null,
                onChangeEnd: _commit,
              ),
              _LabeledSlider(
                key: SamplerDialog.panKey,
                label: 'PAN',
                value: channel.pan,
                min: -1,
                max: 1,
                display: channel.pan.abs() < 0.01
                    ? 'C'
                    : '${(channel.pan.abs() * 100).round()}${channel.pan < 0 ? 'L' : 'R'}',
                onChanged: canEdit
                    ? (v) => _vm.setSamplerSettings(widget.channelId, pan: v)
                    : null,
                onChangeEnd: _commit,
              ),
              _LabeledSlider(
                key: SamplerDialog.pitchKey,
                label: 'PITCH',
                value: channel.pitch.toDouble(),
                min: -ValidationRules.samplerPitchRange.toDouble(),
                max: ValidationRules.samplerPitchRange.toDouble(),
                divisions: ValidationRules.samplerPitchRange * 2,
                display: '${channel.pitch > 0 ? '+' : ''}${channel.pitch} st',
                onChanged: canEdit
                    ? (v) => _vm.setSamplerSettings(
                        widget.channelId,
                        pitch: v.round(),
                      )
                    : null,
                onChangeEnd: _commit,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: DawButton(
                      key: SamplerDialog.previewKey,
                      label: 'Preview',
                      icon: Icons.play_arrow_rounded,
                      variant: DawButtonVariant.ghost,
                      onPressed: () => _vm.preview(widget.channelId),
                    ),
                  ),
                  if (canEdit) ...[
                    Text('CHOP INTO', style: styles.eyebrow),
                    DawSegmentedControl<int>(
                      expand: false,
                      dense: true,
                      selected: _slices,
                      onChanged: (n) => setState(() => _slices = n),
                      segments: [
                        for (final n in ValidationRules.chopSlices)
                          DawSegment(
                            key: SamplerDialog.slicesKey(n),
                            value: n,
                            label: '$n',
                          ),
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: DawButton(
                        key: SamplerDialog.chopKey,
                        label: 'Chop',
                        icon: Icons.content_cut_rounded,
                        onPressed: () async {
                          await _vm.chopChannel(widget.channelId, _slices);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Chopping adds one channel per slice of the trimmed region.',
                style: styles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Waveform with the region highlighted and two draggable trim handles.
class _TrimArea extends StatelessWidget {
  const _TrimArea({
    required this.peaks,
    required this.startFrac,
    required this.endFrac,
    required this.color,
    required this.regionColor,
    required this.dimColor,
    required this.handleColor,
    required this.enabled,
    required this.onDragStart,
    required this.onDrag,
    required this.onDragEnd,
  });

  final List<double>? peaks;
  final double startFrac;
  final double endFrac;
  final Color color;
  final Color regionColor;
  final Color dimColor;
  final Color handleColor;
  final bool enabled;
  final ValueChanged<double> onDragStart;
  final ValueChanged<double> onDrag;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        double fracAt(double dx) => (dx / width).clamp(0.0, 1.0);
        return GestureDetector(
          key: SamplerDialog.waveKey,
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: enabled
              ? (d) => onDragStart(fracAt(d.localPosition.dx))
              : null,
          onHorizontalDragUpdate: enabled
              ? (d) => onDrag(fracAt(d.localPosition.dx))
              : null,
          onHorizontalDragEnd: enabled ? (_) => onDragEnd() : null,
          child: Container(
            height: SamplerDialog.waveHeight,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLowest,
              borderRadius: AppRadii.mdAll,
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: peaks == null
                      ? Center(
                          child: Text(
                            'No waveform preview for this format',
                            style: context.textStyles.bodySmall,
                          ),
                        )
                      : CustomPaint(
                          painter: WaveformPainter(
                            peaks: peaks!,
                            color: dimColor,
                          ),
                        ),
                ),
                // Lit region.
                Positioned(
                  left: width * startFrac,
                  width: width * (endFrac - startFrac),
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: regionColor.withValues(alpha: 0.12),
                    child: peaks == null
                        ? null
                        : CustomPaint(
                            painter: WaveformPainter(
                              peaks: peaks!,
                              color: color,
                              from: startFrac,
                              to: endFrac,
                            ),
                          ),
                  ),
                ),
                for (final frac in [startFrac, endFrac])
                  Positioned(
                    left: (width * frac - 1.5).clamp(0, width - 3),
                    top: 0,
                    bottom: 0,
                    width: 3,
                    child: Container(color: handleColor),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.display,
    required this.onChanged,
    required this.onChangeEnd,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String display;
  final ValueChanged<double>? onChanged;
  final VoidCallback onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Row(
      children: [
        SizedBox(width: 64, child: Text(label, style: styles.eyebrow)),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            onChangeEnd: onChanged == null ? null : (_) => onChangeEnd(),
          ),
        ),
        SizedBox(
          width: 56,
          child: Text(display, textAlign: TextAlign.end, style: styles.mono),
        ),
      ],
    );
  }
}
