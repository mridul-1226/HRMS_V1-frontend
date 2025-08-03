import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final String companyName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? error;
  final bool? success;
  final Map<String, String>? googleSignInResult; // Stores email, displayName, idToken

  SignupState({
    this.companyName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.error,
    this.success,
    this.googleSignInResult,
  });

  SignupState copyWith({
    String? companyName,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? error,
    bool? success,
    Map<String, String>? googleSignInResult,
  }) {
    return SignupState(
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success,
      googleSignInResult: googleSignInResult,
    );
  }

  @override
  List<Object?> get props => [companyName, email, password, confirmPassword, isLoading, error, success, googleSignInResult];
}