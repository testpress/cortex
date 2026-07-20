import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/data/data.dart';
import 'package:core/data/auth/auth_repository.dart';
import 'package:core/data/repositories/user_repository.dart';
import 'package:core/data/providers/user_provider.dart';

@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<AuthRepository>()])
import 'user_provider_test.mocks.dart';

void main() {
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();
  });

  ProviderContainer makeContainer({required bool isLoggedIn}) {
    when(
      mockAuthRepository.isUserLoggedIn(),
    ).thenAnswer((_) async => isLoggedIn);

    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWith((ref) async => mockUserRepository),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('userProvider', () {
    final testUser = UsersTableData(
      id: '123',
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
    );

    test('returns null when not logged in', () async {
      final container = makeContainer(isLoggedIn: false);
      await container.read(authProvider.future);
      final user = await container.read(userProvider.future);
      expect(user, isNull);
    });

    test('streams user from repository when logged in', () async {
      when(
        mockUserRepository.watchCurrentUser(),
      ).thenAnswer((_) => Stream.value(testUser));

      final container = makeContainer(isLoggedIn: true);
      await container.read(authProvider.future);
      final user = await container.read(userProvider.future);

      expect(user, equals(testUser));
      verify(mockUserRepository.watchCurrentUser()).called(1);
    });
  });
}
