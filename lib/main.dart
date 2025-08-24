import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hrms/core/di/dependency_injector.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:hrms/features/auth/presentation/screens/welcome_screen.dart';
import 'package:hrms/features/auth/presentation/screens/organization_signup_screen.dart';
import 'package:hrms/features/auth/presentation/screens/organization_details_screen.dart';
import 'package:hrms/features/auth/presentation/screens/login_screen.dart';
import 'package:hrms/features/auth/presentation/screens/change_password_screen.dart';
import 'package:hrms/features/initialization/splash_screen.dart';
import 'package:hrms/firebase_options.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupLocator();
  await dotenv.load(fileName: ".env");
  runApp(DependencyInjector(child: MyApp()));
}

final GoRouter _router = GoRouter(
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp.router(
        title: 'HRMS App',
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
