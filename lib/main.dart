import 'package:flutter/material.dart';
import 'package:hrms/features/auth/views/company_setup_screen.dart';
import 'package:hrms/features/auth/views/forget_password_screen.dart';
import 'package:hrms/features/auth/views/landing_screen.dart';
import 'package:hrms/features/auth/views/login.dart';
import 'package:hrms/features/auth/views/reset_password_screen.dart';
import 'package:hrms/features/auth/views/signup.dart';
import 'package:hrms/features/auth/views/verification.dart';
import 'package:hrms/features/dashboard/views/admin_dashboard.dart';
import 'package:hrms/features/dashboard/views/employee_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hrms/services/google_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRMS App',
      navigatorKey: navigatorKey, // Add navigatorKey for GoogleAuthService
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/verify-email': (context) => VerificationScreen(),
        '/company-setup': (context) => CompanySetupScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/reset-confirmation': (context) => Scaffold(body: Center(child: Text('Reset link sent!'))),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/admin-dashboard': (context) => AdminDashboardScreen(),
        '/employee-dashboard': (context) => EmployeeDashboardScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}