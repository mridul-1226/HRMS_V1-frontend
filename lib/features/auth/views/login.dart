import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/controller/login_bloc.dart';
import 'package:hrms/features/auth/controller/login_event.dart';
import 'package:hrms/features/auth/controller/login_state.dart';
import 'package:hrms/services/api_service.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(ApiService()),
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.user != null) {
                if (state.user!.role == 'admin') {
                  Navigator.pushReplacementNamed(context, '/admin-dashboard');
                } else {
                  Navigator.pushReplacementNamed(context, '/employee-dashboard');
                }
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    onChanged: (value) => context.read<LoginBloc>().add(LoginCompanyIdChanged(value)),
                    decoration: InputDecoration(labelText: 'Company ID'),
                  ),
                  TextField(
                    onChanged: (value) => context.read<LoginBloc>().add(LoginEmailChanged(value)),
                    decoration: InputDecoration(labelText: 'Email/Employee ID'),
                  ),
                  TextField(
                    onChanged: (value) => context.read<LoginBloc>().add(LoginPasswordChanged(value)),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  state.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => context.read<LoginBloc>().add(LoginSubmitted()),
                          child: Text('Log In'),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                    child: Text('Forgot Password?'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text('New to HRMS? Sign Up'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}