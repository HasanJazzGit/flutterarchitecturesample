import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localization_service.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../features/app/presentation/cubit/app_state.dart';

/// App-level Cubit for managing theme and language
class AppCubit extends Cubit<AppState> {
  final AppPref _appPref;

  AppCubit({AppPref? appPref})
    : _appPref = appPref ?? sl<AppPref>(),
      super(const AppState()) {
    _loadPreferences();
  }

  void _loadPreferences() {
    // Load theme mode
    final themeModeString = _appPref.getThemeMode();
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

  /// Change app theme mode
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

    await _appPref.setThemeMode(themeModeString);
    emit(state.copyWith(themeMode: themeMode));
  }

  /// Change app locale/language
  Future<void> changeLocale(Locale locale) async {
    await AppLocalizationService.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
