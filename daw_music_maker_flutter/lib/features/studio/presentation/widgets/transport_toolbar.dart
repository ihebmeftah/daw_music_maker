import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/buttons/theme_mode_toggle.dart';
import '../../../../shared/widgets/feedback/equalizer_loader.dart';
import '../../../../shared/widgets/inputs/daw_segmented_control.dart';
import '../state/studio_state.dart';
import 'beat_lights.dart';
import 'bpm_display.dart';
import 'pattern_selector.dart';
import 'play_button.dart';

/// Style shared by every icon button of the studio toolbar: a fixed
/// [AppSpacing.toolbarControl] square, so all controls line up.
ButtonStyle toolbarIconStyle() => IconButton.styleFrom(
  fixedSize: const Size.square(AppSpacing.toolbarControl),
  minimumSize: const Size.square(AppSpacing.toolbarControl),
  maximumSize: const Size.square(AppSpacing.toolbarControl),
  padding: EdgeInsets.zero,
  iconSize: 20,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

/// DAW-style transport bar (the studio has no app bar): back to the
/// project, play/pause, metronome sound on/off, the tempo LCD with nudge
/// arrows, beat LEDs, tap tempo, the save status and the theme toggle.
///
/// Controls wrap onto extra lines when space runs out (nothing is hidden);
/// the status chip and theme toggle stay pinned (below the controls on
/// phones).
class TransportToolbar extends StatelessWidget {
  /// Creates the toolbar.
  const TransportToolbar({
    super.key,
    required this.state,
    required this.beat,
    required this.onBack,
    required this.onTogglePlay,
    required this.onToggleMute,
    required this.onAdjust,
    required this.onCommit,
    required this.onNudge,
    required this.onTap,
    required this.onSubmitted,
    required this.patternActions,
    required this.onSetMode,
  });

  /// Key of the PAT segment.
  static const patModeKey = Key('studio.mode.pattern');

  /// Key of the SONG segment.
  static const songModeKey = Key('studio.mode.song');

  /// PAT / SONG switch.
  final ValueChanged<TransportMode> onSetMode;

  /// Pattern selector callbacks.
  final PatternActions patternActions;

  /// Key of the "back to project" button.
  static const backKey = Key('studio.back');

  /// Key of the metronome sound toggle.
  static const muteKey = Key('studio.mute');

  /// Key of the play/pause button.
  static const playKey = Key('studio.play');

  /// Key of the +1 arrow.
  static const upKey = Key('studio.up');

  /// Key of the −1 arrow.
  static const downKey = Key('studio.down');

  /// Key of the tap tempo button.
  static const tapKey = Key('studio.tap');

  /// Studio state.
  final StudioState state;

  /// Current beat (null when stopped).
  final ValueListenable<int?> beat;

  /// Back to the project page.
  final VoidCallback onBack;

  /// Play / pause.
  final VoidCallback onTogglePlay;

  /// Metronome sound on / off.
  final VoidCallback onToggleMute;

  /// Live tempo change (hold + scroll / drag).
  final ValueChanged<double> onAdjust;

  /// Persist after adjusting.
  final VoidCallback onCommit;

  /// ±1 arrows.
  final ValueChanged<double> onNudge;

  /// Tap tempo.
  final VoidCallback onTap;

  /// Exact value typed.
  final ValueChanged<double> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final enabled = state.canEdit;
    final items = <Widget>[
      _BackToProject(name: state.project.name, onBack: onBack),
      const _Divider(),
      PlayButton(
        key: playKey,
        size: AppSpacing.toolbarControl,
        isPlaying: state.isPlaying,
        onPressed: onTogglePlay,
      ),
      const SizedBox(width: AppSpacing.xs),
      _SoundToggle(muted: state.isMuted, onToggle: onToggleMute),
      const SizedBox(width: AppSpacing.xs),
      Tooltip(
        message: 'Pattern / song mode (L)',
        child: DawSegmentedControl<TransportMode>(
          expand: false,
          dense: true,
          selected: state.mode,
          onChanged: onSetMode,
          segments: const [
            DawSegment(
              key: patModeKey,
              value: TransportMode.pattern,
              label: '',
              icon: Icons.grid_view_rounded,
              tooltip: 'Pattern mode: loop the selected pattern',
            ),
            DawSegment(
              key: songModeKey,
              value: TransportMode.song,
              label: '',
              icon: Icons.view_timeline_rounded,
              tooltip: 'Song mode: play the playlist',
            ),
          ],
        ),
      ),
      const _Divider(),
      PatternSelector(
        patterns: state.patterns,
        selected: state.selectedPattern,
        canEdit: state.canEdit,
        isBusy: state.isPatternBusy,
        actions: patternActions,
      ),
      const _Divider(),
      BpmDisplay(
        bpm: state.bpm,
        enabled: enabled,
        onAdjust: onAdjust,
        onCommit: onCommit,
        onSubmitted: onSubmitted,
      ),
      const SizedBox(width: AppSpacing.xs),
      _NudgeArrows(enabled: enabled, onNudge: onNudge),
      const _Divider(),
      BeatLights(beat: beat, compact: true),
      const _Divider(),
      _TapButton(enabled: enabled, onTap: onTap),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.smd,
      ),
      decoration: BoxDecoration(
        color: context.dawColors.panel,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: context.dawColors.panelBorder),
        boxShadow: [
          BoxShadow(
            color: context.dawColors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Controls wrap onto another line when they don't fit, so every
          // control stays visible; the status and theme toggle stay pinned.
          final controls = Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: AppSpacing.sm,
            children: items,
          );
          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                Expanded(child: controls),
                const SizedBox(width: AppSpacing.sm),
                SaveStatusChip(state: state),
                const SizedBox(width: AppSpacing.xs),
                const ThemeModeToggle(),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controls,
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  SaveStatusChip(state: state),
                  const Spacer(),
                  const ThemeModeToggle(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: AppSpacing.lg,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      color: context.colors.outlineVariant,
    );
  }
}

class _NudgeArrows extends StatelessWidget {
  const _NudgeArrows({required this.enabled, required this.onNudge});

  final bool enabled;
  final ValueChanged<double> onNudge;

  @override
  Widget build(BuildContext context) {
    // Two half-height arrows stacked = one toolbar control.
    const constraints = BoxConstraints.tightFor(
      width: AppSpacing.lg,
      height: AppSpacing.toolbarControl / 2,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: TransportToolbar.upKey,
          tooltip: '+1 BPM (↑)',
          constraints: constraints,
          padding: EdgeInsets.zero,
          iconSize: 18,
          onPressed: enabled ? () => onNudge(1) : null,
          icon: const Icon(Icons.keyboard_arrow_up_rounded),
        ),
        IconButton(
          key: TransportToolbar.downKey,
          tooltip: '−1 BPM (↓)',
          constraints: constraints,
          padding: EdgeInsets.zero,
          iconSize: 18,
          onPressed: enabled ? () => onNudge(-1) : null,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ],
    );
  }
}

