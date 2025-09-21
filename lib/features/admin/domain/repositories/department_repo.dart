import 'package:hrms/features/admin/data/models/department_model.dart';

abstract class DepartmentRepository {
  Future<Map<String, dynamic>> addDepartment(DepartmentModel department);
}