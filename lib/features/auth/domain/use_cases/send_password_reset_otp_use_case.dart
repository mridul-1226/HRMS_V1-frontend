import '../repositories/auth_repo.dart';

class SendPasswordResetOTPUseCase {
  final AuthRepository authRepository;

  SendPasswordResetOTPUseCase(this.authRepository);

  Future<Map<String, dynamic>> call(String email) {
    return authRepository.sendPasswordResetOTP(email);
  }
}
