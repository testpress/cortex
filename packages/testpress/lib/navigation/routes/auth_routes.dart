import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';

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

  static String? redirect(
    BuildContext context,
    GoRouterState state,
    bool isLoggedIn,
  ) {
    final path = state.uri.path;
    final isAuthRoute = _authPaths.contains(path);
    final container = ProviderScope.containerOf(context, listen: false);

    // Helper: defer provider writes out of the build phase.
    // GoRouter's redirect runs during didChangeDependencies, so synchronous
    // Riverpod mutations crash with "Tried to modify a provider while the
    // widget tree was building". Reads are synchronous and safe.
    void markShown() => Future.microtask(
      () => container.read(hasShownOnboardingProvider.notifier).state = true,
    );

    if (!isLoggedIn && !isAuthRoute) {
      markShown();
      return '/login';
    }
    if (isLoggedIn && isAuthRoute) {
      markShown();
      return '/home';
    }

    if (!isLoggedIn && path == '/onboarding') {
      final hasShown = container.read(hasShownOnboardingProvider);
      if (!hasShown) {
        markShown();
        return null;
      }
      return '/login';
    }

    markShown();
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
