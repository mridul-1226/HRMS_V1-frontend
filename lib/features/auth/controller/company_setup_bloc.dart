import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/services/api_service.dart';
import 'company_setup_event.dart';
import 'company_setup_state.dart';

class CompanySetupBloc extends Bloc<CompanySetupEvent, CompanySetupState> {
  final ApiService apiService;

  CompanySetupBloc(this.apiService) : super(CompanySetupState()) {
    on<CompanySetupNameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<CompanySetupAddressChanged>((event, emit) {
      emit(state.copyWith(address: event.address));
    });

    on<CompanySetupIndustryChanged>((event, emit) {
      emit(state.copyWith(industry: event.industry));
    });

    on<CompanySetupSubmitted>((event, emit) async {
      if (state.name.isEmpty || state.address.isEmpty || state.industry.isEmpty) {
        emit(state.copyWith(error: 'All fields are required'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));
      try {
        final company = await apiService.setupCompany(state.name, state.address, state.industry);
        emit(state.copyWith(isLoading: false, company: company));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: 'Company setup failed: $e'));
      }
    });
  }
}