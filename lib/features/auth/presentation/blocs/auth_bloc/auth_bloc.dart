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
import 'package:hrms/features/auth/domain/use_cases/login_use_case.dart';
import 'package:hrms/features/auth/domain/use_cases/reset_password_with_otp_use_case.dart';
import 'package:hrms/features/auth/domain/use_cases/send_password_reset_otp_use_case.dart';

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
        final result = await GoogleSignInUseCase(
          getIt<AuthRepository>(),
        ).call(token);

        final userJson = result['user'] as Map<String, dynamic>;
        final companyJson = result['company'] as Map<String, dynamic>;
        final userRole = result['role']?.toString() ?? '';

        final companyUser = CompanyModel.fromJson({'company': companyJson});
        final prefs = getIt<SharedPrefService>();

        // User details
        await prefs.setBool(LocalStorageKeys.isLoggedIn, true);
        await prefs.setString(LocalStorageKeys.email, userJson['email'] ?? '');
        await prefs.setString(LocalStorageKeys.name, userJson['name'] ?? '');
        await prefs.setString(
          LocalStorageKeys.userId,
          userJson['id'].toString(),
        );
        await prefs.setString(LocalStorageKeys.userRole, userRole);
        await prefs.setString(
          LocalStorageKeys.profilePicture,
          userJson['profile_picture'] ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.username,
          userJson['username'] ?? '',
        );

        // Company details
        await prefs.setString(
          LocalStorageKeys.companyName,
          companyUser.companyName,
        );
        await prefs.setString(
          LocalStorageKeys.companyId,
          companyUser.companyId,
        );
        await prefs.setString(LocalStorageKeys.companyEmail, companyUser.email);
        await prefs.setString(
          LocalStorageKeys.companyLogo,
          companyUser.logo ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyIndustry,
          companyUser.industry ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companySize,
          companyUser.size ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyAddress,
          companyUser.address ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyPhone,
          companyUser.phone ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.countryCode,
          companyUser.countryCode ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyTaxId,
          companyUser.taxId ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyWebsite,
          companyUser.website ?? '',
        );

        final requiredFilled =
            (companyUser.companyName.isNotEmpty) &&
            (companyUser.email.isNotEmpty) &&
            (companyUser.industry?.isNotEmpty ?? false) &&
            (companyUser.size?.isNotEmpty ?? false) &&
            (companyUser.countryCode?.isNotEmpty ?? false) &&
            (companyUser.phone?.isNotEmpty ?? false);
        await prefs.setBool(
          LocalStorageKeys.organizationDetailsCompleted,
          requiredFilled,
        );

        emit(Authenticated(userId: userJson['id'].toString()));
      } catch (e) {
        emit(
          AuthError(message: e.toString().replaceAll('Exception:', '').trim()),
        );
      }
    });

    on<LoginWithEmailPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await LoginWithEmailAndPasswordUseCase(
          getIt<AuthRepository>(),
        ).call(event.email, event.password);

        final userJson = result['user'] as Map<String, dynamic>;
        final companyJson = result['company'] as Map<String, dynamic>;
        final userRole = result['role']?.toString() ?? '';

        final companyUser = CompanyModel.fromJson(companyJson);
        final prefs = getIt<SharedPrefService>();

        // User details
        await prefs.setBool(LocalStorageKeys.isLoggedIn, true);
        await prefs.setString(LocalStorageKeys.email, userJson['email'] ?? '');
        await prefs.setString(LocalStorageKeys.name, userJson['name'] ?? '');
        await prefs.setString(
          LocalStorageKeys.userId,
          userJson['id'].toString(),
        );
        await prefs.setString(LocalStorageKeys.userRole, userRole);
        await prefs.setString(
          LocalStorageKeys.profilePicture,
          userJson['profile_picture'] ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.username,
          userJson['username'] ?? '',
        );

        // Company details
        await prefs.setString(
          LocalStorageKeys.companyName,
          companyUser.companyName,
        );
        await prefs.setString(
          LocalStorageKeys.companyId,
          companyUser.companyId,
        );
        await prefs.setString(
          LocalStorageKeys.companyLogo,
          companyUser.logo ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyIndustry,
          companyUser.industry ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companySize,
          companyUser.size ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyAddress,
          companyUser.address ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.countryCode,
          companyUser.countryCode ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyPhone,
          companyUser.phone ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyTaxId,
          companyUser.taxId ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyWebsite,
          companyUser.website ?? '',
        );

        final requiredFilled =
            (companyUser.companyName.isNotEmpty) &&
            (companyUser.email.isNotEmpty) &&
            (companyUser.industry?.isNotEmpty ?? false) &&
            (companyUser.size?.isNotEmpty ?? false) &&
            (companyUser.countryCode?.isNotEmpty ?? false) &&
            (companyUser.phone?.isNotEmpty ?? false);
        await prefs.setBool(
          LocalStorageKeys.organizationDetailsCompleted,
          requiredFilled,
        );

        emit(Authenticated(userId: userJson['id'].toString()));
      } catch (e) {
        emit(
          AuthError(message: e.toString().replaceAll('Exception:', '').trim()),
        );
      }
    });

    on<RegisterWithEmailPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await CreateAccountUseCase(getIt<AuthRepository>()).call(
          email: event.email,
          password: event.password,
          confirmPassword: event.confirmPassword,
          name: event.fullName,
        );

        final userJson = result['user'] as Map<String, dynamic>;
        final companyJson = result['company'] as Map<String, dynamic>;
        final userRole = result['role']?.toString() ?? '';

        final companyUser = CompanyModel.fromJson({'company': companyJson});
        final prefs = getIt<SharedPrefService>();

        // User details
        await prefs.setBool(LocalStorageKeys.isLoggedIn, true);
        await prefs.setString(LocalStorageKeys.email, userJson['email'] ?? '');
        await prefs.setString(LocalStorageKeys.name, userJson['name'] ?? '');
        await prefs.setString(
          LocalStorageKeys.userId,
          userJson['id'].toString(),
        );
        await prefs.setString(LocalStorageKeys.userRole, userRole);
        await prefs.setString(
          LocalStorageKeys.profilePicture,
          userJson['profile_picture'] ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.username,
          userJson['username'] ?? '',
        );

        // Company details
        await prefs.setString(
          LocalStorageKeys.companyName,
          companyUser.companyName,
        );
        await prefs.setString(
          LocalStorageKeys.companyId,
          companyUser.companyId,
        );
        await prefs.setString(
          LocalStorageKeys.countryCode,
          companyUser.countryCode ?? '+91',
        );
        await prefs.setString(LocalStorageKeys.phone, companyUser.phone ?? '');
        await prefs.setString(
          LocalStorageKeys.companyLogo,
          companyUser.logo ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyIndustry,
          companyUser.industry ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companySize,
          companyUser.size ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyAddress,
          companyUser.address ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyPhone,
          companyUser.phone ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyTaxId,
          companyUser.taxId ?? '',
        );
        await prefs.setString(
          LocalStorageKeys.companyWebsite,
          companyUser.website ?? '',
        );

        emit(Authenticated(userId: userJson['id'].toString()));
      } catch (e) {
        emit(
          AuthError(message: e.toString().replaceAll('Exception:', '').trim()),
        );
      }
    });

    on<SendPasswordResetOTPRequested>((event, emit) async {
      emit(SendingPasswordResetOTP());
      try {
        final result = await SendPasswordResetOTPUseCase(
          getIt<AuthRepository>(),
        ).call(event.email);
        emit(
          PasswordResetOTPSent(
            message: result['message'] ?? 'OTP sent successfully to your email',
          ),
        );
      } catch (e) {
        emit(
          AuthError(message: e.toString().replaceAll('Exception:', '').trim()),
        );
      }
    });

    on<ResetPasswordWithOTPRequested>((event, emit) async {
      emit(ResettingPassword());
      try {
        final result = await ResetPasswordWithOTPUseCase(
          getIt<AuthRepository>(),
        ).call(event.email, event.otp, event.newPassword);
        emit(
          PasswordResetSuccess(
            message:
                result['message'] ??
                'Password reset successfully! Please login with your new password.',
          ),
        );
      } catch (e) {
        emit(
          AuthError(message: e.toString().replaceAll('Exception:', '').trim()),
        );
      }
    });
  }
}
