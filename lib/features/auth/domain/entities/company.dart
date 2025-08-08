import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String companyId;
  final String ownerName;
  final String companyName;
  final String email;
  final String username;
  final String? profilePicture;
  final String? industry;
  final String? size;
  final String? address;
  final String? phone;
  final String? logo;
  final String? taxId;
  final String? website;

  const Company({
    required this.companyId,
    required this.ownerName,
    required this.companyName,
    required this.email,
    required this.username,
    this.profilePicture,
    this.industry,
    this.size,
    this.address,
    this.phone,
    this.logo,
    this.taxId,
    this.website,
  });

  @override
  List<Object?> get props => [
    companyId,
    ownerName,
    companyName,
    email,
    username,
    profilePicture,
    industry,
    size,
    address,
    phone,
    logo,
    taxId,
    website,
  ];
}