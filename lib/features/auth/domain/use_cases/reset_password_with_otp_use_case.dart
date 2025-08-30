import '../repositories/auth_repo.dart';

class ResetPasswordWithOTPUseCase {
  final AuthRepository authRepository;

  ResetPasswordWithOTPUseCase(this.authRepository);

  Future<Map<String, dynamic>> call(
    String email,
    String otp,
    String newPassword,
  ) {
    return authRepository.resetPasswordWithOTP(email, otp, newPassword);
  }
}
