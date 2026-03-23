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
  FutureOr<bool> build() async {
    return await _repository.isUserLoggedIn();
  }

  Future<void> loginWithPassword({
    required String username,
    required String password,
  }) async {
    await _repository.loginWithPassword(
      username: username,
      password: password,
    );
    
    state = const AsyncData(true);
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
    await _repository.verifyOtp(
      otp: otp,
      phoneNumber: phoneNumber,
      email: email,
    );

    state = const AsyncData(true);
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = const AsyncData(false);
    } catch (e) {
      state = const AsyncData(false);
      rethrow;
    }
  }
}
