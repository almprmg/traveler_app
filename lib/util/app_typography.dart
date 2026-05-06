import 'package:flutter/material.dart';

class AppTypography {
  // Mirror of AppTheme text scale — keep these in sync with AppTheme.
  static const Color primaryTextColor = Color(0xFF0A0B0E);    // AppTheme.textPrimary
  static const Color secondaryTextColor = Color(0xFF353944);  // AppTheme.textSecondary
  static const Color accentTextColor = Color(0xFF353944);     // AppTheme.textSecondary
  static const Color mutedTextColor = Color(0xFF6E7380);      // AppTheme.textTertiary
  static const Color lightTextColor = Color(0xFF9CA3AF);      // AppTheme.secondaryLight
  static const Color whiteTextColor = Color(0xFFFFFFFF);      // AppTheme.textOnPrimary

  // Font Families
  static const String primaryFontFamily = 'Cairo';
  static const String arabicFontFamily = 'Cairo';

  // Font Sizes (matching AppTheme)
  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize48 = 48.0;

  // Font Weights (matching AppTheme)
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // === DISPLAY STYLES ===
  
  // Display Large - Hero sections
  static const TextStyle displayLarge = TextStyle(

    fontSize: fontSize48,
    fontWeight: bold,
    color: primaryTextColor,
    height: 1.1,
    letterSpacing: -0.8,
  );

  // Display Medium - Major headings
  static const TextStyle displayMedium = TextStyle(

    fontSize: fontSize36,
    fontWeight: bold,
    color: primaryTextColor,
    height: 1.2,
    letterSpacing: -0.6,
  );

  // Display Small - Section headings
  static const TextStyle displaySmall = TextStyle(

    fontSize: fontSize32,
    fontWeight: semiBold,
    color: primaryTextColor,
    height: 1.2,
    letterSpacing: -0.4,
  );

  // === HEADLINES ===
  
  // H1 - Main Page Titles
  static const TextStyle h1 = TextStyle(

    fontSize: fontSize28,
    fontWeight: semiBold,
    color: primaryTextColor,
    height: 1.3,
    letterSpacing: -0.3,
  );

  // H2 - Section Titles
  static const TextStyle h2 = TextStyle(

    fontSize: fontSize24,
    fontWeight: semiBold,
    color: primaryTextColor,
    height: 1.3,
    letterSpacing: -0.2,
  );

  // H3 - Card Titles
  static const TextStyle h3 = TextStyle(

    fontSize: fontSize20,
    fontWeight: medium,
    color: primaryTextColor,
    height: 1.4,
    letterSpacing: 0,
  );

  // H4 - Component Titles
  static const TextStyle h4 = TextStyle(

    fontSize: fontSize18,
    fontWeight: medium,
    color: primaryTextColor,
    height: 1.4,
    letterSpacing: 0,
  );

  // H5 - List Item Titles
  static const TextStyle h5 = TextStyle(

    fontSize: fontSize16,
    fontWeight: medium,
    color: primaryTextColor,
    height: 1.4,
    letterSpacing: 0,
  );

  // H6 - Small Titles
  static const TextStyle h6 = TextStyle(

    fontSize: fontSize14,
    fontWeight: medium,
    color: primaryTextColor,
    height: 1.5,
    letterSpacing: 0,
  );

  // === BODY TEXT ===

  // Body Large - Main content
  static const TextStyle bodyLarge = TextStyle(

    fontSize: fontSize16,
    fontWeight: regular,
    color: primaryTextColor,
    height: 1.5,
    letterSpacing: 0,
  );

  // Body Medium - Regular content
  static const TextStyle bodyMedium = TextStyle(

    fontSize: fontSize14,
    fontWeight: regular,
    color: secondaryTextColor,
    height: 1.5,
    letterSpacing: 0,
  );

  // Body Small - Secondary content
  static const TextStyle bodySmall = TextStyle(

    fontSize: fontSize12,
    fontWeight: regular,
    color: mutedTextColor,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // === LABELS ===

  // Label Large - Form labels
  static const TextStyle labelLarge = TextStyle(

    fontSize: fontSize14,
    fontWeight: medium,
    color: primaryTextColor,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // Label Medium - Input labels
  static const TextStyle labelMedium = TextStyle(

    fontSize: fontSize12,
    fontWeight: medium,
    color: secondaryTextColor,
    height: 1.3,
    letterSpacing: 0.2,
  );

  // Label Small - Helper text
  static const TextStyle labelSmall = TextStyle(

    fontSize: fontSize10,
    fontWeight: medium,
    color: mutedTextColor,
    height: 1.3,
    letterSpacing: 0.3,
  );

  // === BUTTONS ===

  // Button Large
  static const TextStyle buttonLarge = TextStyle(

    fontSize: fontSize16,
    fontWeight: semiBold,
    color: whiteTextColor,
    height: 1.25,
    letterSpacing: 0.3,
  );

  // Button Medium
  static const TextStyle buttonMedium = TextStyle(

    fontSize: fontSize14,
    fontWeight: semiBold,
    color: whiteTextColor,
    height: 1.25,
    letterSpacing: 0.2,
  );

  // Button Small
  static const TextStyle buttonSmall = TextStyle(

    fontSize: fontSize12,
    fontWeight: semiBold,
    color: whiteTextColor,
    height: 1.25,
    letterSpacing: 0.2,
  );

  // === SPECIALIZED STYLES ===

  // Caption - Image captions, timestamps
  static const TextStyle caption = TextStyle(

    fontSize: fontSize12,
    fontWeight: regular,
    color: mutedTextColor,
    height: 1.4,
    letterSpacing: 0.2,
  );

  // Overline - Section headers, categories
  static const TextStyle overline = TextStyle(

    fontSize: fontSize10,
    fontWeight: semiBold,
    color: secondaryTextColor,
    height: 1.3,
    letterSpacing: 1.5,
  );

  // === COLOR VARIANTS ===

  // Helper methods for color variants
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  // === STATUS COLORS ===
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);  
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);


  // Success variants
  static TextStyle get successText => bodyMedium.copyWith(color: successColor);
  static TextStyle get successLabel => labelMedium.copyWith(color: successColor);
  
  // Warning variants  
  static TextStyle get warningText => bodyMedium.copyWith(color: warningColor);
  static TextStyle get warningLabel => labelMedium.copyWith(color: warningColor);
  
  // Error variants
  static TextStyle get errorText => bodyMedium.copyWith(color: errorColor);
  static TextStyle get errorLabel => labelMedium.copyWith(color: errorColor);
  
  // Info variants
  static TextStyle get infoText => bodyMedium.copyWith(color: infoColor);
  static TextStyle get infoLabel => labelMedium.copyWith(color: infoColor);

  // === TEXT THEMES FOR MATERIAL ===

  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    titleLarge: h4,
    titleMedium: h5,
    titleSmall: h6,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}