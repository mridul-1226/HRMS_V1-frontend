import 'package:equatable/equatable.dart';
import 'package:hrms/models/user_model.dart';

class LoginState extends Equatable {
  final String companyId;
  final String email;
  final String password;
  final bool isLoading;
  final String? error;
  final UserModel? user;

  LoginState({
    this.companyId = '',
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.user,
  });

  LoginState copyWith({
    String? companyId,
    String? email,
    String? password,
    bool? isLoading,
    String? error,
    UserModel? user,
  }) {
    return LoginState(
      companyId: companyId ?? this.companyId,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [companyId, email, password, isLoading, error, user];
}