import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/services/api_service.dart';
import 'verification_event.dart';
import 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final ApiService apiService;

  VerificationBloc(this.apiService, String email) : super(VerificationState(email: email)) {
    on<VerificationCodeChanged>((event, emit) {
      print('Verification Code Entered: ${event.code}'); // Log entered code
      emit(state.copyWith(code: event.code));
    });

    on<VerificationSubmitted>((event, emit) async {
      if (state.code.isEmpty) {
        emit(state.copyWith(error: 'Verification code is required'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final success = await apiService.verifyEmail(state.email, state.code);
        if (success) {
          emit(state.copyWith(isLoading: false, success: true));
        } else {
          emit(state.copyWith(isLoading: false, error: 'Invalid verification code'));
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'Verification failed: $e'));
      }
    });
  }
}