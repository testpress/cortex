import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/data/data.dart';
import 'package:core/data/auth/auth_repository.dart';

import 'package:core/domain/usecases/app_reset_use_case.dart';

import 'package:core/data/repositories/user_repository.dart';
import 'package:core/data/providers/user_provider.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<AppResetUseCase>(),
  MockSpec<UserRepository>(),
])
import 'auth_provider_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockRepository;
  late MockAppResetUseCase mockResetUseCase;
  late MockUserRepository mockUserRepo;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockResetUseCase = MockAppResetUseCase();
    mockUserRepo = MockUserRepository();

    when(mockResetUseCase.execute()).thenAnswer((_) async {});
    when(mockUserRepo.clearCurrentUser()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
        appResetUseCaseProvider.overrideWith((ref) => mockResetUseCase),
        userRepositoryProvider.overrideWith((ref) async => mockUserRepo),
      ],
    );
  });

  group('AuthProvider (Async)', () {
    test(
      'initial state should be AsyncData(true) if repo says logged in',
      () async {
        // Arrange
        when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => true);

        // Act
        final state = await container.read(authProvider.future);

        // Assert
        expect(state, isTrue);
        verify(mockRepository.isUserLoggedIn()).called(1);
      },
    );

    test(
      'initial state should be AsyncData(false) if repo says NOT logged in',
      () async {
        // Arrange
        when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => false);

        // Act
        final state = await container.read(authProvider.future);

        // Assert
        expect(state, isFalse);
        verify(mockRepository.isUserLoggedIn()).called(1);
      },
    );

    test('loginWithPassword should update state on success', () async {
      // Arrange
      when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => false);
      when(
        mockRepository.loginWithPassword(username: 'user', password: 'pass'),
      ).thenAnswer((_) async => {});

      // Act
      await container
          .read(authProvider.notifier)
          .loginWithPassword(username: 'user', password: 'pass');

      // Assert
      final state = container.read(authProvider).value;
      expect(state, isTrue);
      verify(
        mockRepository.loginWithPassword(username: 'user', password: 'pass'),
      ).called(1);
    });

    test('logout should clear state to false', () async {
      // Arrange
      when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => true);
      await container.read(authProvider.future);
      expect(container.read(authProvider).value, isTrue);

      // Act
      // logout() fires cleanup in the background — drain the event queue so
      // all async hops in _runCleanup() complete before verifying mock calls.
      await container.read(authProvider.notifier).logout();
      await pumpEventQueue();

      // Assert
      expect(container.read(authProvider).value, isFalse);
      verify(mockResetUseCase.execute()).called(1);
      verify(mockRepository.logout()).called(1);
    });

    // Regression: auth state must flip to false synchronously on logout(),
    // before any cleanup awaits, so the router redirects on the same frame.
    test(
      'logout flips state to false synchronously before cleanup completes',
      () async {
        // Arrange
        when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => true);
        await container.read(authProvider.future);

        final cleanupStarted = Completer<void>();
        final cleanupGate = Completer<void>();

        when(mockUserRepo.clearCurrentUser()).thenAnswer((_) async {
          cleanupStarted.complete();
          await cleanupGate.future; // block cleanup mid-flight
        });

        // Act — fire logout but don't await it; it returns immediately after
        // flipping state, while cleanup is still blocked above.
        final logoutFuture = container.read(authProvider.notifier).logout();

        // Wait until cleanup has actually started (proving it's in-flight)
        await cleanupStarted.future;

        // Assert — state is already false even though cleanup hasn't finished
        expect(
          container.read(authProvider).value,
          isFalse,
          reason:
              'auth state must flip synchronously so the router can redirect '
              'on the same frame, before cleanup completes',
        );

        // Unblock cleanup and finish the logout
        cleanupGate.complete();
        await logoutFuture;
      },
    );

    // Regression: a login attempted while logout cleanup is still running
    // must not proceed until cleanup finishes — prevents stale cleanup from
    // wiping the new session's freshly-written user row or cached data.
    test(
      'loginWithPassword waits for in-flight logout cleanup before writing',
      () async {
        // Arrange
        when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => true);
        await container.read(authProvider.future);

        final cleanupGate = Completer<void>();
        final loginCalled = Completer<void>();

        // Block cleanup mid-flight
        when(mockUserRepo.clearCurrentUser()).thenAnswer((_) async {
          await cleanupGate.future;
        });

        // loginWithPassword should not be called until cleanup gate opens
        when(
          mockRepository.loginWithPassword(username: 'user', password: 'pass'),
        ).thenAnswer((_) async {
          loginCalled.complete();
        });

        // Act — logout (cleanup blocked), then immediately attempt login
        final logoutFuture = container.read(authProvider.notifier).logout();
        final loginFuture = container
            .read(authProvider.notifier)
            .loginWithPassword(username: 'user', password: 'pass');

        // Give a short window — login must NOT have proceeded yet
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(
          loginCalled.isCompleted,
          isFalse,
          reason:
              'loginWithPassword must not write data while cleanup is still '
              'in-flight',
        );

        // Unblock cleanup
        cleanupGate.complete();
        await logoutFuture;

        // Now login should complete
        await loginFuture;
        expect(loginCalled.isCompleted, isTrue);
        expect(container.read(authProvider).value, isTrue);
      },
    );
  });
}
