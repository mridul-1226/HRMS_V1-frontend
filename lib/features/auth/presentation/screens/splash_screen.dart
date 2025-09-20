import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/features/auth/presentation/blocs/splash_bloc/splash_bloc.dart';
import 'package:hrms/features/auth/presentation/blocs/splash_bloc/splash_event.dart';
import 'package:hrms/features/auth/presentation/blocs/splash_bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;

  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.linear),
    );

    _startAnimations();
    context.read<SplashBloc>().add(CheckAuthenticationEvent());
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _loadingController.repeat();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is NavigateToOrganizationDetails) {
            context.go('/organization-details');
          } else if (state is NavigateToAdminDashboard) {
            context.go('/admin-dashboard');
          } else if (state is NavigateToEmployeeDashboard) {
            context.go('/employee-dashboard');
          } else if(state is! SplashLoading){
            context.go('/welcome');
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo Animation
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.business_center,
                          size: 60,
                          color: Color(0xFF667eea),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Text Animation
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _textAnimation.value)),
                        child: Column(
                          children: [
                            const Text(
                              'HRMS',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Human Resource Management',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 2),

                // Loading Animation
                AnimatedBuilder(
                  animation: _loadingAnimation,
                  builder: (context, child) {
                    return Column(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: _loadingAnimation.value,
                            strokeWidth: 3,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SplashBloc, SplashState>(
                          builder: (context, state) {
                            String message = 'Initializing...';
                            if (state is SplashLoading) {
                              message = state.message;
                            }
                            return Text(
                              message,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
