import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppText {
  // Serif — Source Serif 4
  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text,
    FontStyle style = FontStyle.normal,
    double? height,
  }) =>
      GoogleFonts.sourceSerif4(
        fontSize: size,
        fontWeight: weight,
        color: color,
        fontStyle: style,
        height: height,
      );

  // Sans — DM Sans
  static TextStyle sans({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  // Mono — DM Mono
  static TextStyle mono({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textSecondary,
    double? letterSpacing,
  }) =>
      GoogleFonts.dmMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );
}
