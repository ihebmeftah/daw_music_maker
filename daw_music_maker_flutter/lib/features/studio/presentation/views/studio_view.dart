import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/dialogs/confirm_dialog.dart';
import '../../../../shared/widgets/feedback/empty_state.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/feedback/error_view.dart';
import '../../../../shared/widgets/feedback/loading_view.dart';
import '../../../../shared/widgets/inputs/daw_segmented_control.dart';
import '../state/studio_state.dart';
import '../view_models/studio_view_model.dart';
import '../widgets/browser_item.dart';
import '../widgets/channel_rack.dart';
import '../widgets/sample_browser.dart';
import '../widgets/sampler_dialog.dart';
import '../widgets/pattern_name_dialog.dart';
import '../widgets/pattern_selector.dart';
import '../widgets/piano_roll.dart';
import '../widgets/playback_timeline.dart';
import '../widgets/playlist_view.dart';
import '../widgets/timeline_wave.dart';
import '../widgets/transport_toolbar.dart';

/// `/projects/:id/studio` — full-screen studio (no app bar): the transport
/// toolbar, the playback timeline and the workspace.
///
/// Keyboard: Space plays/pauses, ↑/↓ nudge the tempo, M mutes the clicks.
class StudioView extends ConsumerWidget {
  /// Creates the studio for [projectId].
  const StudioView({super.key, required this.projectId});

  /// Key of the channel rack tab.
  static const rackTabKey = Key('studio.tab.rack');

  /// Key of the piano roll tab.
  static const pianoTabKey = Key('studio.tab.piano');

  /// Width below which the timeline moves under the toolbar.
  static const double sideBySideMinWidth = 900;

  /// Key of the playlist tab.
  static const playlistTabKey = Key('studio.tab.playlist');

  /// Key of the back button shown while loading or on errors.
  static const fallbackBackKey = Key('studio.fallbackBack');

  /// The project.
  final UuidValue projectId;

  void _back(BuildContext context) =>
      ProjectDetailRoute(id: projectId.toString()).go(context);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = studioViewModelProvider(projectId);
    return Scaffold(
      body: SafeArea(
        child: switch (ref.watch(provider)) {
          AsyncData(:final value) => _Studio(
            projectId: projectId,
            state: value,
            onBack: () => _back(context),
          ),
          AsyncError(:final error) => _Fallback(
            onBack: () => _back(context),
            child: ErrorView(
              error: error,
              onRetry: () => ref.invalidate(provider),
            ),
          ),
          _ => _Fallback(
            onBack: () => _back(context),
            child: const LoadingView(),
          ),
        },
      ),
    );
  }
}

/// Loading / error content with a back arrow, since there is no app bar.
class _Fallback extends StatelessWidget {
  const _Fallback({required this.onBack, required this.child});

  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: IconButton(
            key: StudioView.fallbackBackKey,
            tooltip: 'Back to project',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
      ],
    );
  }
}

class _Studio extends ConsumerStatefulWidget {
  const _Studio({
    required this.projectId,
    required this.state,
    required this.onBack,
  });

  final UuidValue projectId;
  final StudioState state;
  final VoidCallback onBack;

  @override
  ConsumerState<_Studio> createState() => _StudioState();
}

