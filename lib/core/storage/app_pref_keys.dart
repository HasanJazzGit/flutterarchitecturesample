/// Storage keys for AppPref
/// All preference keys should be defined here
///
/// Best Practice:
/// - Use descriptive, namespaced keys to avoid conflicts
/// - Group related keys together
/// - Document the purpose of each key
/// - Never hardcode keys in other files - always use this class
class AppPrefKeys {
  AppPrefKeys._(); // Private constructor to prevent instantiation

  // ==================== Version Keys ====================

  /// Preferences version number
  static const String prefVersion = 'pref_version_1';

  // ==================== Authentication Keys ====================

  /// Authentication token (JWT)
  static const String token = 'auth_token$prefVersion';

  /// Refresh token for token renewal
  static const String refreshToken = 'refresh_token$prefVersion';

  /// User ID
  static const String userId = 'user_id$prefVersion';

  /// Login status (boolean)
  static const String loginStatus = 'login_status$prefVersion';

  /// Last login timestamp (ISO 8601 string)
  static const String lastLoginTime = 'last_login_time$prefVersion';

  /// Session start timestamp (ISO 8601 string)
  static const String sessionStartTime = 'session_start_time$prefVersion';

  // ==================== Theme Keys ====================

  /// Theme mode: 'light', 'dark', or 'system'
  static const String themeMode = 'theme_mode$prefVersion';

  // ==================== Localization Keys ====================

  /// App locale (language code)
  static const String locale = 'app_locale$prefVersion';

  // ==================== Onboarding Keys ====================

  /// Whether onboarding has been completed
  static const String onboardingCompleted = 'onboarding_completed$prefVersion';

  // ==================== Add More Keys Here ====================

  // Example keys (uncomment and use as needed):
  // static const String userEmail = 'user_email$prefVersion';
  // static const String userProfileImage = 'user_profile_image$prefVersion';

}
