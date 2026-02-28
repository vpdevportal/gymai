import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary palette
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF9D97FF);
  static const primaryDark = Color(0xFF3D35CC);

  // Accent
  static const accent = Color(0xFF00D4AA);

  // Neutrals
  static const background = Color(0xFF0F0F1A);
  static const surface = Color(0xFF1A1A2E);
  static const surfaceVariant = Color(0xFF252540);
  static const onBackground = Color(0xFFF5F5FF);
  static const onSurface = Color(0xFFE0E0F0);
  static const onSurfaceMuted = Color(0xFF9090B0);

  // Semantic
  static const error = Color(0xFFFF5252);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
}

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
        TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
        TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.onBackground,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.onSurfaceMuted),
      prefixIconColor: AppColors.onSurfaceMuted,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.onBackground,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColors.onBackground,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: AppColors.onBackground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: AppColors.onSurface, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.onSurface, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12),
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
