import 'package:fluttersampleachitecture/core/di/dependency_injection.dart';
import 'package:fluttersampleachitecture/core/storage/encryption_service.dart';

class AppPrefKeys {
  AppPrefKeys._();

  static final _encryption = sl<EncryptionService>();
  static String get _prefVersion => _encryption.obfuscateKey("app_pref_v1");

  static String get token => _encryption.obfuscateKey('auth_token$_prefVersion');
  static String get refreshToken => _encryption.obfuscateKey('refresh_token$_prefVersion');
  static String get userId => _encryption.obfuscateKey('user_id$_prefVersion');
  static String get loginStatus => _encryption.obfuscateKey('login_status$_prefVersion');
  static String get themeMode => _encryption.obfuscateKey('theme_mode$_prefVersion');
  static String get locale => _encryption.obfuscateKey('app_locale$_prefVersion');
  static String get onboardingCompleted => _encryption.obfuscateKey('onboarding_completed$_prefVersion');
  static String get encryptionEnabled => _encryption.obfuscateKey('encryption_enabled$_prefVersion');
  static String get encryptionKey => _encryption.obfuscateKey('encryption_key$_prefVersion');
  static String get encryptionIV => _encryption.obfuscateKey('encryption_iv$_prefVersion');
}
