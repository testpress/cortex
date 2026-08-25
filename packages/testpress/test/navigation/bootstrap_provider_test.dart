import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:testpress/navigation/bootstrap_provider.dart';

class MockAuthLoading extends Auth {
  @override
  FutureOr<bool> build() {
    // Return a Future that never completes so it stays in AsyncLoading state
    return Completer<bool>().future;
  }
}

class MockAuthAuthenticated extends Auth {
  @override
  FutureOr<bool> build() => true;
}

class MockAuthUnauthenticated extends Auth {
  @override
  FutureOr<bool> build() => false;
}

void main() {
  final dummySettings = InstituteSettings.fromJson(const {});

  test('yields loading when settings are null', () {
    final container = ProviderContainer(
      overrides: [
        instituteSettingsProvider.overrideWith((ref) => null),
        authProvider.overrideWith(MockAuthAuthenticated.new),
      ],
    );

    final state = container.read(bootstrapProvider);
    expect(state, BootstrapState.loading);
  });

  test('yields loading when auth is loading', () {
    final container = ProviderContainer(
      overrides: [
        instituteSettingsProvider.overrideWith((ref) => dummySettings),
        authProvider.overrideWith(MockAuthLoading.new),
      ],
    );

    final state = container.read(bootstrapProvider);
    expect(state, BootstrapState.loading);
  });

  test(
    'yields authenticated when settings are loaded and auth is true',
    () async {
      final container = ProviderContainer(
        overrides: [
          instituteSettingsProvider.overrideWith((ref) => dummySettings),
          authProvider.overrideWith(MockAuthAuthenticated.new),
        ],
      );

      // Wait for the FutureProvider/AsyncNotifier to settle
      await container.read(authProvider.future);

      final state = container.read(bootstrapProvider);
      expect(state, BootstrapState.authenticated);
    },
  );

  test(
    'yields unauthenticated when settings are loaded and auth is false',
    () async {
      final container = ProviderContainer(
        overrides: [
          instituteSettingsProvider.overrideWith((ref) => dummySettings),
          authProvider.overrideWith(MockAuthUnauthenticated.new),
        ],
      );

      // Wait for the FutureProvider/AsyncNotifier to settle
      await container.read(authProvider.future);

      final state = container.read(bootstrapProvider);
      expect(state, BootstrapState.unauthenticated);
    },
  );
}
