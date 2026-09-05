import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

/// Builds a Flutter [ThemeData] from a [Palette]. Most of the app's own
/// widgets paint their colors directly from the palette (mirroring the
/// original design's inline-styled screens), so this theme mainly wires
/// up the Archivo type family and the shared input/app-bar look so
/// built-in Material widgets (TextField, AppBar, …) match them.
ThemeData buildAppTheme(Palette p) {
  final base = p.isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);
  final textTheme = GoogleFonts.archivoTextTheme(base.textTheme).apply(
    bodyColor: p.textHeading,
    displayColor: p.textHeading,
  );

  return base.copyWith(
    scaffoldBackgroundColor: p.bg,
    canvasColor: p.bg,
    dividerColor: p.divider,
    textTheme: textTheme,
    colorScheme: base.colorScheme.copyWith(
      brightness: p.brightness,
      primary: p.tone(SemanticToken.primary),
      error: p.tone(SemanticToken.danger),
      surface: p.surface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: p.topbar,
      foregroundColor: p.textHeading,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: headingStyle(p, size: 16, weight: FontWeight.w800),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surface,
      hintStyle: bodyStyle(p, size: 14, color: p.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: p.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: p.border)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: p.tone(SemanticToken.primary), width: 1.5),
      ),
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}

TextStyle headingStyle(Palette p, {double size = 16, FontWeight weight = FontWeight.w800, Color? color}) {
  return GoogleFonts.archivo(fontSize: size, fontWeight: weight, color: color ?? p.textHeading, height: 1.15);
}

TextStyle bodyStyle(Palette p, {double size = 14, FontWeight weight = FontWeight.w400, Color? color}) {
  return GoogleFonts.archivo(fontSize: size, fontWeight: weight, color: color ?? p.textHeading, height: 1.4);
}
