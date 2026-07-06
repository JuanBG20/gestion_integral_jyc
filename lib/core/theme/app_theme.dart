import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
        surfaceContainerHighest: AppColors.surface,
        onSurfaceVariant: AppColors.onBackground,
        outline: AppColors.outline,
      ),

      textTheme: TextTheme(
        // Title
        titleLarge: GoogleFonts.cabin(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),

        // Section Title
        titleMedium: GoogleFonts.cabin(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        /*

        // Card Title
        titleSmall: GoogleFonts.cabin(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ), */

        // Subtitle
        bodyLarge: GoogleFonts.cabin(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onBackground,
        ),

        // Paragraph
        bodyMedium: GoogleFonts.cabin(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),

        // Extra info
        bodySmall: GoogleFonts.cabin(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.onBackground.withValues(alpha: 0.8),
        ),

        /*labelSmall: GoogleFonts.cabin(
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: AppColors.onBackground,
        ),

        labelMedium: GoogleFonts.cabin(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.onBackground,
        ), */
      ),

      // Primary Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          padding: const EdgeInsets.all(24),
          side: const BorderSide(color: AppColors.primary),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
      ),

      // Secondary Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.all(24),
          side: const BorderSide(color: AppColors.outline),
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
      ),

      // Input Field
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        hintStyle: TextStyle(
          color: AppColors.onBackground.withValues(alpha: 0.5),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
