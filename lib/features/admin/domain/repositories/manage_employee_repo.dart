import 'package:hrms/features/admin/domain/entities/employee_entity.dart';

abstract class ManageEmployeeRepo {
  Future<Employee> addEmployee(Map<String, dynamic> employeeData);
  Future<List<Employee>> fetchEmployees(int companyId);
  Future<Employee> updateEmployee(String employeeId, Map<String, dynamic> updatedData);
  Future<void> deleteEmployee(String employeeId);
}