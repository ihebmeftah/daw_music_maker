import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/validation/validators.dart';

/// Formats a tempo: whole numbers without decimals, otherwise 2 decimals.
String formatBpm(double bpm) => bpm == bpm.roundToDouble()
    ? bpm.toInt().toString()
    : bpm.toStringAsFixed(2);

/// The tempo "LCD" of the transport toolbar.
///
/// - **Hold + mouse wheel**: while the pointer is pressed on the display,
///   each wheel notch changes the tempo by 1 BPM (0.1 with Shift); wheel up
///   is faster. The page does not scroll meanwhile.
/// - **Hold + drag** up/down: 1 BPM per [pixelsPerBpm] (for trackpads and
///   touch screens).
/// - Releasing calls [onCommit] (save).
/// - **Double-click** to type an exact value (20–999).
class BpmDisplay extends StatefulWidget {
  /// Creates the display.
  const BpmDisplay({
    super.key,
    required this.bpm,
    required this.enabled,
    required this.onAdjust,
    required this.onCommit,
    required this.onSubmitted,
  });

  /// Key of the tempo text.
  static const valueKey = Key('studio.bpmValue');

  /// Key of the exact-value field shown while editing.
  static const fieldKey = Key('studio.bpmField');

  /// Drag distance for 1 BPM.
  static const double pixelsPerBpm = 4;

  /// Current tempo.
  final double bpm;

  /// Whether the tempo can be changed.
  final bool enabled;

  /// Live change by a delta in BPM (not saved yet).
  final ValueChanged<double> onAdjust;

  /// Pointer released after adjusting: persist.
  final VoidCallback onCommit;

  /// Exact value typed and validated.
  final ValueChanged<double> onSubmitted;

  @override
  State<BpmDisplay> createState() => _BpmDisplayState();
}

class _BpmDisplayState extends State<BpmDisplay> {
  bool _held = false;
  bool _editing = false;
  String? _error;
  double _dragRemainder = 0;
  final _field = TextEditingController();
  final _fieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fieldFocus.addListener(() {
      if (!_fieldFocus.hasFocus && _editing) setState(() => _editing = false);
    });
  }

  @override
  void dispose() {
    _field.dispose();
    _fieldFocus.dispose();
    super.dispose();
  }

  void _press(PointerDownEvent event) {
    if (!widget.enabled || _editing) return;
    setState(() => _held = true);
    _dragRemainder = 0;
  }

  void _release(PointerEvent event) {
    if (!_held) return;
    setState(() => _held = false);
    widget.onCommit();
  }

  void _drag(PointerMoveEvent event) {
    if (!_held) return;
    // Up is faster: screen y grows downwards.
    _dragRemainder -= event.delta.dy;
    final steps = (_dragRemainder / BpmDisplay.pixelsPerBpm).truncate();
    if (steps != 0) {
      _dragRemainder -= steps * BpmDisplay.pixelsPerBpm;
      widget.onAdjust(steps.toDouble());
    }
  }

  void _scroll(PointerSignalEvent event) {
    if (!_held || event is! PointerScrollEvent) return;
    // Claim the event so scrollable ancestors don't also react to it.
    GestureBinding.instance.pointerSignalResolver.register(event, (resolved) {
      final scroll = resolved as PointerScrollEvent;
      if (scroll.scrollDelta.dy == 0) return;
      final step = HardwareKeyboard.instance.isShiftPressed ? 0.1 : 1.0;
      widget.onAdjust(scroll.scrollDelta.dy < 0 ? step : -step);
    });
  }

  void _startEditing() {
    if (!widget.enabled) return;
    _field.text = formatBpm(widget.bpm);
    setState(() {
      _editing = true;
      _error = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fieldFocus.requestFocus();
      _field.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _field.text.length,
      );
    });
  }

  void _submit() {
    final error = Validators.bpm(_field.text);
    if (error != null) {
      setState(() => _error = error);
      _fieldFocus.requestFocus();
      return;
    }
    widget.onSubmitted(double.parse(_field.text.trim().replaceAll(',', '.')));
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final daw = context.dawColors;
    final styles = context.textStyles;
    final active = _held || _editing;

    // No tooltip on purpose: it would pop over the number while the user
    // holds it to adjust. The studio shows the gesture hint instead.
    return Semantics(
      label: '${formatBpm(widget.bpm)} beats per minute',
      hint: widget.enabled
          ? 'Hold and scroll or drag to change, double tap to type'
          : null,
      excludeSemantics: !_editing,
      child: Listener(
        onPointerDown: _press,
        onPointerMove: _drag,
        onPointerUp: _release,
        onPointerCancel: _release,
        onPointerSignal: _scroll,
        child: GestureDetector(
          onDoubleTap: _startEditing,
          child: MouseRegion(
            cursor: widget.enabled
                ? SystemMouseCursors.resizeUpDown
                : SystemMouseCursors.basic,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              width: 176,
              height: AppSpacing.xxl + AppSpacing.sm,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smd),
              decoration: BoxDecoration(
                // Recessed LCD look.
                color: colors.surfaceContainerLowest,
                borderRadius: AppRadii.mdAll,
                border: Border.all(
                  color: _error != null && _editing
                      ? colors.error
                      : active
                      ? colors.primary
                      : colors.outlineVariant,
                  width: active ? 1.6 : 1,
                ),
                boxShadow: [
                  if (active) BoxShadow(color: daw.cursorGlow, blurRadius: 18),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.unfold_more_rounded,
                    size: 18,
                    color: active ? colors.primary : colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _editing
                        ? TextField(
                            key: BpmDisplay.fieldKey,
                            controller: _field,
                            focusNode: _fieldFocus,
                            style: styles.mono.copyWith(fontSize: 22),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (_) {
                              if (_error != null) {
                                setState(() => _error = null);
                              }
                            },
                            onSubmitted: (_) => _submit(),
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                        : FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              formatBpm(widget.bpm),
                              key: BpmDisplay.valueKey,
                              style: styles.monoLarge.copyWith(
                                color: active
                                    ? colors.primary
                                    : colors.onSurface,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      _editing && _error != null ? _error! : 'BPM',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.eyebrow.copyWith(
                        fontSize: 10,
                        color: _editing && _error != null ? colors.error : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
