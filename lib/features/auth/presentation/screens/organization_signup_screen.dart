import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/utils/toast.dart';
import 'package:hrms/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrganizationSignupScreen extends StatefulWidget {
  const OrganizationSignupScreen({super.key});

  @override
  State<OrganizationSignupScreen> createState() =>
      _OrganizationSignupScreenState();
}

class _OrganizationSignupScreenState extends State<OrganizationSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.goNamed('organization-details');
        } else if (state is AuthError) {
          Toast.show(message: state.message, isError: true);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text('Organization Signup'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => context.goNamed('welcome'),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Organization Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Set up your organization to manage employees',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      context.read<AuthBloc>().add(
                                        GoogleSignInRequested(),
                                      );
                                    },
                            icon: Icon(Icons.g_mobiledata, size: 24),
                            label: Text('Sign in with Google'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: 24),

                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Email is required';
                            }
                            if (!value!.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password *',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Password is required';
                            }
                            if (value!.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password *',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<AuthBloc>().add(
                                  LoginWithEmailPasswordRequested(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    fullName: _fullNameController.text.trim(),
                                    confirmPassword:
                                        _confirmPasswordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            child:
                                isLoading
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text('Create Account'),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => context.goNamed('login'),
                            child: Text('Already have an account? Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).primaryColor,
                      size: 200,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }
}
