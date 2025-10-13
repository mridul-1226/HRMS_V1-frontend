import 'package:hrms/features/admin/domain/entities/employee_entity.dart';
import 'package:hrms/features/admin/domain/repositories/manage_employee_repo.dart';

class AddEmployeeUseCase {
  final ManageEmployeeRepo repository;

  AddEmployeeUseCase(this.repository);

  Future<Employee> call(Map<String, dynamic> employeeData) {
    return repository.addEmployee(employeeData);
  }
}