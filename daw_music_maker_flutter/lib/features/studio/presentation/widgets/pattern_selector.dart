import 'package:daw_music_maker_client/daw_music_maker_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../shared/widgets/feedback/equalizer_loader.dart';
import 'transport_toolbar.dart' show toolbarIconStyle;

/// Callbacks of the [PatternSelector].
class PatternActions {
  /// Creates the callbacks.
  const PatternActions({
    required this.onSelect,
    required this.onStep,
    required this.onCreate,
    required this.onClone,
    required this.onRename,
    required this.onColor,
    required this.onLength,
    required this.onDelete,
  });

  /// Select a pattern by id.
  final ValueChanged<UuidValue> onSelect;

  /// Previous (−1) / next (+1) pattern.
  final ValueChanged<int> onStep;

  /// Add a new pattern.
  final VoidCallback onCreate;

  /// Clone the selected pattern.
  final VoidCallback onClone;

  /// Rename the selected pattern (opens a dialog).
  final VoidCallback onRename;

  /// Recolor the selected pattern.
  final ValueChanged<int> onColor;

  /// Change the selected pattern's length in bars.
  final ValueChanged<int> onLength;

  /// Delete the selected pattern.
  final VoidCallback onDelete;
}

/// FL Studio–style pattern picker for the transport toolbar:
/// `◀ [■ Pattern 1 ▾] ▶ +`. The box opens a menu with every pattern and,
/// for editors, new / clone / rename / color / length / delete.
class PatternSelector extends StatelessWidget {
  /// Creates the selector.
  const PatternSelector({
    super.key,
    required this.patterns,
    required this.selected,
    required this.canEdit,
    required this.isBusy,
    required this.actions,
  });

  /// Key of the box that opens the menu.
  static const menuKey = Key('pattern.menu');

  /// Key of the previous-pattern arrow.
  static const previousKey = Key('pattern.previous');

  /// Key of the next-pattern arrow.
  static const nextKey = Key('pattern.next');

  /// Key of the "+" (new pattern) button.
  static const addKey = Key('pattern.add');

  /// Key of the menu entry selecting the pattern [id].
  static Key itemKey(UuidValue id) => Key('pattern.item.$id');

  /// Key of the "Clone" menu entry.
  static const cloneKey = Key('pattern.clone');

  /// Key of the "Rename…" menu entry.
  static const renameKey = Key('pattern.rename');

  /// Key of the "Delete" menu entry.
  static const deleteKey = Key('pattern.delete');

  /// Key of the length submenu.
  static const lengthMenuKey = Key('pattern.lengthMenu');

  /// Key of the color submenu.
  static const colorMenuKey = Key('pattern.colorMenu');

  /// Key of the length entry for [bars].
  static Key lengthKey(int bars) => Key('pattern.length.$bars');

  /// Key of the color entry for [index].
  static Key colorKey(int index) => Key('pattern.color.$index');

  /// Patterns in order.
  final List<PatternResponse> patterns;

  /// The selected pattern.
  final PatternResponse? selected;

  /// Whether the user may change patterns.
  final bool canEdit;

  /// Whether a pattern change is in flight.
  final bool isBusy;

  /// Callbacks.
  final PatternActions actions;

