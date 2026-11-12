import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/audio/metronome.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../data/studio_note.dart';
import 'browser_item.dart';

/// Display name of a built-in sample.
String sampleLabel(SampleKind sample) => switch (sample) {
  SampleKind.kick => 'Kick',
  SampleKind.snare => 'Snare',
  SampleKind.closedHat => 'Closed hat',
  SampleKind.openHat => 'Open hat',
};

/// Callbacks of the [ChannelRack].
class ChannelRackActions {
  /// Creates the callbacks.
  const ChannelRackActions({
    required this.onToggleStep,
    required this.onSelect,
    required this.onOpenPianoRoll,
    required this.onToggleMute,
    required this.onVolume,
    required this.onVolumeEnd,
    required this.onAdd,
    required this.onDelete,
    required this.onOpenSampler,
    required this.onDropItem,
  });

  /// Open a channel's sampler (double-click on its name).
  final ValueChanged<UuidValue> onOpenSampler;

  /// A browser item was dropped on the rack (add a channel for it).
  final ValueChanged<BrowserItem> onDropItem;

  /// Toggle a step of a channel.
  final void Function(UuidValue channelId, int step) onToggleStep;

  /// Select a channel (and preview it).
  final ValueChanged<UuidValue> onSelect;

  /// Open a channel in the piano roll.
  final ValueChanged<UuidValue> onOpenPianoRoll;

  /// Mute / unmute a channel.
  final ValueChanged<UuidValue> onToggleMute;

  /// Volume while dragging.
  final void Function(UuidValue channelId, double volume) onVolume;

  /// Volume drag ended (save).
  final ValueChanged<UuidValue> onVolumeEnd;

  /// Add a channel playing a sample.
  final ValueChanged<SampleKind> onAdd;

  /// Delete a channel.
  final ValueChanged<UuidValue> onDelete;
}

/// FL Studio–style channel rack: one row per channel (mute LED, volume,
/// name) followed by its step-sequencer steps for the current pattern. Steps
/// are shaded per beat; the playhead column lights up while playing.
class ChannelRack extends StatelessWidget {
  /// Creates the rack.
  const ChannelRack({
    super.key,
    required this.channels,
    required this.notes,
    required this.steps,
    required this.selectedChannelId,
    required this.canEdit,
    required this.playhead,
    required this.actions,
  });

  /// Key of the "add channel" menu.
  static const addKey = Key('rack.add');

  /// Key of the step [step] of [channelId].
  static Key stepKey(UuidValue channelId, int step) =>
      Key('rack.step.$channelId.$step');

  /// Key of the name button of [channelId].
  static Key channelKey(UuidValue channelId) => Key('rack.channel.$channelId');

  /// Key of the mute LED of [channelId].
  static Key muteKey(UuidValue channelId) => Key('rack.mute.$channelId');

  /// Key of the channel menu of [channelId].
  static Key menuKey(UuidValue channelId) => Key('rack.menu.$channelId');

  /// Width of one step button.
  static const double stepWidth = 26;

  /// Channels in rack order.
  final List<ChannelResponse> channels;

  /// Notes of the current pattern.
  final List<StudioNote> notes;

  /// Steps in the current pattern.
  final int steps;

  /// Channel highlighted (shown in the piano roll).
  final UuidValue? selectedChannelId;

  /// Whether the user may edit.
  final bool canEdit;

  /// Absolute transport step (null when stopped).
  final ValueListenable<int?> playhead;

  /// Callbacks.
  final ChannelRackActions actions;

