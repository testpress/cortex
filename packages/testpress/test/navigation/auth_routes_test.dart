import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/data/data.dart';
import 'package:testpress/navigation/bootstrap_provider.dart';
import 'package:testpress/navigation/routes/auth_routes.dart';

void main() {
  group('AuthRoutes.redirect', () {
    testWidgets('normalises trailing slashes', (tester) async {
      final container = ProviderContainer(
        overrides: [
          bootstrapProvider.overrideWith(
            (ref) => BootstrapState.unauthenticated,
          ),
          cachedAuthFlagProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/register/',
        redirect: (context, state) => AuthRoutes.redirect(context, state),
        routes: [
          GoRoute(
            path: '/register',
            builder: (_, _) => const Text('RegisterScreen'),
          ),
          GoRoute(path: '/login', builder: (_, _) => const Text('LoginScreen')),
          GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, '/register');
      expect(find.text('RegisterScreen'), findsOneWidget);
    });

    testWidgets(
      'unauthenticated user on protected route redirects to login with encoded redirect param',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            bootstrapProvider.overrideWith(
              (ref) => BootstrapState.unauthenticated,
            ),
            cachedAuthFlagProvider.overrideWithValue(false),
          ],
        );
        addTearDown(container.dispose);

        final router = GoRouter(
          initialLocation: '/courses/8/contents/3899',
          redirect: (context, state) => AuthRoutes.redirect(context, state),
          routes: [
            GoRoute(
              path: '/courses/8/contents/3899',
              builder: (_, _) => const Text('LessonScreen'),
            ),
            GoRoute(
              path: '/login',
              builder: (_, _) => const Text('LoginScreen'),
            ),
            GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        expect(router.state.uri.path, '/login');
        expect(
          router.state.uri.queryParameters['redirect'],
          '/courses/8/contents/3899',
        );
      },
    );

    testWidgets(
      'unauthenticated user on /onboarding preserves redirect param safely re-encoded',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            bootstrapProvider.overrideWith(
              (ref) => BootstrapState.unauthenticated,
            ),
            cachedAuthFlagProvider.overrideWithValue(false),
          ],
        );
        addTearDown(container.dispose);

        final router = GoRouter(
          initialLocation:
              '/onboarding?redirect=%2Fcourses%2F8%3Fx%3D1%26y%3D2',
          redirect: (context, state) => AuthRoutes.redirect(context, state),
          routes: [
            GoRoute(
              path: '/onboarding',
              builder: (_, _) => const Text('OnboardingScreen'),
            ),
            GoRoute(
              path: '/login',
              builder: (_, _) => const Text('LoginScreen'),
            ),
            GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        expect(router.state.uri.path, '/login');
        expect(
          router.state.uri.queryParameters['redirect'],
          '/courses/8?x=1&y=2',
        );
      },
    );

    testWidgets(
      'authenticated user with valid redirect navigates to target without double-decode error',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            bootstrapProvider.overrideWith(
              (ref) => BootstrapState.authenticated,
            ),
            cachedAuthFlagProvider.overrideWithValue(true),
          ],
        );
        addTearDown(container.dispose);

        final router = GoRouter(
          initialLocation: '/login?redirect=%2Fcourses%2F8%3Ftitle%3D100%25',
          redirect: (context, state) => AuthRoutes.redirect(context, state),
          routes: [
            GoRoute(
              path: '/login',
              builder: (_, _) => const Text('LoginScreen'),
            ),
            GoRoute(
              path: '/courses/8',
              builder: (_, _) => const Text('CourseScreen'),
            ),
            GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        expect(router.state.uri.path, '/courses/8');
        expect(router.state.uri.queryParameters['title'], '100%');
      },
    );

    testWidgets('rejects open-redirect targets starting with //', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          bootstrapProvider.overrideWith((ref) => BootstrapState.authenticated),
          cachedAuthFlagProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/login?redirect=%2F%2Fevil.com%2Fphishing',
        redirect: (context, state) => AuthRoutes.redirect(context, state),
        routes: [
          GoRoute(path: '/login', builder: (_, _) => const Text('LoginScreen')),
          GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Should reject //evil.com and safely fall back to /home
      expect(router.state.uri.path, '/home');
      expect(find.text('HomeScreen'), findsOneWidget);
    });

    testWidgets('rejects redirect loop to auth paths', (tester) async {
      final container = ProviderContainer(
        overrides: [
          bootstrapProvider.overrideWith((ref) => BootstrapState.authenticated),
          cachedAuthFlagProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/login?redirect=%2Fforgot-password',
        redirect: (context, state) => AuthRoutes.redirect(context, state),
        routes: [
          GoRoute(path: '/login', builder: (_, _) => const Text('LoginScreen')),
          GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Should reject auth route in redirect and fall back to /home
      expect(router.state.uri.path, '/home');
      expect(find.text('HomeScreen'), findsOneWidget);
    });

    testWidgets(
      'during loading: cached logged-in user is redirected away from auth routes to /home',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            bootstrapProvider.overrideWith((ref) => BootstrapState.loading),
            cachedAuthFlagProvider.overrideWithValue(true),
          ],
        );
        addTearDown(container.dispose);

        final router = GoRouter(
          initialLocation: '/login',
          redirect: (context, state) => AuthRoutes.redirect(context, state),
          routes: [
            GoRoute(
              path: '/login',
              builder: (_, _) => const Text('LoginScreen'),
            ),
            GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        expect(router.state.uri.path, '/home');
        expect(find.text('HomeScreen'), findsOneWidget);
      },
    );

    testWidgets(
      'during loading: unauthenticated user can access /register immediately',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            bootstrapProvider.overrideWith((ref) => BootstrapState.loading),
            cachedAuthFlagProvider.overrideWithValue(false),
          ],
        );
        addTearDown(container.dispose);

        final router = GoRouter(
          initialLocation: '/register',
          redirect: (context, state) => AuthRoutes.redirect(context, state),
          routes: [
            GoRoute(
              path: '/register',
              builder: (_, _) => const Text('RegisterScreen'),
            ),
            GoRoute(
              path: '/onboarding',
              builder: (_, _) => const Text('OnboardingScreen'),
            ),
            GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        expect(router.state.uri.path, '/register');
        expect(find.text('RegisterScreen'), findsOneWidget);
      },
    );

    testWidgets(
      'authenticated user opening /activate deep link is redirected to /home',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            bootstrapProvider.overrideWith(
              (ref) => BootstrapState.authenticated,
            ),
            cachedAuthFlagProvider.overrideWithValue(true),
          ],
        );
        addTearDown(container.dispose);

        final router = GoRouter(
          initialLocation: '/activate',
          redirect: (context, state) => AuthRoutes.redirect(context, state),
          routes: [
            GoRoute(
              path: '/activate',
              builder: (_, _) => const Text('ActivateScreen'),
            ),
            GoRoute(path: '/home', builder: (_, _) => const Text('HomeScreen')),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        expect(router.state.uri.path, '/home');
        expect(find.text('HomeScreen'), findsOneWidget);
      },
    );
  });
}
