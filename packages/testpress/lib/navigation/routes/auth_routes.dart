import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';
import '../bootstrap_provider.dart';
import '../page_transitions/slide_transition_page.dart';

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
    final container = ProviderScope.containerOf(context, listen: false);
    final bootstrapState = container.read(bootstrapProvider);
    final path = state.uri.path;
    final isAuthRoute = _authPaths.contains(path);

    if (bootstrapState == BootstrapState.loading) {
      if (path == '/onboarding') return null;

      // Respect the pre-boot cached auth signal so the loading gate doesn't
      // immediately bounce initialLocation='/home' back to /onboarding before
      // authProvider has a chance to resolve. authProvider still performs full
      // async verification in the background; once bootstrapProvider transitions
      // out of loading, router.refresh() fires and the correct redirect applies.
      final cachedIsLoggedIn = container.read(cachedAuthFlagProvider);
      if (cachedIsLoggedIn && !isAuthRoute) return null;

      return '/onboarding';
    }

    if (bootstrapState == BootstrapState.authenticated) {
      if (isAuthRoute) return '/home';
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
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          slideTransitionPage(context, state.pageKey, const LoginScreen()),
    ),
    GoRoute(
      path: '/mobile-login',
      pageBuilder: (context, state) => slideTransitionPage(
        context,
        state.pageKey,
        const MobileLoginScreen(),
      ),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) =>
          slideTransitionPage(context, state.pageKey, const SignupScreen()),
    ),
    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) => slideTransitionPage(
        context,
        state.pageKey,
        const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return slideTransitionPage(
          context,
          state.pageKey,
          OtpScreen(
            phoneNumber: (extra['phoneNumber'] as String?) ?? '',
            countryCode: (extra['countryCode'] as String?) ?? '',
          ),
        );
      },
    ),
    GoRoute(
      path: '/login-activity',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          context,
          state.pageKey,
          LoginActivityScreen(restrictionMessage: extra?['message'] as String?),
        );
      },
    ),
  ];
}
