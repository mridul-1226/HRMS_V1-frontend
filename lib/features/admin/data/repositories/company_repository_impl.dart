import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/routes/company_routes.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/features/auth/domain/entities/company.dart';
import 'package:hrms/features/admin/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final Dio dio;

  CompanyRepositoryImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> storeCompanyDetails(Company company) async {
    final endpoint = '${dotenv.env['BASE_URL']}${CompanyRoutes.companyDetails}';
    final token = await getIt<SecureStorageService>().readData(
      LocalStorageKeys.token,
    );

    final data = <String, dynamic>{
      'ownerName': company.ownerName,
      'name': company.companyName,
      'email': company.email,
      'industry': company.industry,
      'size': company.size,
      'address': company.address,
      'countryCode': company.countryCode,
      'logo': company.logo,
      'phone': company.phone,
      'website': company.website,
      'tax_id': company.taxId,
    }..removeWhere(
      (key, value) => value == null || (value is String && value.isEmpty),
    );

    final res = await dio.post(
      endpoint,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode != 200 || res.data['success'] != true) {
      throw Exception(
        res.data['error'] ?? 'Failed to store organization details',
      );
    }

    return res.data['data'];
  }
}
