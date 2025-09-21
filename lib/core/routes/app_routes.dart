import 'package:go_router/go_router.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/features/admin/presentation/screens/add_department_screen.dart';
import 'package:hrms/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:hrms/features/admin/presentation/screens/create_update_policy_screen.dart';
import 'package:hrms/features/admin/presentation/screens/department_policy_screen.dart';
import 'package:hrms/features/auth/presentation/screens/change_password_screen.dart';
import 'package:hrms/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hrms/features/auth/presentation/screens/login_screen.dart';
import 'package:hrms/features/admin/presentation/screens/organization_details_screen.dart';
import 'package:hrms/features/auth/presentation/screens/organization_signup_screen.dart';
import 'package:hrms/features/auth/presentation/screens/reset_password_otp_screen.dart';
import 'package:hrms/features/auth/presentation/screens/welcome_screen.dart';
import 'package:hrms/features/auth/presentation/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final isPolicyFilled =
            prefs.getBool(LocalStorageKeys.policyFilled) ?? false;
        final scopeId = prefs.getString(LocalStorageKeys.companyId);

        if (!isPolicyFilled) {
          return '/create-policy?isEdit=false&scope=company&scopeId=$scopeId';
        }
        return null;
      },
      builder: (context, state) => AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/create-policy',
      name: 'create-policy',
      builder: (context, state) {
        final scope = state.uri.queryParameters['scope'] ?? 'company';
        final scopeId =
            state.uri.queryParameters['scopeId'] != null
                ? int.tryParse(state.uri.queryParameters['scopeId']!)
                : null;
        final type = state.uri.queryParameters['type'];
        return CreateUpdatePolicyScreen(
          scope: scope,
          scopeId: scopeId,
          type: type,
        );
      },
    ),
    GoRoute(
      path: '/add-department',
      name: 'add-department',
      builder: (context, state) {
        return AddDepartmentScreen();
      },
    ),
    GoRoute(
      path: '/policy-list',
      name: 'policy-list',
      builder: (context, state) {
        final scope = state.uri.queryParameters['scope'] ?? 'company';
        final scopeId = state.uri.queryParameters['scopeId'] ?? '';
        return DepartmentPolicyScreen(scope: scope, scopeId: scopeId);
      },
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
