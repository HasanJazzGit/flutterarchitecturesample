import '../../../../core/network/api_client.dart';
import '../../../../core/network/services/auth_api_service.dart';
import '../models/login_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService authApiService;

  AuthRemoteDataSourceImpl(ApiClient apiClient)
      : authApiService = AuthApiService(apiClient);

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await authApiService.login(email, password);
      return LoginResponse.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authApiService.logout();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

