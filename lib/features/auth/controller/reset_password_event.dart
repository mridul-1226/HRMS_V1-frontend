import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetPasswordNewPasswordChanged extends ResetPasswordEvent {
  final String newPassword;
  ResetPasswordNewPasswordChanged(this.newPassword);
  @override
  List<Object> get props => [newPassword];
}

class ResetPasswordConfirmPasswordChanged extends ResetPasswordEvent {
  final String confirmPassword;
  ResetPasswordConfirmPasswordChanged(this.confirmPassword);
  @override
  List<Object> get props => [confirmPassword];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String token;
  ResetPasswordSubmitted(this.token);
  @override
  List<Object> get props => [token];
}