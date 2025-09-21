import 'package:hrms/features/admin/data/models/department_model.dart';
import 'package:hrms/features/admin/domain/repositories/department_repo.dart';

class AddDepartmentUseCase {
  final DepartmentRepository repository;

  AddDepartmentUseCase(this.repository);

  Future<Map<String, dynamic>> call(DepartmentModel department) {
    return repository.addDepartment(department);
  }
}