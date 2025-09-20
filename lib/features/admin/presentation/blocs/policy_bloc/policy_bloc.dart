import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/features/admin/domain/repositories/policy_repo.dart';
import 'package:hrms/features/admin/domain/use_cases/create_update_policy_use_case.dart';
import 'package:hrms/features/admin/domain/use_cases/load_policy_use_case.dart';

part 'policy_event.dart';
part 'policy_state.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  PolicyBloc() : super(PolicyInitial()) {
    on<LoadPolicies>((event, emit) async {
      emit(PolicyLoading());
      try {
        final policies = await LoadPolicyUseCase(
          getIt<PolicyRepo>(),
        ).call(event.scope, event.scopeId);

        emit(PolicyLoaded(policies));
      } catch (e) {
        emit(const PolicyError('Failed to load policies'));
      }
    });

    on<CreateOrUpdatePolicy>((event, emit) async {
      emit(PolicyCreatingOrUpdating());
      try {
        final repo = getIt<PolicyRepo>();
        final updatedPolicy = await CreateUpdatePolicyUseCase(
          repo,
        ).call(event.policyData, event.isEdit);

        final prefs = getIt<SharedPrefService>();
        prefs.setBool(LocalStorageKeys.policyFilled, true);

        emit(PolicyOperationSuccess(updatedPolicy['message'] ?? ''));
      } catch (e) {
        emit(const PolicyError('Failed to create/update policy'));
      }
    });
  }
}
