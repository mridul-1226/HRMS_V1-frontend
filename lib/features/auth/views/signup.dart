import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/controller/signup_bloc.dart';
import 'package:hrms/features/auth/controller/signup_event.dart';
import 'package:hrms/features/auth/controller/signup_state.dart';
import 'package:hrms/services/api_service.dart';
import 'package:hrms/services/google_auth_service.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(ApiService(), GoogleAuthService()),
      child: Scaffold(
        appBar: AppBar(title: Text('Sign Up')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.success == true) {
                if (state.googleSignInResult != null) {
                  // Google Sign-In: Skip verification, go to company setup
                  Navigator.pushReplacementNamed(context, '/company-setup');
                } else {
                  // Regular signup: Go to verification
                  Navigator.pushNamed(context, '/verify-email', arguments: state.email);
                }
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    onChanged: (value) => context.read<SignupBloc>().add(SignupCompanyNameChanged(value)),
                    decoration: InputDecoration(labelText: 'Company Name'),
                  ),
                  TextField(
                    onChanged: (value) => context.read<SignupBloc>().add(SignupEmailChanged(value)),
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    onChanged: (value) => context.read<SignupBloc>().add(SignupPasswordChanged(value)),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    onChanged: (value) => context.read<SignupBloc>().add(SignupConfirmPasswordChanged(value)),
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  state.isLoading
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => context.read<SignupBloc>().add(SignupSubmitted()),
                              child: Text('Create Account'),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => context.read<SignupBloc>().add(SignupWithGoogle(state.companyName)),
                              icon: Icon(Icons.g_mobiledata), // Google icon
                              label: Text('Sign Up with Google'),
                            ),
                          ],
                        ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text('Already have an account? Log In'),
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