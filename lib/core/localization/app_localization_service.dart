import 'package:flutter/material.dart';
import '../storage/app_pref.dart';

class AppLocalizationService {
  AppLocalizationService._();

  static const String _localeKey = 'app_locale';
  static const Locale defaultLocale = Locale('en');
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ur')];

  /// Get saved locale from preferences
  static Locale getSavedLocale() {
    final localeString = AppPref.getStringOrDefault(_localeKey, 'en');
    return Locale(localeString);
  }

  /// Save locale to preferences
  static Future<bool> setLocale(Locale locale) {
    return AppPref.setString(_localeKey, locale.languageCode);
  }

  /// Get locale name for display
  static String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ur':
        return 'اردو';
      default:
        return locale.languageCode;
    }
  }

  /// Check if locale is RTL
  static bool isRTL(Locale locale) {
    return locale.languageCode == 'ur';
  }
}
