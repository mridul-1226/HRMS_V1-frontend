part of 'department_bloc.dart';

sealed class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object> get props => [];
}

class AddDepartmentEvent extends DepartmentEvent {
  final DepartmentEntity department;

  const AddDepartmentEvent({required this.department});

  @override
  List<Object> get props => [department];
}