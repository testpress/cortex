import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_config.dart';

import 'auth_api_service.dart';
import 'auth_local_data_source.dart';
import 'auth_repository.dart';
import '../../network/dio_provider.dart';
import '../db/database_provider.dart';
import '../sources/data_source_provider.dart';
import '../../domain/usecases/app_reset_use_case.dart';
import '../services/sentry_service.dart';
import '../providers/user_provider.dart';

part 'auth_provider.g.dart';

final authApiServiceProvider = Provider((ref) {
  return AuthApiService(
    dio: ref.watch(dioProvider),
    sentryService: ref.watch(sentryServiceProvider),
  );
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  final serverClientId = AppConfig.googleServerClientId;
  return serverClientId.isNotEmpty
      ? GoogleSignIn(serverClientId: serverClientId)
      : GoogleSignIn();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiService: ref.watch(authApiServiceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    dataSource: ref.watch(dataSourceProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

/// Holds the session-expired message from a 401 response.
/// `null` = no session expiry in progress.
/// Non-null = show the SessionExpiredDialog with this message.
final sessionExpiredProvider = StateProvider<String?>((ref) => null);

/// Cached pre-boot auth signal set in main() before runApp().
///
/// This is the synchronous routing hint used by [goRouterProvider] to set
/// [initialLocation] correctly on cold start — read from [AuthLocalDataSource]
/// before [runApp] via [AuthLocalDataSource.checkCachedLogin].
///
/// [authProvider] still performs full async verification after launch.
/// Must be overridden in [ProviderScope] with the result of that pre-boot check.
final cachedAuthFlagProvider = Provider<bool>((ref) => false);

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  /// Tracks the in-flight logout cleanup so login methods can wait for it
  /// before writing new session data to the DB.
  Future<void> _cleanupFuture = Future.value();

  @override
  FutureOr<bool> build() async {
    return await _repository.isUserLoggedIn();
  }

  Future<void> loginWithPassword({
    required String username,
    required String password,
  }) async {
    // Wait for any in-flight logout cleanup to finish before writing
    // new session data — prevents stale cleanup from wiping a fresh login.
    await _cleanupFuture;
    await _repository.loginWithPassword(username: username, password: password);

    state = const AsyncData(true);
  }

  Future<void> loginWithGoogle() async {
    await _cleanupFuture;
    await _repository.loginWithGoogle();

    state = const AsyncData(true);
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? phone,
    String? countryCode,
  }) async {
    await _cleanupFuture;
    await _repository.register(
      username: username,
      email: email,
      password: password,
      phone: phone,
      countryCode: countryCode,
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
    await _cleanupFuture;
    await _repository.verifyOtp(
      otp: otp,
      phoneNumber: phoneNumber,
      email: email,
    );

    state = const AsyncData(true);
  }

  Future<void> logout() async {
    // Flip auth state immediately — router redirects to Login on this frame.
    // Store the cleanup work in _cleanupFuture so login methods can gate on it.
    state = const AsyncData(false);
    _cleanupFuture = _runCleanup();
  }

  Future<void> _runCleanup() async {
    try {
      // Safety net: explicitly clear the user row to guarantee no stale data leaks if the full purge fails
      final userRepo = await ref.read(userRepositoryProvider.future);
      await userRepo.clearCurrentUser();

      final resetUseCase = await ref.read(appResetUseCaseProvider.future);
      await resetUseCase.execute();

      await _repository.logout();
    } catch (e, stackTrace) {
      ref
          .read(sentryServiceProvider)
          .captureException(
            e,
            stackTrace: stackTrace,
            level: AppErrorLevel.error,
          );
    }
  }

  Future<void> logoutOtherDevices() async {
    await _repository.logoutOtherDevices();
    // Re-verify the session — if the restriction is cleared, mark as authenticated.
    await _repository.verifyLogin();
    state = const AsyncData(true);
  }
}

@Riverpod(keepAlive: true)
Stream<String?> userId(UserIdRef ref) async* {
  final db = await ref.watch(appDatabaseProvider.future);
  yield* db.select(db.usersTable).watchSingleOrNull().map((user) => user?.id);
}
