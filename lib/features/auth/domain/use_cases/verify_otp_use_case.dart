import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for verifying OTP
/// Note: This requires the verifyOtp method to be implemented in the repository
class VerifyOtpUseCase extends UseCase<LoginEntity, VerifyOtpParams> {
  final AuthRepository authRepository;

  VerifyOtpUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, LoginEntity>> call(VerifyOtpParams params) async {
    // TODO: Implement verify OTP in repository
    // For now, return an error
    return const Left('Verify OTP not yet implemented');
  }
}

class VerifyOtpParams extends Equatable {
  final String otp;
  final String? email;
  final String? phoneNumber;

  const VerifyOtpParams({required this.otp, this.email, this.phoneNumber});

  @override
  List<Object?> get props => [otp, email, phoneNumber];
}
