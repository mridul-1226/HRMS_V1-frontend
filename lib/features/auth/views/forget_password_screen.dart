import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/controller/forget_password_bloc.dart';
import 'package:hrms/features/auth/controller/forget_password_state.dart';
import 'package:hrms/features/auth/controller/forgot_password_event.dart';
import 'package:hrms/services/api_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(ApiService()),
      child: Scaffold(
        appBar: AppBar(title: Text('Forgot Password')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.success == true) {
                Navigator.pushNamed(context, '/reset-confirmation');
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    onChanged: (value) => context.read<ForgotPasswordBloc>().add(ForgotPasswordEmailChanged(value)),
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 20),
                  state.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted()),
                          child: Text('Send Reset Link'),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text('Back to Login'),
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