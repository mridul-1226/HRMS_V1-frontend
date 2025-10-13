import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/admin/presentation/blocs/department_bloc/department_bloc.dart';
import 'package:hrms/features/admin/presentation/blocs/manage_employee_bloc/manage_employee_bloc.dart';
import 'package:hrms/features/admin/presentation/blocs/policy_bloc/policy_bloc.dart';
import 'package:hrms/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:hrms/features/admin/presentation/blocs/org_detail_bloc/org_detail_bloc.dart';
import 'package:hrms/features/auth/presentation/blocs/splash_bloc/splash_bloc.dart';

class DependencyInjector extends StatelessWidget {
  const DependencyInjector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => OrgDetailBloc()),
        BlocProvider(create: (context) => SplashBloc()),
        BlocProvider(create: (context) => PolicyBloc()),
        BlocProvider(create: (context) => DepartmentBloc()),
        BlocProvider(create: (context) => ManageEmployeeBloc()),
      ],
      child: child,
    );
  }
}