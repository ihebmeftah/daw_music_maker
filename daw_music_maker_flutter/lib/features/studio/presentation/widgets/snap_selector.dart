import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../state/grid_snap.dart';

/// "GRID · Step ▾" menu choosing the snap of an editor.
class SnapSelector extends StatelessWidget {
  /// Creates the selector.
  const SnapSelector({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  /// Key of the menu entry for [snap] (within the menu of [selectorKey]).
  static Key optionKey(Key selectorKey, GridSnap snap) =>
      ValueKey('$selectorKey.${snap.name}');

  /// Current snap.
  final GridSnap value;

  /// Offered snaps.
  final List<GridSnap> options;

  /// Called with the chosen snap.
  final ValueChanged<GridSnap> onChanged;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    return PopupMenuButton<GridSnap>(
      tooltip: 'Snap to grid',
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => [
        for (final snap in options)
          PopupMenuItem(
            key: optionKey(key ?? const ValueKey('snap'), snap),
            value: snap,
            child: Text(snap.label),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadii.smAll,
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.grid_4x4_rounded, size: 14, color: colors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text('GRID · ', style: styles.eyebrow.copyWith(fontSize: 9)),
            Text(value.label, style: styles.label.copyWith(fontSize: 12)),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
