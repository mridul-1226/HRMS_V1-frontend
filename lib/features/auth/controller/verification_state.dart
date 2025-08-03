import 'package:equatable/equatable.dart';

class VerificationState extends Equatable {
  final String email;
  final String code;
  final bool isLoading;
  final String? error;
  final bool? success;

  VerificationState({
    required this.email,
    this.code = '',
    this.isLoading = false,
    this.error,
    this.success,
  });

  VerificationState copyWith({
    String? email,
    String? code,
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return VerificationState(
      email: email ?? this.email,
      code: code ?? this.code,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success,
    );
  }

  @override
  List<Object?> get props => [email, code, isLoading, error, success];
}