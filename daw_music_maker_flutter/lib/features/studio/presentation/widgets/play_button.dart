import 'package:flutter/material.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';

/// The big round transport button: play when stopped, pause when playing.
class PlayButton extends StatelessWidget {
  /// Creates the button.
  const PlayButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
    this.size = AppSpacing.xxxl + AppSpacing.lg,
  });

  /// Diameter in logical pixels (the toolbar uses a compact size).
  final double size;

  /// Whether the metronome is playing.
  final bool isPlaying;

  /// Toggles playback.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final daw = context.dawColors;
    return Tooltip(
      message: isPlaying ? 'Pause (Space)' : 'Play (Space)',
      child: Semantics(
        button: true,
        label: isPlaying ? 'Pause metronome' : 'Play metronome',
        child: GestureDetector(
          onTap: onPressed,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: AppDurations.medium,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isPlaying
                      ? [daw.waveEnd, daw.record]
                      : [daw.waveStart, daw.waveEnd],
                ),
                boxShadow: [
                  BoxShadow(
                    color: daw.cursorGlow,
                    blurRadius: isPlaying ? size * 0.55 : size * 0.3,
                    spreadRadius: isPlaying ? size * 0.06 : 0,
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: AppDurations.medium,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(isPlaying),
                  size: size * 0.55,
                  color: context.colors.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
