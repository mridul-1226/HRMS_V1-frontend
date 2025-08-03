import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/controller/forget_password_state.dart';
import 'package:hrms/services/api_service.dart';
import 'forgot_password_event.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ApiService apiService;

  ForgotPasswordBloc(this.apiService) : super(ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<ForgotPasswordSubmitted>((event, emit) async {
      if (state.email.isEmpty) {
        emit(state.copyWith(error: 'Email is required'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final success = await apiService.forgotPassword(state.email);
        emit(state.copyWith(isLoading: false, success: success));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'Failed to send reset link: $e'));
      }
    });
  }
}