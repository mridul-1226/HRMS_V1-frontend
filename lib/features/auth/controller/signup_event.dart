import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupCompanyNameChanged extends SignupEvent {
  final String companyName;
  SignupCompanyNameChanged(this.companyName);
  @override
  List<Object> get props => [companyName];
}

class SignupEmailChanged extends SignupEvent {
  final String email;
  SignupEmailChanged(this.email);
  @override
  List<Object> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;
  SignupPasswordChanged(this.password);
  @override
  List<Object> get props => [password];
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;
  SignupConfirmPasswordChanged(this.confirmPassword);
  @override
  List<Object> get props => [confirmPassword];
}

class SignupSubmitted extends SignupEvent {}

class SignupWithGoogle extends SignupEvent {
  final String companyName;
  SignupWithGoogle(this.companyName);
  @override
  List<Object> get props => [companyName];
}