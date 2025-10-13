import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/routes/company_routes.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/features/admin/data/models/employee_model.dart';
import 'package:hrms/features/admin/domain/entities/employee_entity.dart';
import 'package:hrms/features/admin/domain/repositories/manage_employee_repo.dart';

class ManageEmployeeRepoImpl extends ManageEmployeeRepo{
  final _dio = Dio();
  final _prefs = SecureStorageService();
  @override
  Future<Employee> addEmployee(Map<String, dynamic> employeeData) async {
    try {
      final token = await _prefs.readData(LocalStorageKeys.token);
      final url = '${dotenv.env['BASE_URL']}${CompanyRoutes.employees}';
      final response = await _dio.post(
        url,
        data: employeeData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 201 && response.data['success'] != true) {
        throw Exception(response.data['error']);
      }
      final employee = EmployeeModel.fromJson(response.data['data']['employee']);
      return employee;
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<void> deleteEmployee(String employeeId) {
    // TODO: implement deleteEmployee
    throw UnimplementedError();
  }

  @override
  Future<List<Employee>> fetchEmployees(int companyId) {
    // TODO: implement fetchEmployees
    throw UnimplementedError();
  }

  @override
  Future<Employee> updateEmployee(String employeeId, Map<String, dynamic> updatedData) {
    // TODO: implement updateEmployee
    throw UnimplementedError();
  }
}