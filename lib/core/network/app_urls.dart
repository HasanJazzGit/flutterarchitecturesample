/// Centralized API endpoints for the application
class AppUrls {
  AppUrls._();

  // Auth endpoints
  static const String login = '/login';
  static const String logout = '/logout';
  static const String refreshToken = '/refresh';
  static const String verifyOtp = '/verify-otp';

  // Products endpoints
  static const String products = '/products';
  static String productById(int id) => '/products/$id';
  static String productsByCategory(String category) =>
      '/products/category/$category';
  static String searchProducts(String query) => '/products/search?q=$query';
}
