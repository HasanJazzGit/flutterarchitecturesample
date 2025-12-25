/// App route constants
/// All route names should be defined here (without leading "/")
/// Use path property to get the route path with "/"
class AppRoutes {
  AppRoutes._(); // Private constructor

  // Root
  static const String root = '';

  // Splash Route
  static const String splash = 'splash';

  // Auth Routes
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String verifyOtp = 'verify-otp';

  // Home Routes
  static const String home = 'home';
  static const String dashboard = 'dashboard';
  static const String profile = 'profile';
  static const String settings = 'settings';

  // MVVM Test Routes
  static const String mvvmTest = 'mvvm-test';

  // Examples Route
  static const String examples = 'examples';
  static const String shimmerExamples = 'examples/shimmer';

  // Products Route
  static const String products = 'products';

  // Example Clean Architecture Route
  static const String exampleClean = 'example-clean';

  // Example MVVM Architecture Route
  static const String exampleMvvm = 'example-mvvm';


  /// Get route path with leading "/"
  static String path(String route) {
    return route.isEmpty ? '/' : '/$route';
  }
}
