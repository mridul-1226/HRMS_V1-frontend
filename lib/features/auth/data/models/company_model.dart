import 'package:hrms/features/auth/domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.companyId,
    required super.ownerName,
    required super.companyName,
    required super.email,
    super.countryCode,
    super.industry,
    super.size,
    super.address,
    super.phone,
    super.logo,
    super.taxId,
    super.website,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> companyJson) {
    return CompanyModel(
      companyId: companyJson['id']?.toString() ?? '',
      ownerName: companyJson['ownerName']?.toString() ?? '',
      companyName: companyJson['name']?.toString() ?? '',
      email: companyJson['email']?.toString() ?? '',
      industry: companyJson['industry']?.toString(),
      size: companyJson['size']?.toString(),
      address: companyJson['address']?.toString(),
      countryCode: companyJson['countryCode']?.toString() ?? '',
      phone: companyJson['phone']?.toString(),
      logo: companyJson['logo']?.toString(),
      taxId: companyJson['tax_id']?.toString(),
      website: companyJson['website']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName,
      'name': companyName,
      'email': email,
      'industry': industry,
      'size': size,
      'address': address,
      'countryCode': countryCode,
      'phone': phone,
      'logo': logo,
      'tax_id': taxId,
      'website': website,
    };
  }
}
