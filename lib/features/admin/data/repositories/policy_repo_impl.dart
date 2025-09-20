import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/routes/company_routes.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/features/admin/domain/repositories/policy_repo.dart';

class PolicyRepoImpl extends PolicyRepo {
  final Dio _dio = getIt<Dio>();
  final _prefs = getIt<SecureStorageService>();
  final endPoint = '${dotenv.env['BASE_URL']}${CompanyRoutes.companyPolicies}';

  @override
  Future<List<Map<String, dynamic>>> getPolicies(
    String scope,
    int? scopeId,
  ) async {
    try {
      final token = await _prefs.readData(LocalStorageKeys.token);
      if(token == null){
        throw Exception('Authentication token not found');
      }

      final response = await _dio.get(
        endPoint,
        queryParameters: {'scope': scope, 'scope_id': scopeId},
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to load policies');
      }
      return List<Map<String, dynamic>>.from(response.data['data']['policies']);
    } catch (e) {
      throw Exception('Failed to load policies: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createOrUpdatePolicy(
    Map<String, dynamic> policyData,
    bool isEdit,
  ) async {
    try {
      final token = await _prefs.readData(LocalStorageKeys.token);
      if(token == null){
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        endPoint,
        data: policyData,
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token',
          },
        ),
      );
      log(response.data.toString());
      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to load policies');
      }
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to load policies: $e');
    }
  }
}
