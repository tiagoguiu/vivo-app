import 'package:flutter/material.dart';

/// Extension to safely apply opacity to colors.
/// Uses withValues() with explicit RGB preservation for iOS 18+ compatibility.
extension SafeColorOpacity on Color {
  /// Applies opacity (0.0 to 1.0) while preserving RGB components.
  /// This avoids the iOS 18+ color space rendering issues.
  Color withSafeOpacity(double opacity) =>
      withValues(red: r, green: g, blue: b, alpha: opacity);
}

class AppColors {
  AppColors._();

  // Basic
  static const Color generalText = Color(0xFF000000);
  static const Color textOnDarkBackground = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Gray
  static const Color contentBackground = Color(0xFFF4F4F4);
  static const Color lightGray = Color(0xFFD8D8D8);
  // Figma has a "Claro Médio" at #DBDBDB — keep as an explicit token
  static const Color lightGrayMedium = Color(0xFFDBDBDB);
  static const Color mediumGray = Color(0xFF969696);
  static const Color mediumSemiDarkGray = Color(0xFF71717A);
  static const Color mediumDarkGray = Color(0xFF646464);
  static const Color almostDarkGray = Color(0xFF737475);
  static const Color darkGray = Color(0xFF323232);

  // Main
  static const Color primary = Color(0xFF004080);
  static const Color accent = Color(0xFFE36013);

  // Cold
  static const Color teal = Color(0xFF0277BD);
  static const Color softLightBlue = Color(0xFF64B5F6);
  // Alias names from the Figma design system
  static const Color azulPetroleo = teal; // #0277BD
  static const Color azulClaroSuave = softLightBlue; // #64B5F6
  static const Color mediumBlue = Color(0xFF015DA9);

  // Complementary
  static const Color softBlue = Color(0xFFDBEAFE);
  static const Color softGreen = Color(0xFFDCFCE7);
  static const Color darkGreen = Color(0xFF2C7752);
  static const Color softViolet = Color(0xFFF3E8FF);
  static const Color purple = Color(0xFF6B21A8);
  // Exact purple used in the Figma palette (close variant)
  static const Color roxoFigma = Color(0xFF6821A8);
  static const Color softYellow = Color(0xFFFEF9C3);
  static const Color brown = Color(0xFF854D48);
  static const Color salmonPink = Color(0xFFFEE2E2);
  static const Color burntRed = Color(0xFFBD2E1B);
  static const Color pjPrimaryRed = Color(0xFFE22B1F);

  // Colors with opacity (pre-defined for iOS compatibility)
  static const Color blackOverlay = Color(0xB3000000); // black with 70% opacity
  static const Color blackShadow = Color(0x40000000); // black with 25% opacity
  static const Color blackShadowLight = Color(
    0x0D000000,
  ); // black with 5% opacity
  static const Color blackShadowMedium = Color(
    0x14000000,
  ); // black with 8% opacity
  static const Color whiteOverlay = Color(0x66FFFFFF); // white with 40% opacity
  static const Color greyOverlay = Color(0x4D969696); // grey with 30% opacity
  static const Color greyLight = Color(0x80969696); // grey with 50% opacity
  static const Color tealDisabled = Color(0xB30277BD); // teal with 70% opacity
  static const Color tealLight = Color(0x4D0277BD); // teal with 30% opacity
  static const Color tealVeryLight = Color(0x800277BD); // teal with 50% opacity
}
