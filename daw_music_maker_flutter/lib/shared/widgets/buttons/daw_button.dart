import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';
import '../feedback/equalizer_loader.dart';

/// Visual style of a [DawButton].
enum DawButtonVariant {
  /// Gradient-filled call to action with a hover glow.
  primary,

  /// Outlined, transparent secondary action.
  ghost,
}

/// The app's button: gradient fill, glow on hover/focus, press scale and an
/// equalizer loading state.
///
/// It is disabled while [isLoading] is true or [onPressed] is null.
///
/// ```dart
/// DawButton(
///   label: 'Sign in',
///   isLoading: state.isSubmitting,
///   onPressed: _submit,
/// )
/// ```
class DawButton extends StatefulWidget {
  /// Creates a button.
  const DawButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = DawButtonVariant.primary,
  });

  /// Button text.
  final String label;

  /// Called when tapped or activated with the keyboard.
  final VoidCallback? onPressed;

  /// Shows the loader and disables the button.
  final bool isLoading;

  /// Optional trailing icon.
  final IconData? icon;

  /// Visual style.
  final DawButtonVariant variant;

  @override
  State<DawButton> createState() => _DawButtonState();
}

class _DawButtonState extends State<DawButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _activate() {
    if (_enabled) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final daw = context.dawColors;
    final isPrimary = widget.variant == DawButtonVariant.primary;
    final highlighted = _enabled && (_hovered || _focused);
    final foreground = isPrimary ? colors.onPrimary : colors.onSurface;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _enabled,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _activate(),
          ),
        },
        child: GestureDetector(
          onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: () => setState(() => _pressed = false),
          onTap: _enabled ? _activate : null,
          child: AnimatedScale(
            scale: _pressed ? 0.975 : 1,
            duration: AppDurations.fast,
            child: AnimatedOpacity(
              opacity: widget.onPressed == null ? 0.5 : 1,
              duration: AppDurations.medium,
              child: AnimatedContainer(
                duration: AppDurations.medium,
                curve: Curves.easeOutCubic,
                height: AppSpacing.xxl + AppSpacing.xs,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: AppRadii.mdAll,
                  gradient: isPrimary
                      ? LinearGradient(
                          begin: highlighted
                              ? Alignment.topLeft
                              : Alignment.centerLeft,
                          end: highlighted
                              ? Alignment.bottomRight
                              : Alignment.centerRight,
                          colors: [daw.waveStart, daw.waveEnd],
                        )
                      : null,
                  border: isPrimary
                      ? null
                      : Border.all(
                          color: highlighted
                              ? colors.primary
                              : colors.outlineVariant,
                        ),
                  boxShadow: [
                    if (isPrimary)
                      BoxShadow(
                        color: daw.cursorGlow,
                        blurRadius: highlighted ? 32 : 12,
                        spreadRadius: highlighted ? 2 : 0,
                        offset: Offset(0, highlighted ? 8 : 4),
                      ),
                  ],
                ),
                child: _ButtonContent(
                  label: widget.label,
                  icon: widget.icon,
                  isLoading: widget.isLoading,
                  color: foreground,
                  hovered: highlighted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.color,
    required this.hovered,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color color;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.medium,
      child: isLoading
          ? EqualizerLoader(key: const ValueKey('loading'), color: color)
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.label.copyWith(
                      color: color,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
                if (icon != null)
                  AnimatedPadding(
                    duration: AppDurations.fast,
                    padding: EdgeInsets.only(
                      left: hovered ? AppSpacing.smd : AppSpacing.sm,
                    ),
                    child: Icon(icon, size: 18, color: color),
                  ),
              ],
            ),
    );
  }
}
