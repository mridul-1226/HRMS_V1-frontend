import 'package:equatable/equatable.dart';
import 'package:hrms/features/auth/domain/entities/company.dart';



class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String userType;
  final Company company;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    required this.company,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    userType,
    company,
  ];
}