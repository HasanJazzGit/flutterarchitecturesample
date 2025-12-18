import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_urls.dart';
import '../models/login_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        AppUrls.login,
        body: {'email': email, 'password': password},
      );

      // Validate response structure
      if (response.isEmpty) {
        throw Exception('Empty response received');
      }

      // Check for success field if present
      if (response.containsKey('success')) {
        final success = response['success'] as bool?;
        if (success == false) {
          final message = response['message'] as String? ?? 'Login failed';
          throw Exception(message);
        }
      }

      return LoginResponse.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await apiClient.post(AppUrls.logout);

      // Check for success field if present
      if (response.containsKey('success')) {
        final success = response['success'] as bool?;
        if (success == false) {
          final message = response['message'] as String? ?? 'Logout failed';
          throw Exception(message);
        }
      }
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
