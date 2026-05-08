import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Shared
  static const gold = Color(0xFFC9A84C);
  static const goldLight = Color(0xFFE8D08A);
  static const error = Color(0xFFE05252);
  static const success = Color(0xFF52C07A);

  // Dark mode
  static const darkBg = Color(0xFF1A1A1A);
  static const darkBgDeep = Color(0xFF111111);
  static const darkSurface = Color(0xFF242424);
  static const darkSurface2 = Color(0xFF2E2E2E);
  static const darkBorder = Color(0xFF3A3530);
  static const darkText = Color(0xFFF0EDE6);
  static const darkMuted = Color(0xFF9A9080);

  // Light mode
  static const lightBg = Color(0xFFF7F4EF);
  static const lightBgDeep = Color(0xFFEDE8E0);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF2EDE4);
  static const lightBorder = Color(0xFFD9D0C0);
  static const lightText = Color(0xFF1A1410);
  static const lightMuted = Color(0xFF7A6F60);
}

TextTheme _buildTextTheme(Color primary, Color muted) =>
    GoogleFonts.cormorantGaramondTextTheme(TextTheme(
      displayLarge: TextStyle(color: primary, fontSize: 36, letterSpacing: 4, fontWeight: FontWeight.w600),
      displayMedium: TextStyle(color: primary, fontSize: 28, letterSpacing: 3),
      headlineLarge: const TextStyle(color: AppColors.gold, fontSize: 22, letterSpacing: 4, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: primary, fontSize: 18, letterSpacing: 2),
      titleLarge: TextStyle(color: primary, fontSize: 16, letterSpacing: 1),
      bodyLarge: TextStyle(color: primary, fontSize: 15),
      bodyMedium: TextStyle(color: muted, fontSize: 13),
      labelLarge: const TextStyle(color: AppColors.darkBgDeep, fontSize: 13, letterSpacing: 2, fontWeight: FontWeight.w700),
    ));

class AppTheme {
  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    bg: AppColors.darkBg,
    surface: AppColors.darkSurface,
    border: AppColors.darkBorder,
    text: AppColors.darkText,
    muted: AppColors.darkMuted,
    appBarBg: AppColors.darkBgDeep,
    navBg: AppColors.darkBgDeep,
    inputFill: AppColors.darkSurface,
    cardColor: AppColors.darkSurface,
    sliderInactive: AppColors.darkBorder,
    dropdownBg: AppColors.darkSurface2,
  );

  static ThemeData get light => _build(
    brightness: Brightness.light,
    bg: AppColors.lightBg,
    surface: AppColors.lightSurface,
    border: AppColors.lightBorder,
    text: AppColors.lightText,
    muted: AppColors.lightMuted,
    appBarBg: AppColors.lightBgDeep,
    navBg: AppColors.lightBgDeep,
    inputFill: AppColors.lightSurface,
    cardColor: AppColors.lightSurface,
    sliderInactive: AppColors.lightBorder,
    dropdownBg: AppColors.lightSurface2,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color border,
    required Color text,
    required Color muted,
    required Color appBarBg,
    required Color navBg,
    required Color inputFill,
    required Color cardColor,
    required Color sliderInactive,
    required Color dropdownBg,
  }) =>
      ThemeData(
        brightness: brightness,
        scaffoldBackgroundColor: bg,
        primaryColor: AppColors.gold,
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: AppColors.gold,
          onPrimary: AppColors.darkBgDeep,
          secondary: AppColors.goldLight,
          onSecondary: AppColors.darkBgDeep,
          error: AppColors.error,
          onError: Colors.white,
          surface: surface,
          onSurface: text,
        ),
        textTheme: _buildTextTheme(text, muted),
        appBarTheme: AppBarTheme(
          backgroundColor: appBarBg,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.gold),
          titleTextStyle: const TextStyle(
            color: AppColors.gold, fontSize: 16, letterSpacing: 4,
            fontWeight: FontWeight.w600, fontFamily: 'Cormorant Garamond',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.darkBgDeep,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            textStyle: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w700, fontSize: 12),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gold,
            side: const BorderSide(color: AppColors.gold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            textStyle: const TextStyle(letterSpacing: 2, fontSize: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputFill,
          border: OutlineInputBorder(borderSide: BorderSide(color: border), borderRadius: BorderRadius.circular(2)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: border), borderRadius: BorderRadius.circular(2)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold), borderRadius: BorderRadius.all(Radius.circular(2))),
          hintStyle: TextStyle(color: muted, fontSize: 13),
          labelStyle: TextStyle(color: muted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        cardTheme: CardThemeData(
          color: cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: border),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.gold,
          inactiveTrackColor: sliderInactive,
          thumbColor: AppColors.gold,
          overlayColor: AppColors.gold.withOpacity(0.15),
        ),
        dividerColor: border,
        iconTheme: IconThemeData(color: muted),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: navBg,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: muted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: border)),
        ),
      );
}