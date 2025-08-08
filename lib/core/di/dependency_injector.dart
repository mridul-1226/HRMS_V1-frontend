import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';

class DependencyInjector extends StatelessWidget {
  const DependencyInjector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: child,
    );
  }
}