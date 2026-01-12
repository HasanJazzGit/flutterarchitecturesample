import '../../../../core/constants/mockapi_responses.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_urls.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../models/login_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<LoginResponse> login({required LoginParams params}) async {
    try {
      // Check if mock mode is enabled (kDebugMode)
      if (MockApiResponses.useMockData) {
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 500));

        // Return mock response
        final mockResponse = MockApiResponses.mockLoginResponse;
        // Update email in mock response to match the login email
        mockResponse['email'] = params.email;

        return LoginResponse.fromJson(mockResponse);
      }

      // Real API call
      final response = await apiClient.post(
        AppUrls.login,
        body: {'email': params.email, 'password': params.password},
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

}
