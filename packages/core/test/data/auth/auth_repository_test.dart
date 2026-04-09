import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/data/data.dart';
import 'package:core/data/auth/auth_api_service.dart';
import 'package:core/data/auth/auth_local_data_source.dart';
import 'package:core/data/auth/auth_repository.dart';

@GenerateNiceMocks([
  MockSpec<AuthApiService>(),
  MockSpec<AuthLocalDataSource>(),
  MockSpec<AppDatabase>(),
])
import 'auth_repository_test.mocks.dart';

void main() {
  late AuthRepository repository;
  late MockAuthApiService mockApi;
  late MockAuthLocalDataSource mockLocal;
  late MockAppDatabase mockDatabase;

  setUp(() {
    mockApi = MockAuthApiService();
    mockLocal = MockAuthLocalDataSource();
    mockDatabase = MockAppDatabase();

    repository = AuthRepository(
      apiService: mockApi,
      localDataSource: mockLocal,
      database: Future.value(mockDatabase),
    );

    // Mock the database purge call
    when(mockDatabase.purgeAllData()).thenAnswer((_) async => {});
  });

  group('AuthRepository', () {
    test('loginWithPassword should call API and save token on success', () async {
      // Arrange
      const token = 'fake_token';
      when(mockApi.loginWithPassword(
        username: 'user',
        password: 'pass',
      )).thenAnswer((_) async => const AuthApiResult(authToken: token));

      // Act
      await repository.loginWithPassword(username: 'user', password: 'pass');

      // Assert
      verify(mockApi.loginWithPassword(username: 'user', password: 'pass')).called(1);
      verify(mockLocal.saveToken(token)).called(1);
    });

    test('loginWithPassword should rethrow API exceptions and NOT save token', () async {
      // Arrange
      const error = AuthException('Login failed');
      when(mockApi.loginWithPassword(
        username: 'user',
        password: 'pass',
      )).thenThrow(error);

      // Act & Assert
      expect(
        () => repository.loginWithPassword(username: 'user', password: 'pass'),
        throwsA(isA<AuthException>()),
      );
      verify(mockApi.loginWithPassword(username: 'user', password: 'pass')).called(1);
      verifyNever(mockLocal.saveToken(any));
    });

    test('logout should call API and clear token even if API fails', () async {
      // Arrange
      when(mockLocal.getToken()).thenAnswer((_) async => 'old_token');
      when(mockApi.logout(authToken: anyNamed('authToken'))).thenThrow(const AuthException('API error'));

      // Act
      await repository.logout();

      // Assert
      verify(mockLocal.getToken()).called(1);
      verify(mockApi.logout(authToken: 'old_token')).called(1);
      verify(mockLocal.clearToken()).called(1);
      verify(mockDatabase.purgeAllData()).called(1);
    });

    test('isUserLoggedIn should delegate to local data source', () async {
      // Arrange
      when(mockLocal.isUserLoggedIn()).thenAnswer((_) async => true);

      // Act
      final result = await repository.isUserLoggedIn();

      // Assert
      expect(result, isTrue);
      verify(mockLocal.isUserLoggedIn()).called(1);
    });
  });
}
