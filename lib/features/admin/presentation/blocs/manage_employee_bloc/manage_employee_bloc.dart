import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/features/admin/domain/entities/employee_entity.dart';
import 'package:hrms/features/admin/domain/repositories/manage_employee_repo.dart';
import 'package:hrms/features/admin/domain/use_cases/add_employee_use_case.dart';

part 'manage_employee_event.dart';
part 'manage_employee_state.dart';

class ManageEmployeeBloc
    extends Bloc<ManageEmployeeEvent, ManageEmployeeState> {
  ManageEmployeeBloc() : super(ManageEmployeeInitial()) {
    on<AddEmployeeEvent>((event, emit) async {
      try {
        emit(ManageEmployeeLoading());
        final response = await AddEmployeeUseCase(
          getIt<ManageEmployeeRepo>(),
        ).call(event.employeeData);
        emit(EmployeeAddedSuccess(response));
      } catch (e) {
        emit(ManageEmployeeError("Failed to add employee"));
      }
    });
  }
}
