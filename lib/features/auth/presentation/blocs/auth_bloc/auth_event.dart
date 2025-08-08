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
