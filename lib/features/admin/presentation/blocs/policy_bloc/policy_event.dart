part of 'policy_bloc.dart';

sealed class PolicyEvent extends Equatable {
  const PolicyEvent();

  @override
  List<Object> get props => [];
}

final class LoadPolicies extends PolicyEvent {
  final String scope;
  final int? scopeId;

  const LoadPolicies({required this.scope, this.scopeId});

  @override
  List<Object> get props => [scope, scopeId ?? -1];
}

final class CreateOrUpdatePolicy extends PolicyEvent {
  final Map<String, dynamic> policyData;
  final bool isEdit;

  const CreateOrUpdatePolicy({required this.policyData, required this.isEdit});

  @override
  List<Object> get props => [policyData, isEdit];
}