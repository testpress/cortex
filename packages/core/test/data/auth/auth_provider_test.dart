import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/data/data.dart';
import 'package:core/data/auth/auth_repository.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'auth_provider_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  group('AuthProvider (Async)', () {
    test('initial state should be AsyncData(true) if repo says logged in', () async {
      // Arrange
      when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => true);

      // Act
      final state = await container.read(authProvider.future);

      // Assert
      expect(state, isTrue);
      verify(mockRepository.isUserLoggedIn()).called(1);
    });

    test('initial state should be AsyncData(false) if repo says NOT logged in', () async {
      // Arrange
      when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => false);

      // Act
      final state = await container.read(authProvider.future);

      // Assert
      expect(state, isFalse);
      verify(mockRepository.isUserLoggedIn()).called(1);
    });

    test('loginWithPassword should update state on success', () async {
      // Arrange
      when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => false);
      when(mockRepository.loginWithPassword(
        username: 'user',
        password: 'pass',
      )).thenAnswer((_) async => {});

      // Act
      await container.read(authProvider.notifier).loginWithPassword(
            username: 'user',
            password: 'pass',
          );

      // Assert
      final state = container.read(authProvider).value;
      expect(state, isTrue);
      verify(mockRepository.loginWithPassword(username: 'user', password: 'pass')).called(1);
    });

    test('logout should clear state to false', () async {
      // Arrange
      when(mockRepository.isUserLoggedIn()).thenAnswer((_) async => true);
      await container.read(authProvider.future);
      expect(container.read(authProvider).value, isTrue);

      // Act
      await container.read(authProvider.notifier).logout();

      // Assert
      expect(container.read(authProvider).value, isFalse);
      verify(mockRepository.logout()).called(1);
    });
  });
}
