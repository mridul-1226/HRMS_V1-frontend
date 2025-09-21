part of 'department_bloc.dart';

sealed class DepartmentState extends Equatable {
  const DepartmentState();
  
  @override
  List<Object> get props => [];
}

final class DepartmentInitial extends DepartmentState {}

final class DepartmentLoading extends DepartmentState {}

final class DepartmentAdded extends DepartmentState {
  final DepartmentEntity department;
  final String message;

  const DepartmentAdded({required this.department, required this.message});

  @override
  List<Object> get props => [department, message];
}

final class DepartmentError extends DepartmentState {
  final String message;

  const DepartmentError({required this.message});

  @override
  List<Object> get props => [message];
}