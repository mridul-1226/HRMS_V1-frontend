import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.goNamed('admin-dashboard');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading || _isLoading;
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
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
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 32),

                    TextFormField(
                      controller: _companyIdController,
                      decoration: InputDecoration(
                        labelText: 'Company ID *',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your company identifier',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Company ID is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email or Username *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Email or username is required';
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
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _login,
                        child:
                            isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Login'),
                      ),
                    ),
                    SizedBox(height: 16),

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
                        icon: Icon(Icons.g_mobiledata),
                        label: Text('Login with Google (Admin)'),
                      ),
                    ),
                    SizedBox(height: 24),

                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Forgot Password?'),
                      ),
                    ),

                    Center(
                      child: TextButton(
                        onPressed: () => context.goNamed('organization-signup'),
                        child: Text('New to HRMS? Sign Up'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(Duration(seconds: 2));
      setState(() => _isLoading = false);
      if (!mounted) return;

      context.goNamed('admin-dashboard');
    }
  }

  @override
  void dispose() {
    _companyIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
