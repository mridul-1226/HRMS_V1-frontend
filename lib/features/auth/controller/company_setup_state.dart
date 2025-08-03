import 'package:equatable/equatable.dart';
import 'package:hrms/models/company_model.dart';

class CompanySetupState extends Equatable {
  final String name;
  final String address;
  final String industry;
  final bool isLoading;
  final String? error;
  final CompanyModel? company;

  CompanySetupState({
    this.name = '',
    this.address = '',
    this.industry = '',
    this.isLoading = false,
    this.error,
    this.company,
  });

  CompanySetupState copyWith({
    String? name,
    String? address,
    String? industry,
    bool? isLoading,
    String? error,
    CompanyModel? company,
  }) {
    return CompanySetupState(
      name: name ?? this.name,
      address: address ?? this.address,
      industry: industry ?? this.industry,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      company: company,
    );
  }

  @override
  List<Object?> get props => [name, address, industry, isLoading, error, company];
}