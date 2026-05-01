import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_typography.dart';

class AppTheme {
  static const Color black = Color(0xFF000000);
  static const Color primary = Color(0xFF1750BF);
  static const Color primaryLight = Color(0xFF4294FF);
  static const Color primaryDark = Color.fromARGB(255, 27, 73, 201);

  static const Color secondary = Color(0xFF64748B);
  static const Color secondaryLight = Color(0xFF94A3B8);
  static const Color secondaryDark = Color(0xFF475569);

  static const Color background = Color(0xFFF8F8F8);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFFEEEEEE);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color.fromARGB(255, 0, 190, 73);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color border = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color borderDark = Color.fromARGB(255, 162, 178, 201);

  static const Color shimmerBase = Color(0xFFEBEBEB);
  static const Color shimmerHighlight = Color(0xFFF4F4F4);

  static const Color white = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x1A000000);
  static List<BoxShadow> get lightShadow => [
    BoxShadow(color: shadow, blurRadius: 10, offset: const Offset(0, 4)),
  ];

  static const Color gold = Color(0xFFB58E2E);
  static const Color deepBlue = Color(0xFF1E40AF);
  static const Color total = Color(0xFFEEF2FF);

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
          ),
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          backgroundColor: backgroundLight,
          textStyle: AppTypography.buttonMedium.copyWith(
            fontFamily: fontFamily,
          ),
          side: const BorderSide(color: border, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius8),
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
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: error, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius12),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        filled: true,
        fillColor: white,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius12),
          side: const BorderSide(color: border, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(vertical: spacing4, horizontal: 0),
        color: backgroundLight,
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

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get heavyShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
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