class _TapButton extends StatelessWidget {
  const _TapButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      key: TransportToolbar.tapKey,
      style: toolbarIconStyle(),
      tooltip: 'Tap tempo',
      onPressed: enabled ? onTap : null,
      icon: const Icon(Icons.touch_app_outlined),
    );
  }
}

/// Speaker toggle: selected (sound on) or not (muted).
class _SoundToggle extends StatelessWidget {
  const _SoundToggle({required this.muted, required this.onToggle});

  final bool muted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      key: TransportToolbar.muteKey,
      style: toolbarIconStyle().copyWith(
        shape: const WidgetStatePropertyAll(CircleBorder()),
      ),
      isSelected: !muted,
      tooltip: muted ? 'Unmute metronome (M)' : 'Mute metronome (M)',
      onPressed: onToggle,
      icon: Icon(Icons.volume_off_rounded, color: context.colors.error),
      selectedIcon: const Icon(Icons.volume_up_rounded),
    );
  }
}

/// Back arrow + project name, returning to the project page.
class _BackToProject extends StatelessWidget {
  const _BackToProject({required this.name, required this.onBack});

  final String name;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: TransportToolbar.backKey,
          style: toolbarIconStyle(),
          tooltip: 'Back to project',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: AppSpacing.xs),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.title,
          ),
        ),
      ],
    );
  }
}

/// "SAVED" / saving equalizer / "UNSAVED" / "READ ONLY" chip.
class SaveStatusChip extends StatelessWidget {
  /// Creates the chip for [state].
  const SaveStatusChip({super.key, required this.state});

  /// Studio state.
  final StudioState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final daw = context.dawColors;
    final (label, color) = !state.canEdit
        ? ('READ ONLY', colors.onSurfaceVariant)
        : state.isSaving
        ? ('SAVING', colors.primary)
        : state.isDirty
        ? ('UNSAVED', colors.error)
        : ('SAVED', daw.meterLow);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs + 1,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.isSaving) ...[
            EqualizerLoader(color: color, bars: 3, height: 10),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: context.textStyles.eyebrow.copyWith(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
