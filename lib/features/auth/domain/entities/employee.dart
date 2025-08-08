import 'package:equatable/equatable.dart';
import 'package:hrms/features/auth/domain/entities/company.dart';
import 'package:hrms/features/auth/domain/entities/user.dart';

class Employee extends Equatable {
  final String employeeId;
  final User user;
  final Company company;
  final String firstName;
  final String? lastName;
  final String employeeType;
  final String? department;
  final DateTime joiningDate;
  final String? phone;
  final String? address;
  final String? bankAccount;
  final Map<String, dynamic>? emergencyContact;
  final Map<String, dynamic>? documents;

  const Employee({
    required this.employeeId,
    required this.user,
    required this.company,
    required this.firstName,
    this.lastName,
    required this.employeeType,
    this.department,
    required this.joiningDate,
    this.phone,
    this.address,
    this.bankAccount,
    this.emergencyContact,
    this.documents,
  });

  @override
  List<Object?> get props => [
    employeeId,
    user,
    company,
    firstName,
    lastName,
    employeeType,
    department,
    joiningDate,
    phone,
    address,
    bankAccount,
    emergencyContact,
    documents,
  ];
}