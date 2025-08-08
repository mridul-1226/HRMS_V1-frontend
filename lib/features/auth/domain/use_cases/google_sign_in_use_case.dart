import '../repositories/auth_repo.dart';

class GoogleSignInUseCase {
  final AuthRepository authRepository;

  GoogleSignInUseCase(this.authRepository);

  Future<Map<String, dynamic>> call(String token) {
    return authRepository.signInWithGoogle(token);
  }
}