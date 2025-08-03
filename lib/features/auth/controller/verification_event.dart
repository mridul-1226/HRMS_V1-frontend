import 'package:equatable/equatable.dart';

abstract class VerificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VerificationCodeChanged extends VerificationEvent {
  final String code;
  VerificationCodeChanged(this.code);
  @override
  List<Object> get props => [code];
}

class VerificationSubmitted extends VerificationEvent {}