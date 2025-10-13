enum EmployeeType { sales, office }

class Employee {
  final String employeeId;
  final int userId;
  final int companyId;
  final int department;
  final String firstName;
  final String lastName;
  final String salary;
  final EmployeeType employeeType;
  final DateTime joiningDate;
  final String phone;
  final String address;
  final String bankAccount;
  final Map<String, dynamic> emergencyContact;
  final DateTime? dob;
  final Map<String, dynamic>? documents;
  final Map<String, dynamic> workingHours;
  final bool overtimeEligible;

  Employee({
    required this.employeeId,
    required this.userId,
    required this.companyId,
    required this.department,
    required this.firstName,
    required this.lastName,
    required this.salary,
    required this.employeeType,
    required this.joiningDate,
    required this.phone,
    required this.address,
    required this.bankAccount,
    required this.emergencyContact,
    this.dob,
    this.documents,
    required this.workingHours,
    required this.overtimeEligible,
  });
}