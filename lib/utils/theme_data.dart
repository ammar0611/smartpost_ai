import 'package:flutter/material.dart';
import 'package:smartpost_ai/values/colors.dart' as app_colors;

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'OpenSans',
      colorScheme: ColorScheme.light(
        primary: app_colors.primaryColor,
        secondary: app_colors.secondaryColor,
        surface: app_colors.bgPrimary,
        error: app_colors.errorColor,
        onPrimary: app_colors.white,
        onSecondary: app_colors.white,
        onSurface: app_colors.textPrimary,
        onError: app_colors.white,
      ),
      scaffoldBackgroundColor: app_colors.bgSecondary,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: app_colors.white,
        foregroundColor: app_colors.textPrimary,
        iconTheme: IconThemeData(color: app_colors.textPrimary),
        titleTextStyle: TextStyle(
          color: app_colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'OpenSans',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: app_colors.bgCard,
        shadowColor: app_colors.black.withOpacity(0.1),
      ),
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: app_colors.primaryColor,
          foregroundColor: app_colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'OpenSans',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: app_colors.grey100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: app_colors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: app_colors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: app_colors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: app_colors.errorColor),
        ),
        hintStyle: TextStyle(
          color: app_colors.textLight,
          fontSize: 14,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: app_colors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: app_colors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: app_colors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: app_colors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: app_colors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: app_colors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: app_colors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: app_colors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: app_colors.textLight,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: app_colors.textPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: app_colors.grey300,
        thickness: 1,
        space: 1,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: app_colors.primaryColor,
        foregroundColor: app_colors.white,
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'OpenSans',
      colorScheme: ColorScheme.dark(
        primary: app_colors.primaryColor,
        secondary: app_colors.secondaryColor,
        surface: app_colors.bgDark,
        error: app_colors.errorColor,
        onPrimary: app_colors.white,
        onSecondary: app_colors.white,
        onSurface: app_colors.white,
        onError: app_colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF16213E),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: app_colors.bgDark,
        foregroundColor: app_colors.white,
        iconTheme: const IconThemeData(color: app_colors.white),
        titleTextStyle: const TextStyle(
          color: app_colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'OpenSans',
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: app_colors.bgDark,
      ),
    );
  }
}
