import 'package:hrms/features/auth/domain/entities/company.dart';

abstract class CompanyRepository {
  Future<Map<String, dynamic>> storeCompanyDetails(Company company);
}
