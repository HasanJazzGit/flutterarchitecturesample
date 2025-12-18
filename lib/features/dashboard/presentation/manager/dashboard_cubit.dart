import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localization_service.dart';
import '../../../../core/storage/app_pref.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState.initial()) {
    _loadPreferences();
  }

  void _loadPreferences() {
    // Load theme mode
    final themeModeString = AppPref.getThemeMode();
    ThemeMode themeMode;
    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    // Load locale
    final locale = AppLocalizationService.getSavedLocale();

    emit(state.copyWith(themeMode: themeMode, locale: locale));
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    String themeModeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    await AppPref.setThemeMode(themeModeString);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> changeLocale(Locale locale) async {
    await AppLocalizationService.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
