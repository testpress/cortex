import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:profile/profile.dart';

class AuthRoutes {
  static String? redirect(BuildContext context, GoRouterState state, bool isLoggedIn) {
    final path = state.uri.path;
    final isAuthRoute = path == '/login' || 
                        path == '/password-login' ||
                        path == '/mobile-login' ||
                        path == '/signup' || 
                        path == '/forgot-password' || 
                        path == '/otp' || 
                        path == '/onboarding';

    if (!isLoggedIn && !isAuthRoute) return '/onboarding';
    if (isLoggedIn && isAuthRoute) return '/home';
    return null;
  }

  static List<RouteBase> get routes => [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/password-login',
      builder: (context, state) => const PasswordLoginScreen(),
    ),
    GoRoute(
      path: '/mobile-login',
      builder: (context, state) => const MobileLoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return OtpScreen(
          phoneNumber: (extra['phoneNumber'] as String?) ?? '',
          countryCode: (extra['countryCode'] as String?) ?? '',
        );
      },
    ),
  ];
}
