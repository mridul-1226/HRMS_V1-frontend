part of 'manage_employee_bloc.dart';

sealed class ManageEmployeeEvent extends Equatable {
  const ManageEmployeeEvent();

  @override
  List<Object> get props => [];
}

class AddEmployeeEvent extends ManageEmployeeEvent {
  final Map<String, dynamic> employeeData;

  const AddEmployeeEvent(this.employeeData);

  @override
  List<Object> get props => [employeeData];
}