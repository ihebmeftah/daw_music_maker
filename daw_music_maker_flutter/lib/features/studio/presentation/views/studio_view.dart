import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../shared/widgets/animations/staggered_reveal.dart';
import '../../../../shared/widgets/daw/wave_cursor_background.dart';
import '../../../../shared/widgets/feedback/empty_state.dart';
import '../../../../shared/widgets/feedback/error_banner.dart';
import '../../../../shared/widgets/feedback/error_view.dart';
import '../../../../shared/widgets/feedback/loading_view.dart';
import '../state/studio_state.dart';
import '../view_models/studio_view_model.dart';
import '../widgets/playback_timeline.dart';
import '../widgets/transport_toolbar.dart';

/// `/projects/:id/studio` — full-screen studio (no app bar): the transport
/// toolbar, the playback timeline and the workspace.
///
/// Keyboard: Space plays/pauses, ↑/↓ nudge the tempo, M mutes the clicks.
class StudioView extends ConsumerWidget {
  /// Creates the studio for [projectId].
  const StudioView({super.key, required this.projectId});

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

class _Studio extends ConsumerWidget {
  const _Studio({
    required this.projectId,
    required this.state,
    required this.onBack,
  });

  final UuidValue projectId;
  final StudioState state;
  final VoidCallback onBack;

  KeyEventResult _onKey(StudioViewModel vm, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    // Don't steal keys from text fields (e.g. typing an exact BPM).
    if (FocusManager.instance.primaryFocus?.context?.widget is EditableText) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.space) {
      vm.togglePlay();
    } else if (key == LogicalKeyboardKey.keyM) {
      vm.toggleMute();
    } else if (key == LogicalKeyboardKey.arrowUp && state.canEdit) {
      vm.nudge(1);
    } else if (key == LogicalKeyboardKey.arrowDown && state.canEdit) {
      vm.nudge(-1);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(studioViewModelProvider(projectId).notifier);
    return Focus(
      autofocus: true,
      onKeyEvent: (_, event) => _onKey(vm, event),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StaggeredReveal(
              index: 0,
              child: TransportToolbar(
                state: state,
                beat: vm.beat,
                onBack: onBack,
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
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ErrorBanner(message: state.failure?.message),
            Text(
              'SPACE PLAY/PAUSE · M MUTE · ↑ ↓ NUDGE · HOLD THE BPM AND SCROLL',
              style: context.textStyles.eyebrow.copyWith(fontSize: 10),
            ),
            const SizedBox(height: AppSpacing.md),
            StaggeredReveal(
              index: 1,
              child: PlaybackTimeline(
                position: vm.position,
                isPlaying: state.isPlaying,
                isMuted: state.isMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Expanded(
              child: StaggeredReveal(index: 2, child: _Workspace()),
            ),
          ],
        ),
      ),
    );
  }
}

/// The area below the timeline where the channel rack and playlist will live.
class _Workspace extends StatelessWidget {
  const _Workspace();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.lgAll,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: context.dawColors.panelBorder),
          borderRadius: AppRadii.lgAll,
        ),
        child: const WaveCursorBackground(
          child: EmptyState(
            icon: Icons.grid_view_rounded,
            title: 'Your session starts here',
            message:
                'Set the tempo and hit play. The channel rack and playlist '
                'will land in this space.',
          ),
        ),
      ),
    );
  }
}
