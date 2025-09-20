part of 'org_detail_bloc.dart';

sealed class OrgDetailState extends Equatable {
  const OrgDetailState();
  
  @override
  List<Object> get props => [];
}

final class OrgDetailInitial extends OrgDetailState {}

final class OrgDetailStoring extends OrgDetailState {}

final class OrgDetailStored extends OrgDetailState {
  final String message;

  const OrgDetailStored(this.message);

  @override
  List<Object> get props => [message];
}

final class OrgDetailError extends OrgDetailState {
  final String message;

  const OrgDetailError(this.message);

  @override
  List<Object> get props => [message];
}
