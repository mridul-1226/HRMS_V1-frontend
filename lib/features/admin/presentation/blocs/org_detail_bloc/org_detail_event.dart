part of 'org_detail_bloc.dart';

sealed class OrgDetailEvent extends Equatable {
  const OrgDetailEvent();

  @override
  List<Object> get props => [];
}

class OrgDetailStoreEvent extends OrgDetailEvent {
  final Company company;

  const OrgDetailStoreEvent(this.company);

  @override
  List<Object> get props => [company];
}