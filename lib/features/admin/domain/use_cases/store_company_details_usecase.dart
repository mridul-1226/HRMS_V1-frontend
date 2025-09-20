import 'package:hrms/features/auth/domain/entities/company.dart';
import 'package:hrms/features/admin/domain/repositories/company_repository.dart';

class StoreCompanyDetailsUseCase {
  final CompanyRepository repository;

  StoreCompanyDetailsUseCase(this.repository);

  Future<Map<String, dynamic>> call(Company company) async {
    return await repository.storeCompanyDetails(company);
  }
}
