part of 'policy_bloc.dart';

sealed class PolicyState extends Equatable {
  const PolicyState();
  
  @override
  List<Object> get props => [];
}

final class PolicyInitial extends PolicyState {}

final class PolicyLoading extends PolicyState {}

final class PolicyLoaded extends PolicyState {
  final List<Map<String, dynamic>> policies;

  const PolicyLoaded(this.policies);

  @override
  List<Object> get props => [policies];
}

final class PolicyError extends PolicyState {
  final String message;

  const PolicyError(this.message);

  @override
  List<Object> get props => [message];
}

final class PolicyCreatingOrUpdating extends PolicyState {}

final class PolicyOperationSuccess extends PolicyState {
  final String message;

  const PolicyOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class PolicyOperationFailure extends PolicyState {
  final String error;

  const PolicyOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}