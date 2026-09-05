import 'package:flutter/material.dart';

/// Semantic color roles shared by both dark and light palettes.
/// These map 1:1 onto the category tokens (kira→primary, yiyecek→success, …)
/// documented in `uploads/design-3.md` of the original design project.
enum SemanticToken { primary, success, danger, accent, warning, info }

/// A fully resolved set of colors for one brightness (dark or light),
/// matching the `getTokens()` function of the original Finansal Asistan
/// prototype and the "Design System — Finansal Asistan" color spec.
class Palette {
  final Brightness brightness;
  final Color bg;
  final Color surface;
  final Color surfaceActive;
  final Color topbar;
  final Color textHeading;
  final Color textMuted;
  final Color border;
  final Color divider;
  final Color disabledBg;
  final Color chartGrid;
  final Color chartAccent;
  final Color shadow;

  final Map<SemanticToken, Color> solid;
  final Map<SemanticToken, Color> soft;
  final Map<SemanticToken, Color> onSoft; // readable text/icon color on `soft`
  final Map<SemanticToken, Color> hover;

  const Palette({
    required this.brightness,
    required this.bg,
    required this.surface,
    required this.surfaceActive,
    required this.topbar,
    required this.textHeading,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.disabledBg,
    required this.chartGrid,
    required this.chartAccent,
    required this.shadow,
    required this.solid,
    required this.soft,
    required this.onSoft,
    required this.hover,
  });

  bool get isDark => brightness == Brightness.dark;

  Color tone(SemanticToken t) => solid[t]!;
  Color softTone(SemanticToken t) => soft[t]!;
  Color onSoftTone(SemanticToken t) => onSoft[t]!;
  Color hoverTone(SemanticToken t) => hover[t]!;

  static const Map<SemanticToken, Color> _solid = {
    SemanticToken.primary: Color(0xFF2A68C2),
    SemanticToken.success: Color(0xFF3EA35A),
    SemanticToken.danger: Color(0xFFC94344),
    SemanticToken.accent: Color(0xFF7050B7),
    SemanticToken.warning: Color(0xFFF68E2B),
    SemanticToken.info: Color(0xFFEABD44),
  };

  static const Map<SemanticToken, Color> _softDark = {
    SemanticToken.primary: Color(0xFF1B2E4A),
    SemanticToken.success: Color(0xFF1C3324),
    SemanticToken.danger: Color(0xFF3A2224),
    SemanticToken.accent: Color(0xFF2C2440),
    SemanticToken.warning: Color(0xFF3D2C15),
    SemanticToken.info: Color(0xFF3A3016),
  };

  static const Map<SemanticToken, Color> _softLight = {
    SemanticToken.primary: Color(0xFFE7EFFB),
    SemanticToken.success: Color(0xFFE6F4EA),
    SemanticToken.danger: Color(0xFFFBE9E9),
    SemanticToken.accent: Color(0xFFEFEAFA),
    SemanticToken.warning: Color(0xFFFDEFDE),
    SemanticToken.info: Color(0xFFFBF3DD),
  };

  static const Map<SemanticToken, Color> _textLight = {
    SemanticToken.primary: Color(0xFF1E4F94),
    SemanticToken.success: Color(0xFF1F7A3D),
    SemanticToken.danger: Color(0xFFA6282A),
    SemanticToken.accent: Color(0xFF573B94),
    SemanticToken.warning: Color(0xFFC56A10),
    SemanticToken.info: Color(0xFFA67F12),
  };

  static const Map<SemanticToken, Color> _hoverDark = {
    SemanticToken.primary: Color(0xFF3578D6),
    SemanticToken.danger: Color(0xFFDA5657),
    SemanticToken.success: Color(0xFF4CBB6E),
    SemanticToken.accent: Color(0xFF8360CC),
    SemanticToken.warning: Color(0xFFFF9E42),
    SemanticToken.info: Color(0xFFF2CC5C),
  };

  static const Map<SemanticToken, Color> _hoverLight = {
    SemanticToken.primary: Color(0xFF1A529E),
    SemanticToken.danger: Color(0xFF8F3234),
    SemanticToken.success: Color(0xFF1C6833),
    SemanticToken.accent: Color(0xFF48326E),
    SemanticToken.warning: Color(0xFFA85A0C),
    SemanticToken.info: Color(0xFF8C6C10),
  };

  static const Palette dark = Palette(
    brightness: Brightness.dark,
    bg: Color(0xFF0F1925),
    surface: Color(0xFF172530),
    surfaceActive: Color(0xFF203663),
    topbar: Color(0xFF202A36),
    textHeading: Color(0xFFFFFFFF),
    textMuted: Color(0xFF8A94A6),
    border: Color(0xFF24344A),
    divider: Color(0xFF1E2C3D),
    disabledBg: Color(0xFF1C2836),
    chartGrid: Color(0xFF26374F),
    chartAccent: Color(0xFF2DD4BF),
    shadow: Color(0x66000000),
    solid: _solid,
    soft: _softDark,
    onSoft: _solid, // dark mode: solid semantic color reads fine on soft fill
    hover: _hoverDark,
  );

  static const Palette light = Palette(
    brightness: Brightness.light,
    bg: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceActive: Color(0xFFE3ECFB),
    topbar: Color(0xFFFFFFFF),
    textHeading: Color(0xFF101828),
    textMuted: Color(0xFF5A6472),
    border: Color(0xFFE2E6EC),
    divider: Color(0xFFEDEFF3),
    disabledBg: Color(0xFFF0F2F5),
    chartGrid: Color(0xFFE2E6EC),
    chartAccent: Color(0xFF0D9488),
    shadow: Color(0x1A101828),
    solid: _solid,
    soft: _softLight,
    onSoft: _textLight, // light mode: deeper text-variant for contrast
    hover: _hoverLight,
  );

  static Palette of(Brightness b) => b == Brightness.dark ? dark : light;
}
