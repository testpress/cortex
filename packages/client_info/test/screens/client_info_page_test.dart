import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client_info/client_info.dart';

void main() {
  Widget wrapWithProviders({
    required Widget child,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
                supportedLocales: LocalizationProvider.supportedLocales,
                home: child,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget wrapWithRouter({
    required GoRouter router,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: router,
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
                supportedLocales: LocalizationProvider.supportedLocales,
              );
            },
          ),
        ),
      ),
    );
  }

  group('ClientInfoPage', () {
    testWidgets('renders the curated learning resource catalog', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithProviders(child: const ClientInfoPage()));
      await tester.pumpAndSettle();

      expect(find.text('Learning Resources'), findsWidgets);
      expect(
        find.byKey(const ValueKey('info-course-jee-physics-main')),
        findsOneWidget,
      );
      expect(
        find.text('JEE Main Physics - Complete Course 2026'),
        findsOneWidget,
      );
      expect(find.text('156'), findsOneWidget);
      expect(find.text('42h 30m'), findsOneWidget);
    });

    testWidgets('drills into a course detail route and returns back', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/info',
        routes: [
          GoRoute(
            path: '/info',
            builder: (context, state) => const ClientInfoPage(),
            routes: [
              GoRoute(
                path: 'course/:courseId',
                builder: (context, state) => ClientInfoCourseDetailScreen(
                  courseId: state.pathParameters['courseId']!,
                  onBack: () => context.pop(),
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(wrapWithRouter(router: router));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('info-course-jee-physics-main')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ClientInfoCourseDetailScreen), findsOneWidget);
      expect(find.text('Dr. Rajesh Kumar'), findsOneWidget);
      expect(find.byKey(const ValueKey('info-video-v1')), findsOneWidget);

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      expect(find.byType(ClientInfoPage), findsOneWidget);
    });

    testWidgets('shows an inline error when external video launch fails', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/info/course/jee-physics-main',
        routes: [
          GoRoute(
            path: '/info',
            builder: (context, state) => const ClientInfoPage(),
            routes: [
              GoRoute(
                path: 'course/:courseId',
                builder: (context, state) => ClientInfoCourseDetailScreen(
                  courseId: state.pathParameters['courseId']!,
                  onBack: () => context.pop(),
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        wrapWithRouter(
          router: router,
          overrides: [
            clientInfoLauncherProvider.overrideWith(
              (ref) =>
                  (uri) async => false,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('info-video-v1')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Unable to open this video right now. Please try again later.',
        ),
        findsOneWidget,
      );
      expect(find.byType(ClientInfoCourseDetailScreen), findsOneWidget);
    });
  });
}
