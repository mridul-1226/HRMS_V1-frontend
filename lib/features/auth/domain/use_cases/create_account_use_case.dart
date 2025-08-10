import 'package:hrms/features/auth/domain/repositories/auth_repo.dart';

class CreateAccountUseCase {
  final AuthRepository authRepository;

  CreateAccountUseCase(this.authRepository);

  Future<Map<String, dynamic>> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) async {
    return await authRepository.registerWithEmailAndPassword(
      email,
      password,
      confirmPassword,
      name,
    );
  }
}