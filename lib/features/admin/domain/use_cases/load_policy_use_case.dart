import 'package:hrms/features/admin/domain/repositories/policy_repo.dart';

class LoadPolicyUseCase {
  final PolicyRepo policyRepo;

  LoadPolicyUseCase(this.policyRepo);

  Future<List<Map<String, dynamic>>> call(String scope, int? scopeId) async {
    return await policyRepo.getPolicies(scope, scopeId);
  }
}
