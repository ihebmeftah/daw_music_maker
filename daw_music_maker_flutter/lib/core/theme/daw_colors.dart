import 'package:flutter/material.dart';

import 'app_colors.dart';

/// DAW-specific semantic colors that do not map onto Material's [ColorScheme].
///
/// Read with `context.dawColors`:
///
/// ```dart
/// Container(color: context.dawColors.panel)
/// ```
@immutable
class DawColors extends ThemeExtension<DawColors> {
  /// Creates a [DawColors] palette.
  const DawColors({
    required this.backdrop,
    required this.panel,
    required this.panelBorder,
    required this.waveStart,
    required this.waveEnd,
    required this.cursorGlow,
    required this.gridLine,
    required this.meterLow,
    required this.meterMid,
    required this.meterHigh,
    required this.record,
    required this.shadow,
  });

  /// Deepest background behind every surface (the "studio wall").
  final Color backdrop;

  /// Frosted panel fill (semi-transparent, drawn over the backdrop).
  final Color panel;

  /// Panel border at rest.
  final Color panelBorder;

  /// Start color of waveform gradients.
  final Color waveStart;

  /// End color of waveform gradients.
  final Color waveEnd;

  /// Glow drawn around the mouse cursor and focused elements.
  final Color cursorGlow;

  /// Subtle grid / bar lines.
  final Color gridLine;

  /// Level meter: safe range.
  final Color meterLow;

  /// Level meter: approaching clip.
  final Color meterMid;

  /// Level meter: clipping.
  final Color meterHigh;

  /// Record / armed indicator.
  final Color record;

  /// Drop shadow color.
  final Color shadow;

  /// Palette for the dark ("midnight studio") theme.
  static final DawColors dark = DawColors(
    backdrop: AppColors.ink950,
    panel: AppColors.ink900.withValues(alpha: 0.78),
    panelBorder: AppColors.ink600,
    waveStart: AppColors.amber400,
    waveEnd: AppColors.red400,
    cursorGlow: AppColors.amber400.withValues(alpha: 0.32),
    gridLine: AppColors.ink700,
    meterLow: AppColors.teal400,
    meterMid: AppColors.yellow400,
    meterHigh: AppColors.red400,
    record: AppColors.red400,
    shadow: AppColors.black.withValues(alpha: 0.6),
  );

  /// Palette for the light ("paper studio") theme.
  static final DawColors light = DawColors(
    backdrop: AppColors.paper50,
    panel: AppColors.paper100.withValues(alpha: 0.82),
    panelBorder: AppColors.paper300,
    waveStart: AppColors.burnt600,
    waveEnd: AppColors.red600,
    cursorGlow: AppColors.burnt600.withValues(alpha: 0.22),
    gridLine: AppColors.paper200,
    meterLow: AppColors.teal700,
    meterMid: AppColors.yellow400,
    meterHigh: AppColors.red600,
    record: AppColors.red600,
    shadow: AppColors.graphite900.withValues(alpha: 0.14),
  );

  @override
  DawColors copyWith({
    Color? backdrop,
    Color? panel,
    Color? panelBorder,
    Color? waveStart,
    Color? waveEnd,
    Color? cursorGlow,
    Color? gridLine,
    Color? meterLow,
    Color? meterMid,
    Color? meterHigh,
    Color? record,
    Color? shadow,
  }) {
    return DawColors(
      backdrop: backdrop ?? this.backdrop,
      panel: panel ?? this.panel,
      panelBorder: panelBorder ?? this.panelBorder,
      waveStart: waveStart ?? this.waveStart,
      waveEnd: waveEnd ?? this.waveEnd,
      cursorGlow: cursorGlow ?? this.cursorGlow,
      gridLine: gridLine ?? this.gridLine,
      meterLow: meterLow ?? this.meterLow,
      meterMid: meterMid ?? this.meterMid,
      meterHigh: meterHigh ?? this.meterHigh,
      record: record ?? this.record,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  DawColors lerp(DawColors? other, double t) {
    if (other == null) return this;
    return DawColors(
      backdrop: Color.lerp(backdrop, other.backdrop, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      panelBorder: Color.lerp(panelBorder, other.panelBorder, t)!,
      waveStart: Color.lerp(waveStart, other.waveStart, t)!,
      waveEnd: Color.lerp(waveEnd, other.waveEnd, t)!,
      cursorGlow: Color.lerp(cursorGlow, other.cursorGlow, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
      meterLow: Color.lerp(meterLow, other.meterLow, t)!,
      meterMid: Color.lerp(meterMid, other.meterMid, t)!,
      meterHigh: Color.lerp(meterHigh, other.meterHigh, t)!,
      record: Color.lerp(record, other.record, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
