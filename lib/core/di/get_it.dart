import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/features/admin/data/repositories/company_repository_impl.dart';
import 'package:hrms/features/admin/data/repositories/department_repo_impl.dart';
import 'package:hrms/features/admin/data/repositories/manage_employee_repo_impl.dart';
import 'package:hrms/features/admin/data/repositories/policy_repo_impl.dart';
import 'package:hrms/features/admin/domain/repositories/department_repo.dart';
import 'package:hrms/features/admin/domain/repositories/manage_employee_repo.dart';
import 'package:hrms/features/admin/domain/repositories/policy_repo.dart';
import 'package:hrms/features/auth/domain/repositories/auth_repo.dart';
import 'package:hrms/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:hrms/features/admin/domain/repositories/company_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<SharedPrefService>(() => SharedPrefService());
  await SharedPrefService.init();

  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );
  getIt.registerLazySingleton<Dio>(() => dio);

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<Dio>()),
  );

  getIt.registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<PolicyRepo>(() => PolicyRepoImpl());

  getIt.registerLazySingleton<DepartmentRepository>(
    () => DepartmentRepositoryImpl(),
  );

  getIt.registerLazySingleton<ManageEmployeeRepo>(
    () => ManageEmployeeRepoImpl(),
  );
}
