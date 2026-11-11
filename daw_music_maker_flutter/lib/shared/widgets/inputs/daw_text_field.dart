import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/theme_context.dart';

/// The app's text field: a themed [TextFormField] with a validator, an
/// optional show/hide toggle for passwords and a monospaced mode for codes.
///
/// Must be placed inside a [Form].
///
/// ```dart
/// DawTextField(
///   label: 'Email',
///   controller: _email,
///   validator: Validators.email,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class DawTextField extends StatefulWidget {
  /// Creates a text field.
  const DawTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.obscure = false,
    this.monospace = false,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
  });

  /// Floating label.
  final String label;

  /// Text controller.
  final TextEditingController? controller;

  /// Validator from `core/validation/validators.dart`.
  final FormFieldValidator<String>? validator;

  /// Placeholder shown when empty.
  final String? hint;

  /// Leading icon.
  final IconData? prefixIcon;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Autofill hints (e.g. [AutofillHints.email]).
  final Iterable<String>? autofillHints;

  /// Input formatters (e.g. digits only).
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum number of characters (the counter is hidden).
  final int? maxLength;

  /// Maximum visible lines (use more than 1 for multi-line text).
  final int maxLines;

  /// Minimum visible lines.
  final int? minLines;

  /// Hides the text and shows a visibility toggle.
  final bool obscure;

  /// Uses the monospaced, widely spaced style (verification codes).
  final bool monospace;

  /// Whether the field accepts input.
  final bool enabled;

  /// Focus on first build.
  final bool autofocus;

  /// Called on every change.
  final ValueChanged<String>? onChanged;

  /// Called when the keyboard action is pressed.
  final ValueChanged<String>? onSubmitted;

  @override
  State<DawTextField> createState() => _DawTextFieldState();
}

class _DawTextFieldState extends State<DawTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final colors = context.colors;
    final textStyle = widget.monospace
        ? styles.monoLarge.copyWith(letterSpacing: 8)
        : styles.body;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      obscureText: _obscured,
      enableSuggestions: !widget.obscure,
      autocorrect: false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      maxLines: widget.obscure ? 1 : widget.maxLines,
      minLines: widget.minLines,
      textAlign: widget.monospace ? TextAlign.center : TextAlign.start,
      style: textStyle,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        counterText: '',
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, size: 20),
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? colors.primary
              : colors.onSurfaceVariant,
        ),
        suffixIcon: widget.obscure
            ? IconButton(
                tooltip: _obscured ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _obscured = !_obscured),
                icon: Icon(
                  _obscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
              )
            : null,
      ),
    );
  }
}
