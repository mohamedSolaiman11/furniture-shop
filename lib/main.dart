import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:furniture_store/home_page.dart';
import 'package:furniture_store/theme.dart';

void main() {
  runApp(const FurnitureApp());
}

class FurnitureApp extends StatefulWidget {
  const FurnitureApp({super.key});

  // جعل الحالة عامة (Public) لتمكين الوصول إليها من ملفات أخرى
  static FurnitureAppState of(BuildContext context) =>
      context.findAncestorStateOfType<FurnitureAppState>()!;

  @override
  State<FurnitureApp> createState() => FurnitureAppState();
}

class FurnitureAppState extends State<FurnitureApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' معرض الأثاث الفاخر',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
      ],
      locale: const Locale('ar', 'AE'),
      home: const HomePage(),
    );
  }
}
