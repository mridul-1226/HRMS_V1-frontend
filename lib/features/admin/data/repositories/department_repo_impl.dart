import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/routes/company_routes.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/features/admin/data/models/department_model.dart';
import 'package:hrms/features/admin/domain/repositories/department_repo.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final Dio _dio = getIt<Dio>();
  final _prefs = getIt<SecureStorageService>();

  @override
  Future<Map<String, dynamic>> addDepartment(DepartmentModel department) async {
    try {
      final token = await _prefs.readData(LocalStorageKeys.token);
      final url = '${dotenv.env['BASE_URL']}${CompanyRoutes.department}';
      final response = await _dio.post(
        url,
        data: department.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 201 && response.data['success'] != true) {
        throw Exception(response.data['error']);
      }
      return response.data['data'];
    } catch (e) {
      throw Exception('$e');
    }
  }
}
