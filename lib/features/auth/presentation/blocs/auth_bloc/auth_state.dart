part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final String userId;

  const Authenticated({required this.userId});

  @override
  List<Object> get props => [userId];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

final class SendingPasswordResetOTP extends AuthState {}

final class PasswordResetOTPSent extends AuthState {
  final String message;

  const PasswordResetOTPSent({required this.message});

  @override
  List<Object> get props => [message];
}

final class ResettingPassword extends AuthState {}

final class PasswordResetSuccess extends AuthState {
  final String message;

  const PasswordResetSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
