import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/app/presentation/cubit/app_cubit.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../preference/app_pref.dart';
import '../preference/app_pref_impl.dart';
import '../storage/encryption_service.dart';
import '../utils/connectivity_service.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/example_clean/example_clean_injection.dart';
import '../../features/example_mvvm/example_mvvm_injection.dart';
import '../../features/products/products_injection.dart';

/// Service locator instance
/// Use this to register and retrieve dependencies
final GetIt sl = GetIt.instance;

/// Initialize dependency injection
/// Call this in main() before runApp()
///
/// Note: Encryption can be enabled/configured through AppPref methods
/// after initialization. Use AppPref.initializeEncryption() to set up encryption.
Future<void>  initDependencyInjection() async {
  // Initialize core dependencies
  await _initCore();

  // Initialize feature dependencies
  initAuthInjector();
  initExampleCleanInjector();
  initExampleMvvmInjector();
  initProductsInjector();
  // Add more feature initializations here
  // initProfileInjector();
  // initHomeInjector();
}

/// Initialize core dependencies
Future<void> _initCore() async {

  // Initialize SharedPreferences once
  final sharedPref = await SharedPreferences.getInstance();
  final encryptionService = EncryptionService();
  // Initialize encryption first
  await encryptionService.initialize();
  sl.registerLazySingleton<EncryptionService>(() => encryptionService);
  // Register SharedPreferences as singleton (for use in features)
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);

  // Register KeystoreService for secure key storage

  // Register AppPref as singleton
  // Best Practice: Always use AppPrefEncryptedImpl to support encryption
  // Encryption keys are stored in KeyStore/Keychain (secure storage)
  // Encryption can be enabled/configured through AppPref methods
  // If encryption is disabled, it works like regular SharedPreferences
  sl.registerLazySingleton<AppPref>(
    () => AppPrefImpl(
      encryptionService: sl<EncryptionService>(),
      sharedPref,),
  );

  // Register API Client as singleton for the whole
  // Endpoints are now full URLs (from AppUrls), no baseUrl needed
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register Database as singleton
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Register Connectivity Service as singleton
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Register AppCubit as singleton for app-level state (theme, language)
  sl.registerLazySingleton<AppCubit>(() => AppCubit(appPref: sl<AppPref>()));
}
