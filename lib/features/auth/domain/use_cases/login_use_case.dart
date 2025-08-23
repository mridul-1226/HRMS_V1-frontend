import '../repositories/auth_repo.dart';

class LoginWithEmailAndPasswordUseCase {
  final AuthRepository authRepository;

  LoginWithEmailAndPasswordUseCase(this.authRepository);

  Future<Map<String, dynamic>> call(String email, String password) {
    return authRepository.loginWithEmailAndPassword(email, password);
  }
}