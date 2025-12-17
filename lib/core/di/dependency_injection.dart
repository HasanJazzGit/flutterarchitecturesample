import 'package:get_it/get_it.dart';
import '../../features/auth/auth_injection.dart';

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
  // Add more feature initializations here
  // initProfileInjector();
  // initHomeInjector();
}

/// Initialize core dependencies
Future<void> _initCore() async {
  // Core services are initialized here if needed
  // Example: Network clients, storage services, etc.
}
