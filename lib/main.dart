import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor_setup_helper.dart';
import 'core/di/dependency_injection.dart';
import 'core/l10n/app_localizations.dart';
import 'core/localization/app_localization_service.dart';
import 'core/router/app_router.dart';
import 'core/storage/app_pref.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'features/dashboard/presentation/manager/dashboard_state.dart';

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
    return BlocProvider(
      create: (context) => sl<DashboardCubit>(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode ||
            previous.locale != current.locale,
        builder: (context, state) {
          return MaterialApp.router(
            key: ValueKey('${state.themeMode}_${state.locale.languageCode}'),
            title: AppConfig.appName,
            debugShowCheckedModeBanner: AppConfig.enableDebugFeatures,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: AppRouter.router,
            locale: state.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizationService.supportedLocales,
          );
        },
      ),
    );
  }
}
