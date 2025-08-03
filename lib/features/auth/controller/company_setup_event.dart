import 'package:equatable/equatable.dart';

abstract class CompanySetupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CompanySetupNameChanged extends CompanySetupEvent {
  final String name;
  CompanySetupNameChanged(this.name);
  @override
  List<Object> get props => [name];
}

class CompanySetupAddressChanged extends CompanySetupEvent {
  final String address;
  CompanySetupAddressChanged(this.address);
  @override
  List<Object> get props => [address];
}

class CompanySetupIndustryChanged extends CompanySetupEvent {
  final String industry;
  CompanySetupIndustryChanged(this.industry);
  @override
  List<Object> get props => [industry];
}

class CompanySetupSubmitted extends CompanySetupEvent {}