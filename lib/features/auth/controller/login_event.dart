import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginCompanyIdChanged extends LoginEvent {
  final String companyId;
  LoginCompanyIdChanged(this.companyId);
  @override
  List<Object> get props => [companyId];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);
  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {}