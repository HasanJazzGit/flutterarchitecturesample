import '../flavor/app_config.dart';

/// Centralized API endpoints for the application
/// Supports both full URLs (with baseUrl from flavor) and 3rd party full URLs
class AppUrls {
  AppUrls._();

  /// Get base URL from flavor configuration
  static String get baseUrl => AppConfig.getBaseUrl();

  // ============================================
  // Auth endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Login endpoint - full URL using baseUrl from flavor
  static String get login => '$baseUrl/login';

  /// Sign in endpoint - full URL with custom path
  static String get signIn => '$baseUrl/login_ww';

  /// Logout endpoint - full URL
  static String get logout => '$baseUrl/logout';

  /// Refresh token endpoint - full URL
  static String get refreshToken => '$baseUrl/refresh';

  /// Verify OTP endpoint - full URL
  static String get verifyOtp => '$baseUrl/verify-otp';

  // ============================================
  // Products endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Products list endpoint - full URL
  static String get products => '$baseUrl/products';

  /// Product by ID endpoint - full URL
  static String productById(int id) => '$baseUrl/products/$id';

  /// Products by category endpoint - full URL
  static String productsByCategory(String category) =>
      '$baseUrl/products/category/$category';

  /// Search products endpoint - full URL
  static String searchProducts(String query) =>
      '$baseUrl/products/search?q=$query';

  // ============================================
  // 3rd Party Integration Support (Full URLs)
  // ============================================

  /// Use full URL for 3rd party integrations
  /// Example: AppUrls.thirdPartyUrl('https://api.thirdparty.com/endpoint')
  /// This returns the URL as-is for complete 3rd party integration
  static String thirdPartyUrl(String fullUrl) => fullUrl;

  /// Google API endpoint - full 3rd party URL
  static String get googleApi => 'https://www.googleapis.com';

  /// Facebook API endpoint - full 3rd party URL
  static String get facebookApi => 'https://graph.facebook.com';

  /// Custom 3rd party endpoint builder
  /// Example: AppUrls.thirdPartyEndpoint('https://api.example.com', '/v1/data')
  static String thirdPartyEndpoint(String thirdPartyBaseUrl, String path) {
    // Remove trailing slash from baseUrl if present
    final cleanBaseUrl = thirdPartyBaseUrl.endsWith('/')
        ? thirdPartyBaseUrl.substring(0, thirdPartyBaseUrl.length - 1)
        : thirdPartyBaseUrl;
    // Add leading slash to path if not present
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$cleanBaseUrl$cleanPath';
  }

  // ============================================
  // Helper Methods
  // ============================================

  /// Check if URL is a full URL (starts with http:// or https://)
  static bool isFullUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Build full URL from relative path using baseUrl from flavor
  /// If path is already a full URL, returns it as-is
  static String buildUrl(String path) {
    // If already a full URL, return as is (for 3rd party)
    if (isFullUrl(path)) {
      return path;
    }
    // Otherwise, append to baseUrl from flavor
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$cleanPath';
  }

  /// Get relative path from full URL (for backward compatibility if needed)
  /// Example: '/login' from 'https://api.example.com/login'
  static String getRelativePath(String fullUrl) {
    if (!isFullUrl(fullUrl)) {
      return fullUrl; // Already relative
    }
    try {
      final uri = Uri.parse(fullUrl);
      return uri.path + (uri.query.isNotEmpty ? '?${uri.query}' : '');
    } catch (e) {
      return fullUrl; // Return as-is if parsing fails
    }
  }
}
