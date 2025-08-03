import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/services/api_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc(this.apiService) : super(LoginState()) {
    on<LoginCompanyIdChanged>((event, emit) {
      emit(state.copyWith(companyId: event.companyId));
    });

    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
      if (state.companyId.isEmpty || state.email.isEmpty || state.password.isEmpty) {
        emit(state.copyWith(error: 'All fields are required'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final user = await apiService.login(state.companyId, state.email, state.password);
        emit(state.copyWith(isLoading: false, user: user));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'Login failed: $e'));
      }
    });
  }
}