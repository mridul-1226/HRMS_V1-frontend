import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/services/api_service.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ApiService apiService;

  ResetPasswordBloc(this.apiService) : super(ResetPasswordState()) {
    on<ResetPasswordNewPasswordChanged>((event, emit) {
      emit(state.copyWith(newPassword: event.newPassword));
    });

    on<ResetPasswordConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<ResetPasswordSubmitted>((event, emit) async {
      if (state.newPassword.isEmpty || state.confirmPassword.isEmpty) {
        emit(state.copyWith(error: 'All fields are required'));
        return;
      }

      if (state.newPassword != state.confirmPassword) {
        emit(state.copyWith(error: 'Passwords do not match'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final success = await apiService.resetPassword(event.token, state.newPassword);
        emit(state.copyWith(isLoading: false, success: success));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'Password reset failed: $e'));
      }
    });
  }
}