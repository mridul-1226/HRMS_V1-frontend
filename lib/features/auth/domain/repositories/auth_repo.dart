abstract class AuthRepository {
  Future<Map<String, dynamic>> signInWithGoogle(String token);
  Future<Map<String, dynamic>> loginWithEmailAndPassword(String email, String password);
  Future<Map<String, dynamic>> registerWithEmailAndPassword(String email, String password);
  Future<Map<String, dynamic>> sendPasswordResetOTP(String email);
  Future<Map<String, dynamic>> resetPasswordWithOTP(String email, String otp, String newPassword, String userId);
}