import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/controller/verification_bloc.dart';
import 'package:hrms/features/auth/controller/verification_event.dart';
import 'package:hrms/features/auth/controller/verification_state.dart';
import 'package:hrms/services/api_service.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => VerificationBloc(ApiService(), email),
      child: Scaffold(
        appBar: AppBar(title: Text('Verify Email')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<VerificationBloc, VerificationState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.success == true) {
                Navigator.pushReplacementNamed(context, '/company-setup');
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Text('A verification code has been sent to ${state.email}'),
                  TextField(
                    onChanged: (value) => context.read<VerificationBloc>().add(VerificationCodeChanged(value)),
                    decoration: InputDecoration(labelText: 'Verification Code'),
                    keyboardType: TextInputType.number, // Ensure numeric input
                  ),
                  SizedBox(height: 20),
                  state.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => context.read<VerificationBloc>().add(VerificationSubmitted()),
                          child: Text('Verify'),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Back to Signup'),
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
  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => VerificationBloc(ApiService(), email),
      child: Scaffold(
        appBar: AppBar(title: Text('Verify Email')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<VerificationBloc, VerificationState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.success == true) {
                Navigator.pushNamed(context, '/company-setup');
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Text('A verification code has been sent to ${state.email}'),
                  TextField(
                    onChanged: (value) => context.read<VerificationBloc>().add(VerificationCodeChanged(value)),
                    decoration: InputDecoration(labelText: 'Verification Code'),
                  ),
                  SizedBox(height: 20),
                  state.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => context.read<VerificationBloc>().add(VerificationSubmitted()),
                          child: Text('Verify'),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Back to Signup'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
