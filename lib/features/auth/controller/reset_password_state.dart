import 'package:equatable/equatable.dart';

class ResetPasswordState extends Equatable {
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final String? error;
  final bool? success;

  ResetPasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.error,
    this.success,
  });

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success,
    );
  }

  @override
  List<Object?> get props => [newPassword, confirmPassword, isLoading, error, success];
}