  @override
  Widget build(BuildContext context) {
    // Steps that are on, per channel.
    final onSteps = <UuidValue, Set<int>>{};
    for (final n in notes) {
      (onSteps[n.channelId] ??= {}).add(n.step);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'CHANNEL RACK',
              style: context.textStyles.eyebrow.copyWith(
                color: context.colors.primary,
              ),
            ),
            const Spacer(),
            if (canEdit)
              PopupMenuButton<SampleKind>(
                key: addKey,
                tooltip: 'Add channel',
                onSelected: actions.onAdd,
                itemBuilder: (_) => [
                  for (final s in SampleKind.values)
                    PopupMenuItem(value: s, child: Text(sampleLabel(s))),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: context.colors.primary),
                      Text(
                        'CHANNEL',
                        style: context.textStyles.eyebrow.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: DragTarget<BrowserItem>(
            onWillAcceptWithDetails: (_) => canEdit,
            onAcceptWithDetails: (d) => actions.onDropItem(d.data),
            builder: (context, candidates, _) => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadii.mdAll,
                border: Border.all(
                  color: candidates.isEmpty
                      ? context.colors.surface.withValues(alpha: 0)
                      : context.colors.primary,
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ValueListenableBuilder<int?>(
                    valueListenable: playhead,
                    builder: (context, step, _) {
                      final current = step == null ? null : step % steps;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final (i, c) in channels.indexed)
                            _ChannelRow(
                              channel: c,
                              colorIndex: i,
                              steps: steps,
                              onSteps: onSteps[c.id] ?? const {},
                              selected: c.id == selectedChannelId,
                              canEdit: canEdit,
                              playheadStep: current,
                              actions: actions,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({
    required this.channel,
    required this.colorIndex,
    required this.steps,
    required this.onSteps,
    required this.selected,
    required this.canEdit,
    required this.playheadStep,
    required this.actions,
  });

  final ChannelResponse channel;
  final int colorIndex;
  final int steps;
  final Set<int> onSteps;
  final bool selected;
  final bool canEdit;
  final int? playheadStep;
  final ChannelRackActions actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = context.dawColors.trackColor(colorIndex);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs + 2),
      child: Row(
        children: [
          _MuteLed(
            key: ChannelRack.muteKey(channel.id),
            muted: channel.muted,
            onTap: canEdit ? () => actions.onToggleMute(channel.id) : null,
          ),
          SizedBox(
            width: 84,
            child: Slider(
              value: channel.volume,
              onChanged: canEdit
                  ? (v) => actions.onVolume(channel.id, v)
                  : null,
              onChangeEnd: canEdit
                  ? (_) => actions.onVolumeEnd(channel.id)
                  : null,
            ),
          ),
          _ChannelButton(
            key: ChannelRack.channelKey(channel.id),
            name: channel.name,
            color: color,
            selected: selected,
            uploaded: channel.sampleId != null,
            onTap: () => actions.onSelect(channel.id),
            onDoubleTap: () => actions.onOpenSampler(channel.id),
          ),
          PopupMenuButton<String>(
            key: ChannelRack.menuKey(channel.id),
            tooltip: 'Channel options',
            icon: Icon(Icons.more_vert_rounded, color: colors.onSurfaceVariant),
            onSelected: (value) => switch (value) {
              'sampler' => actions.onOpenSampler(channel.id),
              'piano' => actions.onOpenPianoRoll(channel.id),
              'delete' => actions.onDelete(channel.id),
              _ => null,
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'sampler',
                child: Text('Open sampler'),
              ),
              const PopupMenuItem(
                value: 'piano',
                child: Text('Open in piano roll'),
              ),
              if (canEdit)
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete channel'),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          for (var s = 0; s < steps; s++) ...[
            if (s > 0 && s % Metronome.stepsPerBeat == 0)
              const SizedBox(width: AppSpacing.xs),
            _StepButton(
              key: ChannelRack.stepKey(channel.id, s),
              on: onSteps.contains(s),
              color: color,
              // Alternate shading per beat, like FL Studio's step groups.
              shaded: (s ~/ Metronome.stepsPerBeat).isOdd,
              barStart: s % ValidationRules.stepsPerBar == 0,
              playing: playheadStep == s,
              onTap: canEdit ? () => actions.onToggleStep(channel.id, s) : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _MuteLed extends StatelessWidget {
  const _MuteLed({super.key, required this.muted, required this.onTap});

  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final on = context.dawColors.meterLow;
    return Tooltip(
      message: muted ? 'Unmute channel' : 'Mute channel',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Container(
            width: AppSpacing.smd,
            height: AppSpacing.smd,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: muted ? context.colors.surfaceContainerHighest : on,
              boxShadow: [
                if (!muted)
                  BoxShadow(color: on.withValues(alpha: 0.6), blurRadius: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChannelButton extends StatelessWidget {
  const _ChannelButton({
    super.key,
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
    required this.onDoubleTap,
    this.uploaded = false,
  });

  final bool uploaded;
  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: 'Double-click to open the sampler',
      waitDuration: const Duration(milliseconds: 800),
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        borderRadius: AppRadii.smAll,
        child: Container(
          width: 120,
          height: AppSpacing.xl + 2,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.25)
                : colors.surfaceContainerHigh,
            borderRadius: AppRadii.smAll,
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              if (uploaded) ...[
                Icon(Icons.graphic_eq_rounded, size: 14, color: color),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.label,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    super.key,
    required this.on,
    required this.color,
    required this.shaded,
    required this.barStart,
    required this.playing,
    required this.onTap,
  });

  final bool on;
  final Color color;
  final bool shaded;
  final bool barStart;
  final bool playing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final off = shaded
        ? colors.surfaceContainerHighest
        : colors.surfaceContainerHigh;
    return Semantics(
      button: true,
      toggled: on,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: ChannelRack.stepWidth - 4,
          height: AppSpacing.xl + 2,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: on ? color : off,
            borderRadius: AppRadii.smAll,
            border: Border.all(
              color: playing
                  ? colors.onSurface
                  : barStart
                  ? colors.outline
                  : (on ? color : off),
              width: playing ? 2 : 1,
            ),
            boxShadow: [
              if (on && playing)
                BoxShadow(color: color.withValues(alpha: 0.7), blurRadius: 12),
            ],
          ),
        ),
      ),
    );
  }
}
