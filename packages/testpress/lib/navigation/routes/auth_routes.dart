import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';
import '../../screens/connection_error_screen.dart';
import '../bootstrap_provider.dart';
import '../page_transitions/slide_transition_page.dart';

class AuthRoutes {
  static const _authPaths = {
    '/login',
    '/mobile-login',
    '/signup',
    '/register',
    '/activate',
    '/forgot-password',
    '/otp',
    '/onboarding',
    '/login-activity',
    '/connection-error',
  };

  static String? redirect(BuildContext context, GoRouterState state) {
    final rawPath = state.uri.path;
    if (rawPath.length > 1 && rawPath.endsWith('/')) {
      final stripped = rawPath.substring(0, rawPath.length - 1);
      final query = state.uri.hasQuery ? '?${state.uri.query}' : '';
      return '$stripped$query';
    }

    final container = ProviderScope.containerOf(context, listen: false);
    final bootstrapState = container.read(bootstrapProvider);
    final path = rawPath;
    final isAuthRoute = _authPaths.contains(path);

    if (bootstrapState == BootstrapState.error) {
      if (path == '/connection-error') return null;
      return '/connection-error';
    }

    if (bootstrapState == BootstrapState.loading) {
      if (path == '/onboarding' || path == '/connection-error') return null;

      // Allow auth routes (/register, /signup, /login, /mobile-login) to display immediately
      if (isAuthRoute) return null;

      final cachedIsLoggedIn = container.read(cachedAuthFlagProvider);
      if (cachedIsLoggedIn) return null;

      if (path != '/home' && path != '/') {
        final redirectUrl = Uri.encodeComponent(state.uri.toString());
        return '/onboarding?redirect=$redirectUrl';
      }

      return '/onboarding';
    }

    if (bootstrapState == BootstrapState.enforceStudentData) {
      if (path == '/enforce-student-data') return null;
      return '/enforce-student-data';
    }

    if (bootstrapState == BootstrapState.parallelLoginRequired) {
      if (path == '/login-activity') return null;
      return '/login-activity';
    }

    if (bootstrapState == BootstrapState.authenticated) {
      if ((isAuthRoute && path != '/login-activity') ||
          path == '/enforce-student-data') {
        final redirectParam = state.uri.queryParameters['redirect'];
        if (redirectParam != null && redirectParam.isNotEmpty) {
          final target = Uri.decodeComponent(redirectParam);
          if (target.startsWith('/') &&
              target != '/login' &&
              target != '/signup' &&
              target != '/register') {
            return target;
          }
        }
        return '/home';
      }
      return null;
    }

    // Unauthenticated
    if (!isAuthRoute) {
      if (path != '/onboarding' &&
          path != '/connection-error' &&
          path != '/enforce-student-data') {
        final redirectUrl = Uri.encodeComponent(state.uri.toString());
        return '/login?redirect=$redirectUrl';
      }
      return '/login';
    }

    // /onboarding, /connection-error, and /enforce-student-data - unauthenticated user landing here must go to login.
    if (path == '/onboarding' ||
        path == '/connection-error' ||
        path == '/enforce-student-data') {
      final redirectParam = state.uri.queryParameters['redirect'];
      if (redirectParam != null && redirectParam.isNotEmpty) {
        return '/login?redirect=$redirectParam';
      }
      return '/login';
    }

    return null;
  }

  static List<RouteBase> get routes => [
    GoRoute(
      path: '/connection-error',
      builder: (context, state) => const ConnectionErrorScreen(),
    ),
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
      path: '/register',
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
        final message =
            extra?['message'] as String? ??
            ProviderScope.containerOf(
              context,
              listen: false,
            ).read(parallelLoginRequiredProvider);
        return slideTransitionPage(
          context,
          state.pageKey,
          LoginActivityScreen(restrictionMessage: message),
        );
      },
    ),
    GoRoute(
      path: '/enforce-student-data',
      pageBuilder: (context, state) => slideTransitionPage(
        context,
        state.pageKey,
        const EnforceStudentDataScreen(),
      ),
    ),
  ];
}
