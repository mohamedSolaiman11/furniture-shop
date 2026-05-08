import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'providers/store_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/main_shell.dart';
import 'supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const LuxeApp(),
    ),
  );
}

class LuxeApp extends StatelessWidget {
  const LuxeApp({super.key});

  @override
  Widget build(BuildContext ctx) {
    final settings = ctx.watch<SettingsProvider>();
    
    // إعدادات تجعل الموقع يبدو احترافياً في الانتقالات
    final pageTransitionsTheme = PageTransitionsTheme(
      builders: {
        for (var platform in TargetPlatform.values)
          platform: const FadeUpwardsPageTransitionsBuilder(),
      },
    );

    return MaterialApp(
      title: settings.strings.appName,
      theme: AppTheme.light.copyWith(pageTransitionsTheme: pageTransitionsTheme),
      darkTheme: AppTheme.dark.copyWith(pageTransitionsTheme: pageTransitionsTheme),
      themeMode: settings.themeMode,
      debugShowCheckedModeBanner: false,
      builder: (ctx, child) => Directionality(
        textDirection: settings.textDirection,
        child: child!,
      ),
      home: const MainShell(),
    );
  }
}
