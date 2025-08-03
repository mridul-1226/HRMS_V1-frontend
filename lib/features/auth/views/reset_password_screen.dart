import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/controller/reset_password_bloc.dart';
import 'package:hrms/features/auth/controller/reset_password_event.dart';
import 'package:hrms/features/auth/controller/reset_password_state.dart';
import 'package:hrms/services/api_service.dart';

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String token = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => ResetPasswordBloc(ApiService()),
      child: Scaffold(
        appBar: AppBar(title: Text('Reset Password')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.success == true) {
                Navigator.pushReplacementNamed(context, '/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password reset successfully')),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    onChanged: (value) => context.read<ResetPasswordBloc>().add(ResetPasswordNewPasswordChanged(value)),
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  TextField(
                    onChanged: (value) => context.read<ResetPasswordBloc>().add(ResetPasswordConfirmPasswordChanged(value)),
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  state.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => context.read<ResetPasswordBloc>().add(ResetPasswordSubmitted(token)),
                          child: Text('Reset Password'),
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