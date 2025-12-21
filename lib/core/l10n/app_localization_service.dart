import 'package:flutter/material.dart';
import '../di/dependency_injection.dart';
import '../preference//app_pref.dart';
import '../preference/app_pref_keys.dart';

class AppLocalizationService {
  AppLocalizationService._();

  static const Locale defaultLocale = Locale('en');
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ur')];

  /// Get saved locale from preferences
  /// Returns default locale if not found (safe default)
  static Locale getSavedLocale() {
    try {
      final localeString = sl<AppPref>().getLocale();
      return Locale(localeString);
    } catch (e) {
      return defaultLocale;
    }
  }

  /// Save locale to preferences
  static Future<bool> setLocale(Locale locale) {
    try {
      return sl<AppPref>().setLocale(locale.languageCode);
    } catch (e) {
      return Future.value(false);
    }
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
