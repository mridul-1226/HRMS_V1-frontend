import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/routes/auth_routes.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/features/auth/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Map<String, dynamic>> signInWithGoogle(String token) async {
    final securedStorage = getIt<SecureStorageService>();
    final endpoint = '${dotenv.env['BASE_URL']}${AuthRoutes.googleSignIn}';
    try {
      final response = await _dio.post(endpoint, data: {'id_token': token});

      if (response.statusCode != 200) {
        throw Exception('Failed to sign in with Google: ${response.data}');
      }

      if(response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Unknown error occurred');
      }

      await securedStorage.writeData(LocalStorageKeys.token, response.data['data']['access_token']);
      await securedStorage.writeData(LocalStorageKeys.token, response.data['data']['refresh_token']);
      return response.data['data']['user'];
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // TODO: Implement email/password login logic
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // TODO: Implement email/password registration logic
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> sendPasswordResetOTP(String email) async {
    // TODO: Implement send password reset OTP logic
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> resetPasswordWithOTP(
    String email,
    String otp,
    String newPassword,
    String userId,
  ) async {
    // TODO: Implement reset password with OTP logic
    throw UnimplementedError();
  }
}
