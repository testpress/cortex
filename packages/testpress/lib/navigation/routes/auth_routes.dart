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
          _slideTransition(context, state.pageKey, const LoginScreen()),
    ),
    GoRoute(
      path: '/mobile-login',
      pageBuilder: (context, state) =>
          _slideTransition(context, state.pageKey, const MobileLoginScreen()),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) =>
          _slideTransition(context, state.pageKey, const SignupScreen()),
    ),
    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) => _slideTransition(
        context,
        state.pageKey,
        const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return _slideTransition(
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
        return _slideTransition(
          context,
          state.pageKey,
          LoginActivityScreen(restrictionMessage: extra?['message'] as String?),
        );
      },
    ),
  ];

  static CustomTransitionPage<void> _slideTransition(
    BuildContext context,
    LocalKey key,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: MotionPreferences.duration(
        context,
        Design.of(context).motion.normal,
      ),
      reverseTransitionDuration: MotionPreferences.duration(
        context,
        Design.of(context).motion.normal,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (!MotionPreferences.shouldAnimate(context)) {
          return child;
        }
        final curve = MotionPreferences.curve(
          context,
          Design.of(context).motion.easeInOut,
        );
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
