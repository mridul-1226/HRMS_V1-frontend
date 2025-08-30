import 'package:go_router/go_router.dart';
import 'package:hrms/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:hrms/features/auth/presentation/screens/change_password_screen.dart';
import 'package:hrms/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hrms/features/auth/presentation/screens/login_screen.dart';
import 'package:hrms/features/auth/presentation/screens/organization_details_screen.dart';
import 'package:hrms/features/auth/presentation/screens/organization_signup_screen.dart';
import 'package:hrms/features/auth/presentation/screens/reset_password_otp_screen.dart';
import 'package:hrms/features/auth/presentation/screens/welcome_screen.dart';
import 'package:hrms/features/initialization/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => WelcomeScreen(),
    ),
    GoRoute(
      path: '/organization-signup',
      name: 'organization-signup',
      builder: (context, state) => OrganizationSignupScreen(),
    ),
    GoRoute(
      path: '/organization-details',
      name: 'organization-details',
      builder: (context, state) => OrganizationDetailsScreen(),
    ),
    // GoRoute(
    //   path: '/verify-email',
    //   name: 'verify-email',
    //   builder:
    //       (context, state) => VerificationScreen(email: state.extra as String),
    // ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password-otp',
      name: 'reset-password-otp',
      builder: (context, state) {
        final email = state.extra as String;
        return ResetPasswordOTPScreen(email: email);
      },
    ),
    GoRoute(
      path: '/change-password',
      name: 'change-password',
      builder: (context, state) => ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      name: 'admin-dashboard',
      builder: (context, state) => AdminDashboardScreen(),
    ),
    // GoRoute(
    //   path: '/employee-dashboard',
    //   name: 'employee-dashboard',
    //   builder: (context, state) => EmployeeDashboardScreen(),
    // ),
    // GoRoute(
    //   path: '/add-employee',
    //   name: 'add-employee',
    //   builder: (context, state) => AddEmployeeScreen(),
    // ),
  ],
);
