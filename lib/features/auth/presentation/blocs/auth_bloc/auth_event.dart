part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class LoginWithEmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterWithEmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;

  const RegisterWithEmailPasswordRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
  });

  @override
  List<Object> get props => [email, password, confirmPassword, fullName];
}

class SendPasswordResetOTPRequested extends AuthEvent {
  final String email;

  const SendPasswordResetOTPRequested({
    required this.email
  });

  @override
  List<Object> get props => [email];
}

class ResetPasswordWithOTPRequested extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordWithOTPRequested({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object> get props => [email, otp, newPassword];
}
