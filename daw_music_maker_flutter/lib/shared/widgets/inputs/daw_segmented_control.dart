import 'package:flutter/material.dart';

import '../../../core/constants/app_durations.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_context.dart';

/// One option of a [DawSegmentedControl].
class DawSegment<T> {
  /// Creates an option.
  const DawSegment({
    required this.value,
    required this.label,
    this.icon,
    this.key,
  });

  /// The value selected by this option.
  final T value;

  /// Visible label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional key for tests.
  final Key? key;
}

/// Mixer-style segmented switch: options sit in a recessed track and the
/// selected one lights up with the accent gradient.
///
/// ```dart
/// DawSegmentedControl<ProjectRole>(
///   segments: const [
///     DawSegment(value: ProjectRole.read, label: 'Read'),
///     DawSegment(value: ProjectRole.write, label: 'Write'),
///   ],
///   selected: role,
///   onChanged: (r) => setState(() => role = r),
/// )
/// ```
class DawSegmentedControl<T> extends StatelessWidget {
  /// Creates the control.
  const DawSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.expand = true,
  });

  /// Available options.
  final List<DawSegment<T>> segments;

  /// Currently selected value.
  final T selected;

  /// Called with the tapped value (disabled when null).
  final ValueChanged<T>? onChanged;

  /// Whether options share the full width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: AppRadii.mdAll,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (final segment in segments)
            _wrap(
              _SegmentButton<T>(
                key: segment.key,
                segment: segment,
                selected: segment.value == selected,
                onTap: onChanged == null
                    ? null
                    : () => onChanged!(segment.value),
              ),
            ),
        ],
      ),
    );
  }

  Widget _wrap(Widget child) => expand ? Expanded(child: child) : child;
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    super.key,
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final DawSegment<T> segment;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final daw = context.dawColors;
    final foreground = selected ? colors.onPrimary : colors.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdAll,
        child: AnimatedContainer(
          duration: AppDurations.medium,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.smd - 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.md - 2),
            gradient: selected
                ? LinearGradient(colors: [daw.waveStart, daw.waveEnd])
                : null,
            boxShadow: [
              if (selected) BoxShadow(color: daw.cursorGlow, blurRadius: 14),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (segment.icon != null) ...[
                Icon(segment.icon, size: 16, color: foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  segment.label,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.label.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
