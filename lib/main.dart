import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor_setup_helper.dart';
import 'core/di/dependency_injection.dart';
import 'core/router/app_router.dart';
import 'core/storage/app_pref.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor-specific configurations
  FlavorSetupHelper.initialize();
  FlavorSetupHelper.printFlavorConfig();

  // Initialize app preferences
  await AppPref.init();

  // Initialize dependency injection
  await initDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: AppConfig.enableDebugFeatures,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
        // Add more locales as needed
      ],
    );
  }
}
