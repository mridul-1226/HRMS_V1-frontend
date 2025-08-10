import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/google_auth_service.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/features/auth/data/models/company_model.dart';
import 'package:hrms/features/auth/domain/repositories/auth_repo.dart';
import 'package:hrms/features/auth/domain/use_cases/create_account_use_case.dart';
import 'package:hrms/features/auth/domain/use_cases/google_sign_in_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await GoogleAuthService().signIn();
        if (token == null) {
          emit(AuthError(message: 'Google sign-in failed'));
          return;
        }
        final userJson = await GoogleSignInUseCase(
          getIt<AuthRepository>(),
        ).call(token);
        final companyUser = CompanyModel.fromJson(userJson);
        final prefs = getIt<SharedPrefService>();
        await prefs.setString(LocalStorageKeys.email, companyUser.email);
        await prefs.setString(LocalStorageKeys.name, companyUser.ownerName);
        await prefs.setString(
          LocalStorageKeys.profilePicture,
          companyUser.profilePicture ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyLogo,
          companyUser.logo ?? '',
        );
        await prefs.setString(LocalStorageKeys.userId, userJson['id'].toString());
        await prefs.setString(
          LocalStorageKeys.companyId,
          companyUser.companyId,
        );
        await prefs.setString(
          LocalStorageKeys.companyName,
          companyUser.companyName,
        );

        emit(Authenticated(userId: userJson['id'].toString()));
      } catch (e) {
        emit(
          AuthError(message: e.toString().replaceAll('Exception:', '').trim()),
        );
      }
    });


    on<LoginWithEmailPasswordRequested>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final userJson = await CreateAccountUseCase(getIt<AuthRepository>()).call(
            email: event.email,
            password: event.password,
            confirmPassword: event.confirmPassword,
            name: event.fullName,
          );
          final companyUser = CompanyModel.fromJson(userJson);
          final prefs = getIt<SharedPrefService>();
          await prefs.setString(LocalStorageKeys.email, companyUser.email);
          await prefs.setString(LocalStorageKeys.name, companyUser.ownerName);

          emit(Authenticated(userId: userJson['id'].toString()));
        } catch (e) {
          emit(
            AuthError(message: e.toString().replaceAll('Exception:', '').trim()),
          );
        }
      },
    );
  }
}
