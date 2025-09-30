import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette (matching the phone mockups exactly)
  static const Color backgroundPrimary = Color(0xFF1A1A1A);
  static const Color backgroundSecondary = Color(0xFF1A1C1C);
  static const Color backgroundTertiary = Color(0xFF2D3030);
  
  static const Color textPrimary = Color(0xFFF4F4F5); // zinc-100
  static const Color textSecondary = Color(0xFFA1A1AA); // zinc-400
  static const Color textTertiary = Color(0xFF71717A); // zinc-500
  
  static const Color accentPrimary = Color(0xFF11D4C1); // Exact teal from mockups
  static const Color accentSecondary = Color(0xFF0FB8A8);
  static const Color accentTertiary = Color(0xFF0D9B8C);
  static const Color accentWarm = Color(0xFFFF6B6B);
  static const Color accentCoral = Color(0xFFFF7043);
  
  static const Color surfaceContainer = Color(0x80242424); // #242424 with opacity
  static const Color surfaceContainerHigh = Color(0xFF2D3030);
  static const Color surfaceContainerHighest = Color(0xFF3F3F46);
  
  // Additional colors from phone mockups
  static const Color borderColor = Color(0xFF404040); // zinc-800 - borders
  static const Color checkboxBorder = Color(0xFF11D4C1); // Checkbox border
  static const Color checkboxUnchecked = Color(0xFF71717A); // zinc-500
  static const Color amberAccent = Color(0xFFFBBF24); // amber-400 for streak messages
  
  // Typography
  static const String fontFamily = 'Plus Jakarta Sans';
  
  // Spacing
  static const double spaceXS = 8.0;
  static const double spaceSM = 16.0;
  static const double spaceMD = 24.0;
  static const double spaceLG = 32.0;
  static const double spaceXL = 48.0;
  static const double space2XL = 64.0;
  static const double space3XL = 96.0;
  
  // Border Radius
  static const double radiusXS = 6.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0;
  static const double radiusXL = 32.0;
  static const double radius2XL = 40.0;
  static const double radiusPill = 9999.0;
  
  // Shadows
  static const List<BoxShadow> shadowSM = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static const List<BoxShadow> shadowMD = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
  
  static const List<BoxShadow> shadowLG = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];
  
  static const List<BoxShadow> shadowXL = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];
  
  // Animation Durations
  static const Duration durationShort1 = Duration(milliseconds: 50);
  static const Duration durationShort2 = Duration(milliseconds: 100);
  static const Duration durationShort3 = Duration(milliseconds: 150);
  static const Duration durationShort4 = Duration(milliseconds: 200);
  static const Duration durationMedium1 = Duration(milliseconds: 250);
  static const Duration durationMedium2 = Duration(milliseconds: 300);
  static const Duration durationMedium3 = Duration(milliseconds: 350);
  static const Duration durationMedium4 = Duration(milliseconds: 400);
  static const Duration durationLong1 = Duration(milliseconds: 450);
  static const Duration durationLong2 = Duration(milliseconds: 500);
  static const Duration durationLong3 = Duration(milliseconds: 550);
  static const Duration durationLong4 = Duration(milliseconds: 600);
  
  // Curves
  static const Curve easingStandard = Curves.easeInOut;
  static const Curve easingEmphasized = Curves.easeOutCubic;
  static const Curve easingDecelerated = Curves.easeOut;
  static const Curve easingAccelerated = Curves.easeIn;
  
  // Text Styles
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 88.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.01,
    color: textPrimary,
  );
  
  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
    fontSize: 64.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.01,
    color: textPrimary,
  );
  
  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
    fontSize: 44.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: textPrimary,
  );
  
  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: textPrimary,
  );
  
  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
    fontSize: 26.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: textPrimary,
  );
  
  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: textPrimary,
  );
  
  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: textPrimary,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: textPrimary,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: textPrimary,
  );
  
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: textSecondary,
  );
  
  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: textTertiary,
  );
  
  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundPrimary,
      colorScheme: const ColorScheme.dark(
        primary: accentPrimary,
        secondary: accentSecondary,
        surface: backgroundSecondary,
        onPrimary: backgroundPrimary,
        onSecondary: backgroundPrimary,
        onSurface: textPrimary,
        error: accentCoral,
      ),
      textTheme: TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundPrimary,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimary,
          foregroundColor: backgroundPrimary,
          elevation: 4,
          shadowColor: const Color(0x4D000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXL,
            vertical: spaceMD,
          ),
          textStyle: bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPrimary,
          textStyle: bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(
            color: surfaceContainerHigh,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(
            color: surfaceContainerHigh,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(
            color: accentPrimary,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceSM,
        ),
        hintStyle: bodyLarge.copyWith(
          color: textTertiary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer,
        elevation: 2,
        shadowColor: const Color(0x4D000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
        ),
      ),
    );
  }
}
