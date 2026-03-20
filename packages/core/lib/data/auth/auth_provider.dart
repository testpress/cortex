import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_dto.dart';
import '../sources/mock_data.dart';
import 'auth_api_service.dart';
import 'auth_local_data_source.dart';
import 'auth_repository.dart';

part 'auth_provider.g.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiService: ref.read(authApiServiceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  FutureOr<UserDto?> build() async {
    // This is called automatically when the provider is first read.
    // It handles the cold-start session recovery.
    final isLoggedIn = await _repository.isUserLoggedIn();
    if (isLoggedIn) {
      // TODO: Replace with real user from /me API
      return mockCurrentUser;
    }
    return null;
  }

  Future<void> loginWithPassword({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.loginWithPassword(
        username: username,
        password: password,
      );
      // TODO: Replace with real user from /me API
      return mockCurrentUser;
    });
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) async {
    await _repository.generateOtp(
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      email: email,
    );
  }

  Future<void> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.verifyOtp(
        otp: otp,
        phoneNumber: phoneNumber,
        email: email,
      );
      // TODO: Replace with real user from /me API
      return mockCurrentUser;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.logout();
      return null;
    });
  }

  void updateProfile(UserDto newUser) {
    state = AsyncData(newUser);
  }
}
