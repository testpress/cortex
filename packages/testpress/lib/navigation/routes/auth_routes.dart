import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:profile/profile.dart';
import '../bootstrap_provider.dart';

class AuthRoutes {
  static const _authPaths = {
    '/login',
    '/mobile-login',
    '/signup',
    '/forgot-password',
    '/otp',
    '/onboarding',
    '/login-activity',
  };

  static String? redirect(BuildContext context, GoRouterState state) {
    final bootstrapState = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(bootstrapProvider);
    final path = state.uri.path;
    final isAuthRoute = _authPaths.contains(path);

    if (bootstrapState == BootstrapState.loading) {
      if (path == '/onboarding') return null;
      return '/onboarding';
    }

    if (bootstrapState == BootstrapState.authenticated) {
      if (isAuthRoute || path == '/onboarding') return '/home';
      return null;
    }

    // Unauthenticated
    if (!isAuthRoute) return '/login';

    // /onboarding is in _authPaths so !isAuthRoute won't catch it —
    // an unauthenticated user landing here must go to login.
    if (path == '/onboarding') return '/login';

    return null;
  }

  static List<RouteBase> get routes => [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/mobile-login',
      builder: (context, state) => const MobileLoginScreen(),
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
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
    GoRoute(
      path: '/login-activity',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return LoginActivityScreen(
          restrictionMessage: extra?['message'] as String?,
        );
      },
    ),
  ];
}
