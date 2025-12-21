import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../cubit/app_cubit.dart';
import '../../../../core/flavor/app_config.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/app_localization_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../cubit/app_state.dart';

/// Main application widget
class FlutterSampleApp extends StatelessWidget {
  const FlutterSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AppCubit: Global state (theme, language, app-wide settings)
        BlocProvider(create: (context) => sl<AppCubit>()),
        // AuthCubit: Shared across all auth screens (login, OTP, password recovery, logout)
        // Using lazy singleton ensures same instance is reused, preserving state between navigation
        BlocProvider.value(value: sl<AuthCubit>()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
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
