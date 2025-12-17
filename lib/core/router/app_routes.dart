/// App route constants
/// All route names should be defined here (without leading "/")
/// Use path property to get the route path with "/"
class AppRoutes {
  AppRoutes._(); // Private constructor

  // Root
  static const String root = '';

  // Auth Routes
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String verifyOtp = 'verify-otp';

  // Home Routes
  static const String home = 'home';
  static const String profile = 'profile';
  static const String settings = 'settings';

  /// Get route path with leading "/"
  static String path(String route) {
    return route.isEmpty ? '/' : '/$route';
  }
}
