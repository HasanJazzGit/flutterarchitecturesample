import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/dashboard/dashboard_injection.dart';
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
  initDashboardInjector();
  initProductsInjector();
  // Add more feature initializations here
  // initProfileInjector();
  // initHomeInjector();
}

/// Initialize core dependencies
Future<void> _initCore() async {
  // Register API Client as singleton for the whole app
  // Using dummyjson.com for products API
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: 'https://dummyjson.com'),
  );
}
