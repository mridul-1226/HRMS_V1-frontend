import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/controller/company_setup_bloc.dart';
import 'package:hrms/features/auth/controller/company_setup_event.dart';
import 'package:hrms/features/auth/controller/company_setup_state.dart';
import 'package:hrms/services/api_service.dart';

class CompanySetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanySetupBloc(ApiService()),
      child: Scaffold(
        appBar: AppBar(title: Text('Company Setup')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<CompanySetupBloc, CompanySetupState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.company != null) {
                Navigator.pushReplacementNamed(context, '/admin-dashboard');
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    onChanged: (value) => context.read<CompanySetupBloc>().add(CompanySetupNameChanged(value)),
                    decoration: InputDecoration(labelText: 'Company Name'),
                  ),
                  TextField(
                    onChanged: (value) => context.read<CompanySetupBloc>().add(CompanySetupAddressChanged(value)),
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    onChanged: (value) => context.read<CompanySetupBloc>().add(CompanySetupIndustryChanged(value)),
                    decoration: InputDecoration(labelText: 'Industry'),
                  ),
                  SizedBox(height: 20),
                  state.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => context.read<CompanySetupBloc>().add(CompanySetupSubmitted()),
                          child: Text('Save & Continue'),
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