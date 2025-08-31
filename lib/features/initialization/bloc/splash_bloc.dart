import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/features/initialization/bloc/splash_event.dart';
import 'package:hrms/features/initialization/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SecureStorageService _secureStorage = getIt<SecureStorageService>();
  final SharedPrefService _sharedPref = getIt<SharedPrefService>();

  SplashBloc() : super(SplashInitial()) {
    on<CheckAuthenticationEvent>(_onCheckAuthentication);
    on<RefreshTokenEvent>(_onRefreshToken);
  }

  Future<void> _onCheckAuthentication(
    CheckAuthenticationEvent event,
    Emitter<SplashState> emit,
  ) async {
    try {
      emit(SplashLoading('Checking authentication...'));

      // Simulate minimum splash duration for better UX
      await Future.delayed(const Duration(seconds: 2));

      // Get access token from secure storage
      final accessToken = await _secureStorage.readData(LocalStorageKeys.token);

      if (accessToken == null || accessToken.isEmpty) {
        emit(SplashLoading('Redirecting to login...'));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(NavigateToOnboarding());
        return;
      }

      emit(SplashLoading('Validating token...'));
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if token is expired
      if (JwtDecoder.isExpired(accessToken)) {
        emit(SplashLoading('Token expired, refreshing...'));
        add(RefreshTokenEvent());
        return;
      }

      // Check if token expires within 3 days
      final expirationDate = JwtDecoder.getExpirationDate(accessToken);
      final daysUntilExpiry = expirationDate.difference(DateTime.now()).inDays;

      if (daysUntilExpiry <= 3) {
        emit(SplashLoading('Refreshing token...'));
        add(RefreshTokenEvent());
        return;
      }

      // Decode token to get user info
      final decodedToken = JwtDecoder.decode(accessToken);
      final userRole = decodedToken['role'] ?? '';

      emit(SplashLoading('Loading dashboard...'));
      await Future.delayed(const Duration(milliseconds: 500));

      if (userRole.toLowerCase() == 'admin') {
        final organizationDetailsCompleted =
            _sharedPref.getBool(
              LocalStorageKeys.organizationDetailsCompleted,
            ) ??
            false;
        if (!organizationDetailsCompleted) {
          emit(SplashLoading('Setting up organization details...'));
          await Future.delayed(const Duration(milliseconds: 500));
          emit(NavigateToOrganizationDetails());
        } else {
          emit(SplashLoading('Loading admin dashboard...'));
          await Future.delayed(const Duration(milliseconds: 500));
          emit(NavigateToAdminDashboard());
        }
      } else if (userRole == 'employee') {
        emit(SplashLoading('Loading employee dashboard...'));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(NavigateToEmployeeDashboard());
      } else {
        await _secureStorage.deleteAll();
        await _sharedPref.clear();
        emit(SplashLoading('Invalid user role, redirecting to onboarding...'));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(NavigateToOnboarding());
      }
    } catch (e) {
      emit(SplashError('Authentication failed: ${e.toString()}'));
      await Future.delayed(const Duration(seconds: 2));
      emit(NavigateToOnboarding());
    }
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<SplashState> emit,
  ) async {
    try {
      emit(SplashLoading('Refreshing authentication...'));

      final refreshToken = await _secureStorage.readData(
        LocalStorageKeys.refreshToken,
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        emit(SplashLoading('Session expired, please login...'));
        await Future.delayed(const Duration(seconds: 1));
        emit(NavigateToOnboarding());
        return;
      }

      // Check if refresh token is expired
      if (JwtDecoder.isExpired(refreshToken)) {
        await _secureStorage.deleteAll();
        await _sharedPref.clear();
        emit(SplashLoading('Session expired, please login...'));
        await Future.delayed(const Duration(seconds: 1));
        emit(NavigateToOnboarding());
        return;
      }

      // TODO: Make actual API call to refresh token
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final refreshTokenDecoded = JwtDecoder.decode(refreshToken);
      final userRole =
          refreshTokenDecoded['role']?.toString().toLowerCase() ?? 'employee';

      // Simulate successful token refresh
      // In real implementation, you would get new tokens from API response
      final newAccessToken = _generateDummyToken(userRole);
      await _secureStorage.writeData(LocalStorageKeys.token, newAccessToken);

      emit(SplashLoading('Authentication refreshed successfully...'));
      await Future.delayed(const Duration(milliseconds: 500));

      // Decode new token to get user role
      // final decodedToken = JwtDecoder.decode(newAccessToken);
      // final userRole = decodedToken['role'] ?? '';

      // Navigate based on user role
      if (userRole.toLowerCase() == 'admin') {
        final organizationDetailsCompleted =
            _sharedPref.getBool(
              LocalStorageKeys.organizationDetailsCompleted,
            ) ??
            false;

        if (!organizationDetailsCompleted) {
          emit(NavigateToOrganizationDetails());
        } else {
          emit(NavigateToAdminDashboard());
        }
      } else {
        emit(NavigateToEmployeeDashboard());
      }
    } catch (e) {
      emit(SplashError('Token refresh failed: ${e.toString()}'));
      await _secureStorage.deleteAll();
      await _sharedPref.clear();
      await Future.delayed(const Duration(seconds: 2));
      emit(NavigateToOnboarding());
    }
  }

  // Dummy token generator for testing
  String _generateDummyToken(String role) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final payload = {
      'user_id': '123',
      'email': 'test@example.com',
      'role': role,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp':
          DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/
          1000,
    };

    // This is a dummy implementation - in real app, tokens come from backend
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTIzIiwiZW1haWwiOiJ0ZXN0QGV4YW1wbGUuY29tIiwicm9sZSI6IiRyb2xlIiwiaWF0IjoxNjk5ODc2NTQzLCJleHAiOjE3MDA0ODEzNDN9.dummy_signature';
  }
}
