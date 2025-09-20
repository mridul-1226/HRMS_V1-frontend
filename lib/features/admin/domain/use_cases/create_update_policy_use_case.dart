import 'package:hrms/features/admin/domain/repositories/policy_repo.dart';

class CreateUpdatePolicyUseCase {
  final PolicyRepo policyRepo;

  CreateUpdatePolicyUseCase(this.policyRepo);

  Future<Map<String, dynamic>> call(Map<String, dynamic> policyData, bool isEdit) async {
    return await policyRepo.createOrUpdatePolicy(policyData, isEdit);
  }
}
