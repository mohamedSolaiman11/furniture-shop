import 'package:flutter/material.dart';
import '../l10n/strings.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  String _locale = 'en';

  ThemeMode get themeMode => _themeMode;
  String get locale => _locale;
  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isAr => _locale == 'ar';
  AppStrings get strings => AppStrings(_locale);
  TextDirection get textDirection => isAr ? TextDirection.rtl : TextDirection.ltr;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setLocale(String locale) {
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    _locale = isAr ? 'en' : 'ar';
    notifyListeners();
  }
}