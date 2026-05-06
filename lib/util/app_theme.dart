import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_typography.dart';

class AppTheme {
  static const Color black = Color(0xFF000000);
  // Only primary + sky gradient are blue — vibrant badge blue, dark enough for white text.
  static const Color primary = Color(0xFF0E7AD8);
  static const Color primaryLight = Color(0xFF4FA6EE);
  static const Color primaryDark = Color(0xFF0A60AE);

  // Everything else lives on a calm, bold gray scale.
  static const Color secondary = Color(0xFF6B7280);
  static const Color secondaryLight = Color(0xFF9CA3AF);
  static const Color secondaryDark = Color(0xFF4B5563);

  static const Color background = Color(0xFFEEF0F3);
  static const Color backgroundLight = Color(0xFFF6F7F9);
  static const Color backgroundDark = Color(0xFFDDE0E5);
  // Sky gradient stops — calm sky blue fading to a near-white haze.
  static const Color skyTop = Color(0xFF7FBBDD);
  static const Color skyBottom = Color(0xFFD9E8F2);

  // Comfortable neutral text scale: near-black → dark gray → medium gray.
  static const Color textPrimary = Color(0xFF0A0B0E);
  static const Color textSecondary = Color(0xFF353944);
  static const Color textTertiary = Color(0xFF6E7380);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF6B8E7A);
  static const Color warning = Color(0xFFB8945F);
  static const Color error = Color(0xFFB85C5C);
  // Info reuses the sky primary so accent blues stay consistent.
  static const Color info = Color(0xFF0E7AD8);

  static const Color border = Color(0xFFDDE1E7);
  static const Color borderMedium = Color(0xFFC5CAD3);
  static const Color borderDark = Color(0xFFA0A7B3);

  static const Color shimmerBase = Color(0xFFE3E5EA);
  static const Color shimmerHighlight = Color(0xFFF1F2F5);

  static const Color white = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x00000000);
  // Shadows removed across the app for a flat, modern look.
  static List<BoxShadow> get lightShadow => const [];
  static const Color cardBorder = Color(0xFFE2E5EA);

  static const Color gold = Color(0xFF9C8554);
  static const Color deepBlue = Color(0xFF0A60AE);
  static const Color total = Color(0xFFEDEFF2);

  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radiusPill = 999.0;

  static const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  static String get fontFamily {
    final locale = Get.locale;
    if (locale != null &&
        (locale.languageCode == 'ar' || locale.languageCode == 'ur')) {
      return 'Cairo';
    }
    return 'Roboto';
  }

  static ThemeData get theme {
    return ThemeData(
      fontFamily: fontFamily,
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: primary,
            brightness: Brightness.light,
          ).copyWith(
            primary: primary,
            onPrimary: textOnPrimary,
            secondary: secondary,
            surface: background,
            onSurface: textPrimary,
            error: error,
          ),
      scaffoldBackgroundColor: background,
      textTheme: AppTypography.textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundLight,
        foregroundColor: textPrimary,
        titleTextStyle: AppTypography.h4,
        toolbarTextStyle: AppTypography.bodyMedium,
        iconTheme: IconThemeData(color: textSecondary, size: 24),
        systemOverlayStyle: systemUiOverlayStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textOnPrimary,
          textStyle: AppTypography.buttonMedium.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing32,
            vertical: spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          backgroundColor: white,
          textStyle: AppTypography.buttonMedium.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
          ),
          side: const BorderSide(color: cardBorder, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: AppTypography.buttonMedium.copyWith(
            fontFamily: fontFamily,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: AppTypography.labelLarge,
        hintStyle: AppTypography.withColor(
          AppTypography.bodyMedium,
          textTertiary,
        ),
        helperStyle: AppTypography.labelSmall,
        errorStyle: AppTypography.withColor(AppTypography.labelSmall, error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(color: primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing20,
          vertical: spacing16,
        ),
        filled: true,
        fillColor: white,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: spacing4, horizontal: 0),
        color: white,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppTypography.h5,
        subtitleTextStyle: AppTypography.bodySmall,
        leadingAndTrailingTextStyle: AppTypography.labelMedium,
        dense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius8),
        ),
        tileColor: backgroundLight,
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: AppTypography.h2,
        contentTextStyle: AppTypography.bodyLarge,
        backgroundColor: backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius16),
        ),
        elevation: 8,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius24)),
        ),
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: AppTypography.withColor(
          AppTypography.bodyMedium,
          textOnPrimary,
        ),
        actionTextColor: primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius8),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 0.5,
        space: 1,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius4),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return textTertiary;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primary.withValues(alpha: 0.3);
          }
          return border;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: border,
        circularTrackColor: border,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: textOnPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: backgroundLight,
        indicatorColor: primary.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(AppTypography.labelSmall),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundLight,
        selectedItemColor: primary,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static Color get primaryWithOpacity => primary.withValues(alpha: 0.1);
  static Color get successWithOpacity => success.withValues(alpha: 0.1);
  static Color get warningWithOpacity => warning.withValues(alpha: 0.1);
  static Color get errorWithOpacity => error.withValues(alpha: 0.1);
  static Color get infoWithOpacity => info.withValues(alpha: 0.1);

  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get headerGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundLight, backgroundDark],
  );

  static LinearGradient get grayBackgroundGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundLight, background],
  );

  static List<BoxShadow> get mediumShadow => const [];
  static List<BoxShadow> get heavyShadow => const [];

  // Multi-stop sky: deeper top, mid-day haze, near-white horizon.
  static LinearGradient get skyGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, skyTop, skyBottom],
    stops: [0.0, 0.55, 1.0],
  );
}

class AppScreenWrapper extends StatelessWidget {
  final Widget child;
  final SystemUiOverlayStyle? customOverlayStyle;

  const AppScreenWrapper({
    super.key,
    required this.child,
    this.customOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: customOverlayStyle ?? AppTheme.systemUiOverlayStyle,
      child: child,
    );
  }
}
