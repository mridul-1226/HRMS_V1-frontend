abstract class PolicyRepo {
  Future<List<Map<String, dynamic>>> getPolicies(String scope, int? scopeId);
  Future<Map<String, dynamic>> createOrUpdatePolicy(Map<String, dynamic> policyData, bool isEdit);
}