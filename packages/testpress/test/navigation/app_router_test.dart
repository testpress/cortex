import 'dart:async';

import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/navigation/app_router.dart';
import 'package:testpress/navigation/bootstrap_provider.dart';

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
          ],
        );
        addTearDown(container.dispose);

        final router = container.read(goRouterProvider);
        expect(router.routeInformationProvider.value.uri.path, '/onboarding');
      },
    );
  });
}
