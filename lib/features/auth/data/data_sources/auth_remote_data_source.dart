import 'package:fluttersampleachitecture/features/auth/domain/use_cases/login_use_case.dart';

import '../models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login({required LoginParams params});
  Future<void> logout();





}

