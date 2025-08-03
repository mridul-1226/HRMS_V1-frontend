import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final bool isLoading;
  final String? error;
  final bool? success;

  ForgotPasswordState({
    this.email = '',
    this.isLoading = false,
    this.error,
    this.success,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success,
    );
  }

  @override
  List<Object?> get props => [email, isLoading, error, success];
}