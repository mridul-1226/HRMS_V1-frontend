import 'package:hrms/features/admin/domain/entities/employee_entity.dart';

class EmployeeModel extends Employee {
  EmployeeModel({
    required super.employeeId,
    required super.userId,
    required super.companyId,
    required super.department,
    required super.firstName,
    required super.lastName,
    required super.salary,
    required super.employeeType,
    required super.joiningDate,
    required super.phone,
    required super.address,
    required super.bankAccount,
    required super.emergencyContact,
    super.dob,
    super.documents,
    required super.workingHours,
    required super.overtimeEligible,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['id'].toString(),
      userId: json['user'] as int,
      companyId: json['company'] as int,
      department: json['department'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      salary: json['salary'] as String,
      employeeType: json['employee_type'] as String == 'sales'
          ? EmployeeType.sales
          : EmployeeType.office,
      joiningDate: DateTime.parse(json['joining_date'] as String),
      phone: json['phone'] as String,
      address: json['address'] as String,
      bankAccount: json['bank_account'] as String,
      emergencyContact: Map<String, dynamic>.from(json['emergency_contact'] as Map),
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
      documents: json['documents'] != null
          ? Map<String, dynamic>.from(json['documents'] as Map)
          : null,
      workingHours: Map<String, dynamic>.from(json['working_hours'] as Map),
      overtimeEligible: json['overtime_eligible'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'userId': userId,
      'companyId': companyId,
      'department': department,
      'firstName': firstName,
      'lastName': lastName,
      'salary': salary,
      'employeeType': employeeType.toString().split('.').last,
      'joiningDate': joiningDate.toIso8601String(),
      'phone': phone,
      'address': address,
      'bankAccount': bankAccount,
      'emergencyContact': emergencyContact,
      'dob': dob?.toIso8601String(),
      'documents': documents,
      'workingHours': workingHours,
      'overtimeEligible': overtimeEligible,
    };
  }
}