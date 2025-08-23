abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {
  final String message;
  SplashLoading(this.message);
}

class NavigateToLogin extends SplashState {}

class NavigateToAdminDashboard extends SplashState {}

class NavigateToEmployeeDashboard extends SplashState {}

class NavigateToOnboarding extends SplashState {}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}
