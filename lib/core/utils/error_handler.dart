import '../network/api_client.dart';

class ErrorHandler {
  /// Get user-friendly error message from exception
  static String getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else if (error is String) {
      return error;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Check if error is a network error
  static bool isNetworkError(dynamic error) {
    return error is ApiException &&
        (error.statusCode == 0 ||
            error.message.toLowerCase().contains('network') ||
            error.message.toLowerCase().contains('connection'));
  }

  /// Check if error is an authentication error
  static bool isAuthError(dynamic error) {
    return error is ApiException &&
        (error.statusCode == 401 || error.statusCode == 403);
  }

  /// Check if error is a server error
  static bool isServerError(dynamic error) {
    return error is ApiException && error.statusCode >= 500;
  }

  /// Check if error is a client error (4xx)
  static bool isClientError(dynamic error) {
    return error is ApiException &&
        error.statusCode >= 400 &&
        error.statusCode < 500;
  }
}
