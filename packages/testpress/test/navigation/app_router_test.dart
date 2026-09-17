import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/navigation/app_router.dart';
import 'package:testpress/navigation/bootstrap_provider.dart';
import 'package:testpress/providers/initialization_provider.dart';
import 'package:testpress/screens/connection_error_screen.dart';

// ---------------------------------------------------------------------------
// Minimal Auth mocks (same pattern as bootstrap_provider_test.dart)
// ---------------------------------------------------------------------------
class _AuthLoading extends Auth {
  @override
  FutureOr<bool> build() => Completer<bool>().future; // never resolves
}

void main() {
  // -------------------------------------------------------------------------
  // buildPrimaryNavigationItems
  // -------------------------------------------------------------------------
  group('buildPrimaryNavigationItems', () {
    test('keeps Profile as the last destination', () {
      final defaultSettings = InstituteSettings.fromJson({
        'store_enabled': true,
      });
      final items = buildPrimaryNavigationItems(defaultSettings);

      expect(items.length, 4);
      expect(items.last.id, '/profile');
      expect(items.last.label, 'Profile');
      expect(items.last.icon, LucideIcons.user);
    });

    test(
      'adds Info as the fourth destination when enabled',
      () {
        final defaultSettings = InstituteSettings.fromJson({
          'store_enabled': true,
        });
        final items = buildPrimaryNavigationItems(defaultSettings);

        expect(items.length, 5);
        expect(items[3].id, '/info');
        expect(items[3].label, 'Info');
        expect(items[3].icon, LucideIcons.squarePlay);

        expect(items[4].id, '/profile');
        expect(items[4].label, 'Profile');
      },
      skip: !AppConfig.showInfoTab,
    );
  });

  // -------------------------------------------------------------------------
  // goRouterProvider — initialLocation driven by cachedAuthFlagProvider
  // -------------------------------------------------------------------------
  group('goRouterProvider initialLocation', () {
    test('is /home when cachedAuthFlagProvider is true', () {
      final container = ProviderContainer(
        overrides: [
          cachedAuthFlagProvider.overrideWithValue(true),
          authProvider.overrideWith(_AuthLoading.new),
          instituteSettingsProvider.overrideWith((ref) => null),
          settingsInitializationProvider.overrideWith(
            (ref) => Completer<void>().future,
          ),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      expect(router.routeInformationProvider.value.uri.path, '/home');
    });

    test('is /onboarding when cachedAuthFlagProvider is false', () {
      final container = ProviderContainer(
        overrides: [
          cachedAuthFlagProvider.overrideWithValue(false),
          authProvider.overrideWith(_AuthLoading.new),
          instituteSettingsProvider.overrideWith((ref) => null),
          settingsInitializationProvider.overrideWith(
            (ref) => Completer<void>().future,
          ),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      expect(router.routeInformationProvider.value.uri.path, '/onboarding');
    });
  });

  // -------------------------------------------------------------------------
  // AuthRoutes.redirect — loading gate respects cachedAuthFlagProvider
  // -------------------------------------------------------------------------
  group('AuthRoutes.redirect loading gate', () {
    test('does NOT redirect /home → /onboarding when bootstrapState=loading '
        'and cachedAuthFlagProvider=true', () async {
      final container = ProviderContainer(
        overrides: [
          cachedAuthFlagProvider.overrideWithValue(true),
          authProvider.overrideWith(_AuthLoading.new),
          instituteSettingsProvider.overrideWith((ref) => null),
          settingsInitializationProvider.overrideWith(
            (ref) => Completer<void>().future,
          ),
        ],
      );
      addTearDown(container.dispose);

      // bootstrapState must be loading (auth never resolves in this test)
      final bootstrap = container.read(bootstrapProvider);
      expect(bootstrap, BootstrapState.loading);

      // With cachedAuthFlagProvider=true the router starts at /home.
      // Verify the router is indeed at /home rather than having been
      // bounced back to /onboarding by the loading gate.
      final router = container.read(goRouterProvider);
      expect(router.routeInformationProvider.value.uri.path, '/home');
    });

    test(
      'still redirects unrecognised paths → /onboarding when bootstrapState=loading '
      'and cachedAuthFlagProvider=false',
      () {
        final container = ProviderContainer(
          overrides: [
            cachedAuthFlagProvider.overrideWithValue(false),
            authProvider.overrideWith(_AuthLoading.new),
            instituteSettingsProvider.overrideWith((ref) => null),
            settingsInitializationProvider.overrideWith(
              (ref) => Completer<void>().future,
            ),
          ],
        );
        addTearDown(container.dispose);

        final router = container.read(goRouterProvider);
        expect(router.routeInformationProvider.value.uri.path, '/onboarding');
      },
    );

    testWidgets(
      'redirects to /connection-error and displays ConnectionErrorScreen when bootstrapState=error',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            cachedAuthFlagProvider.overrideWithValue(false),
            settingsInitializationProvider.overrideWith(
              (ref) => Future.error(Exception('Connection error')),
            ),
            instituteSettingsProvider.overrideWith((ref) => null),
            authProvider.overrideWith(_AuthLoading.new),
          ],
        );
        addTearDown(container.dispose);

        try {
          await container.read(settingsInitializationProvider.future);
        } catch (_) {}

        final bootstrap = container.read(bootstrapProvider);
        expect(bootstrap, BootstrapState.error);

        final router = container.read(goRouterProvider);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DesignProvider(
              config: DesignConfig.light(),
              child: MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: LocalizationProvider.delegates,
                supportedLocales: LocalizationProvider.supportedLocales,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ConnectionErrorScreen), findsOneWidget);
      },
    );

    testWidgets(
      'remains on /connection-error during retry while bootstrapState is loading',
      (tester) async {
        var completer = Completer<void>();
        final container = ProviderContainer(
          overrides: [
            cachedAuthFlagProvider.overrideWithValue(false),
            settingsInitializationProvider.overrideWith(
              (ref) => completer.future,
            ),
            instituteSettingsProvider.overrideWith((ref) => null),
            authProvider.overrideWith(_AuthLoading.new),
          ],
        );
        addTearDown(container.dispose);

        // 1. Trigger initial error
        completer.completeError(Exception('Initial failure'));
        try {
          await container.read(settingsInitializationProvider.future);
        } catch (_) {}

        expect(container.read(bootstrapProvider), BootstrapState.error);

        final router = container.read(goRouterProvider);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: DesignProvider(
              config: DesignConfig.light(),
              child: MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: LocalizationProvider.delegates,
                supportedLocales: LocalizationProvider.supportedLocales,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ConnectionErrorScreen), findsOneWidget);
        expect(
          router.routeInformationProvider.value.uri.path,
          '/connection-error',
        );

        // 2. Simulate user tapping retry (invalidating provider -> switches to loading)
        completer = Completer<void>();
        container.invalidate(settingsInitializationProvider);

        expect(container.read(bootstrapProvider), BootstrapState.loading);
        router.refresh();
        await tester.pump();

        // 3. Must still be on /connection-error and NOT bounced to /onboarding
        expect(
          router.routeInformationProvider.value.uri.path,
          '/connection-error',
        );
        expect(find.byType(ConnectionErrorScreen), findsOneWidget);
      },
    );
  });

  // -------------------------------------------------------------------------
  // Named Route resolution
  // -------------------------------------------------------------------------
  group('Study named routes', () {
    test('resolves assessment-detail route correctly', () {
      final container = ProviderContainer(
        overrides: [
          cachedAuthFlagProvider.overrideWithValue(true),
          authProvider.overrideWith(_AuthLoading.new),
          instituteSettingsProvider.overrideWith((ref) => null),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      final location = router.namedLocation(
        AppRouteNames.assessmentDetail,
        pathParameters: {'id': '123'},
      );
      expect(location, '/study/assessment/123');
    });
  });
}
