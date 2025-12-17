import '../api_client.dart';

class AuthApiService {
  final ApiClient apiClient;

  AuthApiService(this.apiClient);

  /// Login endpoint
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await apiClient.post(
      '/login',
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  /// Logout endpoint
  Future<Map<String, dynamic>> logout() async {
    return await apiClient.post('/logout');
  }

  /// Refresh token endpoint
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    return await apiClient.post(
      '/refresh',
      body: {
        'refreshToken': refreshToken,
      },
    );
  }
}

