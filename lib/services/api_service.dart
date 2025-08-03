import 'dart:math';
import '../models/user_model.dart';
import '../models/company_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.hrms.com';
  static String? _verificationCode;

  Future<bool> registerCompany(String companyName, String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    _verificationCode = _generateVerificationCode();
    print('Verification Code for $email: $_verificationCode');
    return true;
  }

  Future<bool> registerWithGoogle(String companyName, String email, String idToken) async {
    await Future.delayed(Duration(seconds: 1));
    // Simulate backend API call to register with Google ID token
    print('Registering with Google - Company: $companyName, Email: $email, ID Token: $idToken');
    // In a real backend, send idToken to verify with Google and create user
    return true; // Assume success for mock
  }

  Future<UserModel?> login(String companyId, String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return UserModel(id: '1', email: email, role: 'admin', companyId: companyId);
  }

  Future<bool> verifyEmail(String email, String code) async {
    await Future.delayed(Duration(seconds: 1));
    print('Checking Verification Code for $email: Expected $_verificationCode, Received $code');
    if (_verificationCode == null) {
      print('No verification code found for $email');
      return false;
    }
    bool isValid = code == _verificationCode;
    if (isValid) {
      _verificationCode = null;
    }
    return isValid;
  }

  Future<CompanyModel?> setupCompany(String name, String address, String industry) async {
    await Future.delayed(Duration(seconds: 1));
    return CompanyModel(id: '1', name: name, address: address, industry: industry);
  }

  Future<bool> forgotPassword(String email) async {
    await Future.delayed(Duration(seconds: 1));
    _verificationCode = _generateVerificationCode();
    print('Reset Password Verification Code for $email: $_verificationCode');
    return true;
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  String _generateVerificationCode() {
    return (100000 + Random().nextInt(900000)).toString();
  }
}