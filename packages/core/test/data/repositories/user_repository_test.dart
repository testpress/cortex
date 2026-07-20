import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:drift/native.dart';
import 'package:core/data/data.dart';
import 'package:core/data/repositories/user_repository.dart';

@GenerateNiceMocks([MockSpec<DataSource>(as: #MockMockitoDataSource)])
import 'user_repository_test.mocks.dart';

void main() {
  late AppDatabase db;
  late MockMockitoDataSource mockSource;
  late UserRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockSource = MockMockitoDataSource();
    repository = UserRepository(db, mockSource);
  });

  tearDown(() async {
    await db.close();
  });

  group('UserRepository', () {
    final testUser = UserDto(
      id: '123',
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
    );

    test('getCurrentProfile returns null initially', () async {
      final user = await repository.getCurrentProfile();
      expect(user, isNull);
    });

    test('watchCurrentUser emits null initially', () async {
      final stream = repository.watchCurrentUser();
      expect(await stream.first, isNull);
    });

    test('refreshProfile fetches from source and saves to db', () async {
      when(mockSource.getProfile()).thenAnswer((_) async => testUser);

      final result = await repository.refreshProfile();

      expect(result, equals(testUser));
      verify(mockSource.getProfile()).called(1);

      final cachedUser = await repository.getCurrentProfile();
      expect(cachedUser?.id, equals('123'));
      expect(cachedUser?.username, equals('testuser'));
    });
  });
}
