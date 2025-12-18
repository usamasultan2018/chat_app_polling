// lib/core/theme/flex_color_schemes.dart
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFlexSchemes {
  // Custom Text Theme with Inter
  static TextTheme _customTextTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      // Display (Large titles)
      displayLarge: GoogleFonts.inter(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),

      // Headline (Section titles)
      headlineLarge: GoogleFonts.inter(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),

      // Title (Card titles)
      titleLarge: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),

      // Body (Main content)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),

      // Label (Buttons)
      labelLarge: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Light Theme
  static ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.blue,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: _customTextTheme(ThemeData.light().textTheme),
  );

  // Dark Theme
  static ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.blue,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: _customTextTheme(ThemeData.dark().textTheme),
  );
}
