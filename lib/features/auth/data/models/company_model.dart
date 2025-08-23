import 'package:hrms/features/auth/domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.companyId,
    required super.ownerName,
    required super.companyName,
    required super.email,
    required super.username,
    super.profilePicture,
    super.industry,
    super.size,
    super.address,
    super.phone,
    super.logo,
    super.taxId,
    super.website,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['company_id']?.toString() ?? '',
      ownerName: json['name']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString(),
      industry: json['industry']?.toString(),
      size: json['size']?.toString(),
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
      logo: json['logo']?.toString(),
      taxId: json['tax_id']?.toString(),
      website: json['website']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'name': ownerName,
      'company_name': companyName,
      'email': email,
      'username': username,
      'profile_picture': profilePicture,
      'industry': industry,
      'size': size,
      'address': address,
      'phone': phone,
      'logo': logo,
      'tax_id': taxId,
      'website': website,
    };
  }
}