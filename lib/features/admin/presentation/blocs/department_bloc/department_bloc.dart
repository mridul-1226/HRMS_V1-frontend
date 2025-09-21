import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/features/admin/data/models/department_model.dart';
import 'package:hrms/features/admin/domain/entities/department_entity.dart';
import 'package:hrms/features/admin/domain/repositories/department_repo.dart';
import 'package:hrms/features/admin/domain/use_cases/add_department_use_case.dart';

part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentBloc() : super(DepartmentInitial()) {
    on<AddDepartmentEvent>((event, emit) async {
      emit(DepartmentLoading());
      try {
        final response = await AddDepartmentUseCase(
          getIt<DepartmentRepository>(),
        ).call(DepartmentModel.fromEntity(event.department));
        final department = DepartmentModel.fromJson(response['department']);
        final prefs = getIt<SharedPrefService>();
        final allDepartments =
            prefs.getString(LocalStorageKeys.departments) ?? '';
        await prefs.setString(
          LocalStorageKeys.departments,
          '${allDepartments.isNotEmpty ? '$allDepartments,' : ''}${department.name}:${department.id}',
        );

        emit(
          DepartmentAdded(department: department, message: response['message']),
        );
      } catch (e) {
        emit(DepartmentError(message: e.toString()));
      }
    });
  }
}
