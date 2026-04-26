import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2C2C2C);
  static const Color secondaryColor = Color(0xFF8D6E63);
  static const Color backgroundColor = Color(0xFFFDFBF8);
  static const Color accentColor = Color(0xFFD4AF37);
  
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // نستخدم خط Cairo لأنه يدعم العربية بشكل أساسي واحترافي
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        background: backgroundColor,
        surface: Colors.white,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      // هذا السطر يمنع ظهور المربعات باستخدام خط النظام الافتراضي كبديل سريع
      fontFamily: GoogleFonts.cairo().fontFamily, 
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        displayMedium: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        bodyLarge: const TextStyle(color: Color(0xFF333333)),
        bodyMedium: const TextStyle(color: Color(0xFF757575)),
      ),
      elevatedButtonTheme: _elevatedButtonTheme(primaryColor, Colors.white),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
        background: darkBackground,
        surface: darkSurface,
        primary: accentColor,
        secondary: const Color(0xFFA1887F),
      ),
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: const TextStyle(color: Colors.white70),
        bodyMedium: const TextStyle(color: Colors.white54),
      ),
      elevatedButtonTheme: _elevatedButtonTheme(accentColor, Colors.black),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color bg, Color fg) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