class _StudioState extends ConsumerState<_Studio> {
  @override
  void initState() {
    super.initState();
    // A keyboard-level handler (not a Focus node) so shortcuts keep working
    // wherever focus is inside the studio, e.g. after clicking empty space
    // or closing a menu.
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent || !mounted) return false;
    // Not while a dialog is on top or the user types in a text field.
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return false;
    if (FocusManager.instance.primaryFocus?.context?.widget is EditableText) {
      return false;
    }
    final vm = ref.read(studioViewModelProvider(widget.projectId).notifier);
    final canEdit = widget.state.canEdit;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.space) {
      vm.togglePlay();
    } else if (key == LogicalKeyboardKey.keyM) {
      vm.toggleMute();
    } else if (key == LogicalKeyboardKey.keyL) {
      vm.toggleMode();
    } else if (key == LogicalKeyboardKey.bracketLeft) {
      vm.stepPattern(-1);
    } else if (key == LogicalKeyboardKey.bracketRight) {
      vm.stepPattern(1);
    } else if (key == LogicalKeyboardKey.arrowUp && canEdit) {
      vm.nudge(1);
    } else if (key == LogicalKeyboardKey.arrowDown && canEdit) {
      vm.nudge(-1);
    } else {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(studioViewModelProvider(widget.projectId).notifier);
    final state = widget.state;
    return _AudioDropZone(
      enabled: state.canEdit,
      onFiles: vm.uploadFiles,
      child: _body(context, vm, state),
    );
  }

  Widget _body(BuildContext context, StudioViewModel vm, StudioState state) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Transport toolbar and timeline share one row (≈70% / 30%);
          // on narrow screens the timeline goes below the toolbar.
          StaggeredReveal(
            index: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final toolbar = TransportToolbar(
                  state: state,
                  beat: vm.beat,
                  onBack: widget.onBack,
                  onTogglePlay: vm.togglePlay,
                  onToggleMute: vm.toggleMute,
                  onAdjust: vm.adjust,
                  onCommit: vm.save,
                  onNudge: vm.nudge,
                  onTap: vm.tap,
                  onSubmitted: (bpm) {
                    vm.setBpm(bpm);
                    vm.save();
                  },
                  onSetMode: vm.setMode,
                  patternActions: PatternActions(
                    onSelect: vm.selectPattern,
                    onStep: vm.stepPattern,
                    onCreate: vm.createPattern,
                    onClone: vm.cloneSelectedPattern,
                    onRename: () async {
                      final name = await showPatternNameDialog(
                        context,
                        initial: state.selectedPattern?.name ?? '',
                      );
                      if (name != null) await vm.renameSelectedPattern(name);
                    },
                    onColor: vm.setSelectedPatternColor,
                    onLength: vm.setSelectedPatternLength,
                    onDelete: vm.deleteSelectedPattern,
                  ),
                );
                final timeline = PlaybackTimeline(
                  position: vm.position,
                  isPlaying: state.isPlaying,
                  hits: timelineHits(state),
                  bars: state.loopBars,
                  title: state.mode == TransportMode.song
                      ? 'SONG'
                      : state.selectedPattern?.name.toUpperCase() ?? 'TIMELINE',
                );
                if (constraints.maxWidth < StudioView.sideBySideMinWidth) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      toolbar,
                      const SizedBox(height: AppSpacing.sm),
                      timeline,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: toolbar),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(flex: 3, child: timeline),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ErrorBanner(message: state.failure?.message),
          Text(
            'SPACE PLAY/PAUSE · L PAT/SONG · M MUTE · [ ] PATTERN · ↑ ↓ NUDGE · '
            'HOLD THE BPM AND SCROLL',
            style: context.textStyles.eyebrow.copyWith(fontSize: 10),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: StaggeredReveal(
              index: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SampleBrowser(
                    samples: state.samples,
                    uploads: state.uploads,
                    canEdit: state.canEdit,
                    actions: SampleBrowserActions(
                      onUpload: () => _pickAndUpload(vm),
                      onPreview: (item) => vm.previewSound(
                        kind: item.kind,
                        sampleId: item.sampleId,
                      ),
                      onOpen: (item) => _openFromBrowser(context, vm, item),
                      onDelete: (id) => _confirmDeleteSample(context, vm, id),
                      onDismissUpload: vm.dismissUpload,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _Workspace(
                      state: state,
                      vm: vm,
                      onOpenSampler: (id) => showSamplerDialog(
                        context,
                        projectId: widget.projectId,
                        channelId: id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the system file picker for audio files and uploads them.
  Future<void> _pickAndUpload(StudioViewModel vm) async {
    final files = await FilePicker.pickFiles(
      dialogTitle: 'Upload audio',
      type: FileType.custom,
      allowedExtensions: const ['wav', 'mp3', 'ogg', 'flac'],
    );
    if (files.isEmpty) return;
    await vm.uploadFiles([
      for (final f in files) (name: f.name, bytes: await f.xFile.readAsBytes()),
    ]);
  }

  /// Double-click in the browser: add the sound as a channel, open its
  /// sampler.
  Future<void> _openFromBrowser(
    BuildContext context,
    StudioViewModel vm,
    BrowserItem item,
  ) async {
    final id = await vm.addChannelFor(kind: item.kind, sampleId: item.sampleId);
    if (id != null && context.mounted) {
      await showSamplerDialog(
        context,
        projectId: widget.projectId,
        channelId: id,
      );
    }
  }

  Future<void> _confirmDeleteSample(
    BuildContext context,
    StudioViewModel vm,
    UuidValue sampleId,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete sample?',
      message:
          'Channels and playlist clips using it are removed too. This cannot '
          'be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (confirmed) await vm.deleteSample(sampleId);
  }
}

/// The workspace below the timeline: channel rack or piano roll.
class _Workspace extends StatelessWidget {
  const _Workspace({
    required this.state,
    required this.vm,
    required this.onOpenSampler,
  });

  final StudioState state;
  final StudioViewModel vm;
  final ValueChanged<UuidValue> onOpenSampler;

  @override
  Widget build(BuildContext context) {
    final channel = state.selectedChannel;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.dawColors.panel,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: context.dawColors.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Labeled tabs when there is room, icon-only (with tooltips)
          // when the workspace is narrow.
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 640;
              DawSegment<StudioWorkspace> tab(
                Key key,
                StudioWorkspace value,
                String label,
                IconData icon,
              ) => DawSegment(
                key: key,
                value: value,
                label: compact ? '' : label,
                icon: icon,
                tooltip: label,
              );
              return Align(
                alignment: Alignment.centerLeft,
                child: DawSegmentedControl<StudioWorkspace>(
                  expand: false,
                  selected: state.workspace,
                  onChanged: vm.setWorkspace,
                  segments: [
                    tab(
                      StudioView.rackTabKey,
                      StudioWorkspace.channelRack,
                      'Channel rack',
                      Icons.view_week_rounded,
                    ),
                    tab(
                      StudioView.pianoTabKey,
                      StudioWorkspace.pianoRoll,
                      'Piano roll',
                      Icons.piano_rounded,
                    ),
                    tab(
                      StudioView.playlistTabKey,
                      StudioWorkspace.playlist,
                      'Playlist',
                      Icons.view_timeline_rounded,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child:
                !state.notesLoaded &&
                    state.workspace != StudioWorkspace.playlist
                ? const LoadingView()
                : switch (state.workspace) {
                    StudioWorkspace.playlist => PlaylistView(
                      clips: state.clips,
                      patterns: state.patterns,
                      selectedPattern: state.selectedPattern,
                      songBars: state.songBars,
                      canEdit: state.canEdit,
                      isSongMode: state.mode == TransportMode.song,
                      playhead: vm.playhead,
                      onToggleCell: vm.togglePlaylistCell,
                      onPickClip: vm.selectClipPattern,
                      samples: state.samples,
                      onDropSample: vm.placeSampleClip,
                      snap: state.playlistSnap,
                      onSnapChanged: vm.setPlaylistSnap,
                    ),
                    StudioWorkspace.channelRack => ChannelRack(
                      channels: state.channels,
                      notes: state.currentNotes,
                      steps: state.patternSteps,
                      selectedChannelId: channel?.id,
                      canEdit: state.canEdit,
                      playhead: vm.playhead,
                      actions: ChannelRackActions(
                        onToggleStep: vm.toggleStep,
                        onSelect: (id) {
                          vm.selectChannel(id);
                          vm.preview(id);
                        },
                        onOpenPianoRoll: vm.openPianoRoll,
                        onToggleMute: vm.toggleChannelMute,
                        onVolume: vm.setChannelVolume,
                        onVolumeEnd: vm.commitChannelVolume,
                        onAdd: vm.addChannel,
                        onDelete: vm.deleteChannel,
                        onOpenSampler: onOpenSampler,
                        onDropItem: (item) => vm.addChannelFor(
                          kind: item.kind,
                          sampleId: item.sampleId,
                        ),
                      ),
                    ),
                    StudioWorkspace.pianoRoll =>
                      channel == null
                          ? const EmptyState(
                              icon: Icons.piano_rounded,
                              title: 'No channel',
                              message: 'Add a channel in the channel rack.',
                            )
                          : PianoRoll(
                              channels: state.channels,
                              channel: channel,
                              notes: [
                                for (final n in state.currentNotes)
                                  if (n.channelId == channel.id) n,
                              ],
                              steps: state.patternSteps,
                              canEdit: state.canEdit,
                              playhead: vm.playhead,
                              onToggleNote: vm.togglePianoNote,
                              onPreview: (pitch) =>
                                  vm.preview(channel.id, pitch: pitch),
                              onSelectChannel: vm.selectChannel,
                              snap: state.pianoRollSnap,
                              onSnapChanged: vm.setPianoRollSnap,
                            ),
                  },
          ),
        ],
      ),
    );
  }
}

/// Accepts audio files dropped from the desktop / file manager anywhere on
/// the studio and uploads them; shows an overlay while files hover.
class _AudioDropZone extends StatefulWidget {
  const _AudioDropZone({
    required this.enabled,
    required this.onFiles,
    required this.child,
  });

  final bool enabled;
  final Future<void> Function(List<({String name, Uint8List bytes})> files)
  onFiles;
  final Widget child;

  @override
  State<_AudioDropZone> createState() => _AudioDropZoneState();
}

class _AudioDropZoneState extends State<_AudioDropZone> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: widget.enabled,
      onDragEntered: (_) => setState(() => _hovering = true),
      onDragExited: (_) => setState(() => _hovering = false),
      onDragDone: (details) async {
        setState(() => _hovering = false);
        await widget.onFiles([
          for (final file in details.files)
            (name: file.name, bytes: await file.readAsBytes()),
        ]);
      },
      child: Stack(
        children: [
          widget.child,
          if (_hovering)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.12),
                    borderRadius: AppRadii.lgAll,
                    border: Border.all(color: context.colors.primary, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'DROP AUDIO FILES TO UPLOAD · WAV MP3 OGG FLAC · MAX 10 MB',
                    style: context.textStyles.eyebrow.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
