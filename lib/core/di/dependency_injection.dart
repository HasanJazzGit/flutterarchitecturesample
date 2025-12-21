import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/app/presentation/cubit/app_cubit.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../storage/app_pref.dart';
import '../storage/app_pref_impl.dart';
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
Future<void> initDependencyInjection() async {
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

  // Register SharedPreferences as singleton (for use in features)
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);

  // Register AppPref as singleton
  // Best Practice: Register abstract interface, not concrete implementation
  // Pass SharedPreferences instance to implementation
  sl.registerLazySingleton<AppPref>(() => AppPrefImpl(sharedPref));

  // Register API Client as singleton for the whole app
  // Using dummyjson.com for products API
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: 'https://dummyjson.com'),
  );

  // Register Database as singleton
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Register Connectivity Service as singleton
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Register AppCubit as singleton for app-level state (theme, language)
  sl.registerLazySingleton<AppCubit>(() => AppCubit(appPref: sl<AppPref>()));
}