  @override
  Widget build(BuildContext context) {
    final many = patterns.length > 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: previousKey,
          style: toolbarIconStyle(),
          tooltip: 'Previous pattern ([)',
          onPressed: many ? () => actions.onStep(-1) : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        MenuAnchor(
          menuChildren: _menu(context),
          builder: (context, controller, _) => _PatternBox(
            key: menuKey,
            pattern: selected,
            isBusy: isBusy,
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
        IconButton(
          key: nextKey,
          style: toolbarIconStyle(),
          tooltip: 'Next pattern (])',
          onPressed: many ? () => actions.onStep(1) : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
        if (canEdit)
          IconButton.outlined(
            key: addKey,
            style: toolbarIconStyle(),
            tooltip: 'New pattern',
            onPressed: isBusy ? null : actions.onCreate,
            icon: const Icon(Icons.add_rounded),
          ),
      ],
    );
  }

  List<Widget> _menu(BuildContext context) {
    final daw = context.dawColors;
    final current = selected;
    return [
      for (final p in patterns)
        MenuItemButton(
          key: itemKey(p.id),
          onPressed: () => actions.onSelect(p.id),
          leadingIcon: _Swatch(color: daw.trackColor(p.colorIndex)),
          trailingIcon: p.id == current?.id
              ? const Icon(Icons.check_rounded, size: 18)
              : null,
          child: Text(
            '${p.name} · ${p.lengthBars} bar${p.lengthBars == 1 ? '' : 's'}',
          ),
        ),
      if (canEdit && current != null) ...[
        const Divider(height: AppSpacing.sm),
        MenuItemButton(
          onPressed: actions.onCreate,
          leadingIcon: const Icon(Icons.add_rounded),
          child: const Text('New pattern'),
        ),
        MenuItemButton(
          key: cloneKey,
          onPressed: patterns.length < ValidationRules.patternsMax
              ? actions.onClone
              : null,
          leadingIcon: const Icon(Icons.copy_all_rounded),
          child: const Text('Clone'),
        ),
        MenuItemButton(
          key: renameKey,
          onPressed: actions.onRename,
          leadingIcon: const Icon(Icons.edit_outlined),
          child: const Text('Rename…'),
        ),
        SubmenuButton(
          key: colorMenuKey,
          leadingIcon: const Icon(Icons.palette_outlined),
          menuChildren: [
            for (var i = 0; i < ValidationRules.patternColorCount; i++)
              MenuItemButton(
                key: colorKey(i),
                onPressed: () => actions.onColor(i),
                leadingIcon: _Swatch(color: daw.trackColor(i)),
                trailingIcon: i == current.colorIndex
                    ? const Icon(Icons.check_rounded, size: 18)
                    : null,
                child: Text('Color ${i + 1}'),
              ),
          ],
          child: const Text('Color'),
        ),
        SubmenuButton(
          key: lengthMenuKey,
          leadingIcon: const Icon(Icons.straighten_rounded),
          menuChildren: [
            for (final bars in ValidationRules.patternLengths)
              MenuItemButton(
                key: lengthKey(bars),
                onPressed: () => actions.onLength(bars),
                trailingIcon: bars == current.lengthBars
                    ? const Icon(Icons.check_rounded, size: 18)
                    : null,
                child: Text('$bars bar${bars == 1 ? '' : 's'}'),
              ),
          ],
          child: const Text('Length'),
        ),
        MenuItemButton(
          key: deleteKey,
          onPressed: patterns.length > 1 ? actions.onDelete : null,
          leadingIcon: Icon(
            Icons.delete_outline_rounded,
            color: context.colors.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ];
  }
}

/// The toolbar box: color swatch, pattern name, length and a caret.
class _PatternBox extends StatelessWidget {
  const _PatternBox({
    super.key,
    required this.pattern,
    required this.isBusy,
    required this.onTap,
  });

  final PatternResponse? pattern;
  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    final color = pattern == null
        ? colors.outline
        : context.dawColors.trackColor(pattern!.colorIndex);
    return Semantics(
      button: true,
      label: 'Pattern ${pattern?.name ?? 'none'}, open pattern menu',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdAll,
        child: Container(
          width: 120,
          height: AppSpacing.toolbarControl,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: AppRadii.mdAll,
            border: Border.all(color: color.withValues(alpha: 0.7)),
          ),
          child: Row(
            children: [
              _Swatch(color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern?.name ?? 'No pattern',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.label.copyWith(fontSize: 12, height: 1.1),
                    ),
                    if (pattern != null)
                      Text(
                        '${pattern!.lengthBars} BAR${pattern!.lengthBars == 1 ? '' : 'S'}',
                        style: styles.eyebrow.copyWith(
                          fontSize: 8,
                          height: 1.1,
                        ),
                      ),
                  ],
                ),
              ),
              if (isBusy)
                EqualizerLoader(color: colors.primary, bars: 3, height: 12)
              else
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: colors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small colored square identifying a pattern.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.smd,
      height: AppSpacing.smd,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.smAll,
      ),
    );
  }
}
