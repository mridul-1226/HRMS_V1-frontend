import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/services/api_service.dart';
import 'package:hrms/services/google_auth_service.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final ApiService apiService;
  final GoogleAuthService googleAuthService;

  SignupBloc(this.apiService, this.googleAuthService) : super(SignupState()) {
    on<SignupCompanyNameChanged>((event, emit) {
      emit(state.copyWith(companyName: event.companyName));
    });

    on<SignupEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<SignupPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SignupConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<SignupSubmitted>((event, emit) async {
      if (state.companyName.isEmpty || state.email.isEmpty || state.password.isEmpty || state.confirmPassword.isEmpty) {
        emit(state.copyWith(error: 'All fields are required'));
        return;
      }

      if (state.password != state.confirmPassword) {
        emit(state.copyWith(error: 'Passwords do not match'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final success = await apiService.registerCompany(state.companyName, state.email, state.password);
        emit(state.copyWith(isLoading: false, success: success));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'Signup failed: $e'));
      }
    });

    on<SignupWithGoogle>((event, emit) async {
      if (event.companyName.isEmpty) {
        emit(state.copyWith(error: 'Company name is required'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final googleResult = await googleAuthService.signIn();
        if (googleResult == null) {
          emit(state.copyWith(isLoading: false, error: 'Google Sign-In cancelled'));
          return;
        }

        final success = await apiService.registerWithGoogle(
          event.companyName,
          googleResult['email']!,
          googleResult['idToken']!,
        );
        emit(state.copyWith(
          isLoading: false,
          googleSignInResult: googleResult,
          success: success,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'Google Sign-In failed: $e'));
      }
    });
  }
}