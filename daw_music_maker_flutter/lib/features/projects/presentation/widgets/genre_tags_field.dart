import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../core/validation/validators.dart';
import '../../../../shared/widgets/daw/tag_chip.dart';

/// Genre tag input: type a genre and press Enter (or comma) to add it as a
/// chip; chips can be removed. Validates each tag with
/// [Validators.genreTag].
class GenreTagsField extends StatefulWidget {
  /// Creates the field.
  const GenreTagsField({
    super.key,
    required this.genres,
    required this.onChanged,
    this.enabled = true,
    this.serverError,
  });

  /// Key of the text input.
  static const inputKey = Key('genreTags.input');

  /// Current tags.
  final List<String> genres;

  /// Called with the new list after adding or removing a tag.
  final ValueChanged<List<String>> onChanged;

  /// Whether editing is allowed.
  final bool enabled;

  /// Error returned by the server for `genres`, if any.
  final String? serverError;

  @override
  State<GenreTagsField> createState() => _GenreTagsFieldState();
}

class _GenreTagsFieldState extends State<GenreTagsField> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final tag = raw.replaceAll(',', '').trim();
    if (tag.isEmpty) {
      _controller.clear();
      return;
    }
    final error = Validators.genreTag(tag, widget.genres);
    setState(() => _error = error);
    if (error != null) return;
    widget.onChanged([...widget.genres, tag]);
    _controller.clear();
  }

  void _remove(String tag) {
    setState(() => _error = null);
    widget.onChanged([...widget.genres]..remove(tag));
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: GenreTagsField.inputKey,
          controller: _controller,
          enabled: widget.enabled,
          textInputAction: TextInputAction.done,
          style: styles.body,
          onChanged: (value) {
            if (value.endsWith(',')) _add(value);
          },
          onSubmitted: _add,
          decoration: InputDecoration(
            labelText: 'Genres',
            hintText: 'techno, lo-fi, drum & bass…',
            prefixIcon: const Icon(Icons.sell_outlined, size: 20),
            errorText: _error ?? widget.serverError,
            helperText:
                'Press Enter to add · ${widget.genres.length}/'
                '${ValidationRules.projectGenresMax}',
            suffixIcon: IconButton(
              tooltip: 'Add genre',
              icon: const Icon(Icons.add_rounded),
              onPressed: widget.enabled ? () => _add(_controller.text) : null,
            ),
          ),
        ),
        if (widget.genres.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.smd),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final g in widget.genres)
                TagChip(
                  label: g,
                  onDeleted: widget.enabled ? () => _remove(g) : null,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
