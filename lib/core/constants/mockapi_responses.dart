import 'package:flutter/foundation.dart';

/// Mock API responses for development and testing
class MockApiResponses {
  MockApiResponses._(); // Private constructor

  /// Check if mock mode is enabled (debug mode)
  static const bool useMockData = kDebugMode;

  /// Mock login response
  static Map<String, dynamic> get mockLoginResponse => {
    'token': 'mock_jwt_token_12345',
    'userId': 'mock_user_123',
    'user_id': 'mock_user_123', // Alternative key
    'email': 'test@example.com',
    'refreshToken': 'mock_refresh_token_12345',
    'refresh_token': 'mock_refresh_token_12345', // Alternative key
    'expiresIn': 86400, // 24 hours in seconds
    'expires_in': 86400, // Alternative key
    'success': true,
    'message': 'Login successful (Mock)',
  };

  /// Mock error response
  static Map<String, dynamic> get mockErrorResponse => {
    'success': false,
    'message': 'Mock error response',
    'error': 'Invalid credentials',
  };

  /// Mock empty response
  static Map<String, dynamic> get mockEmptyResponse => <String, dynamic>{};
}
