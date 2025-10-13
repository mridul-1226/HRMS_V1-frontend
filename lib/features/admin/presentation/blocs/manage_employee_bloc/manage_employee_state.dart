part of 'manage_employee_bloc.dart';

sealed class ManageEmployeeState extends Equatable {
  const ManageEmployeeState();
  
  @override
  List<Object> get props => [];
}

final class ManageEmployeeInitial extends ManageEmployeeState {}

final class ManageEmployeeLoading extends ManageEmployeeState {}

final class EmployeeAddedSuccess extends ManageEmployeeState {
  final Employee employee;

  const EmployeeAddedSuccess(this.employee);

  @override
  List<Object> get props => [employee];
}

final class EmployeeUpdatedSuccess extends ManageEmployeeState {
  final Employee employee;

  const EmployeeUpdatedSuccess(this.employee);

  @override
  List<Object> get props => [employee];
}

final class EmployeeDetailFetchedSuccess extends ManageEmployeeState {
  final Employee employee;

  const EmployeeDetailFetchedSuccess(this.employee);

  @override
  List<Object> get props => [employee];
}

final class EmployeesFetchedSuccess extends ManageEmployeeState {
  final List<Employee> employees;

  const EmployeesFetchedSuccess(this.employees);

  @override
  List<Object> get props => [employees];
}

final class ManageEmployeeError extends ManageEmployeeState {
  final String message;

  const ManageEmployeeError(this.message);

  @override
  List<Object> get props => [message];
}