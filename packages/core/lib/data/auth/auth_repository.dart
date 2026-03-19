import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final apiService = ref.read(authApiServiceProvider);
  final profileSyncContract = await ref.read(authProfileSyncContractProvider.future);
  final sessionManager = ref.read(sessionManagerProvider);
  return AuthRepository(
    apiService: apiService,
    profileSyncContract: profileSyncContract,
    sessionManager: sessionManager,
  );
});

class AuthRepository {
  const AuthRepository({
    required AuthApiService apiService,
    required AuthProfileSyncContract profileSyncContract,
    required SessionManager sessionManager,
  }) : _apiService = apiService,
       _profileSyncContract = profileSyncContract,
       _sessionManager = sessionManager;

  final AuthApiService _apiService;
  final AuthProfileSyncContract _profileSyncContract;
  final SessionManager _sessionManager;

  Future<UserDto> login({
    required String username,
    required String password,
  }) async {
    final result = await _apiService.login(
      username: username,
      password: password,
    );
    await _sessionManager.persistSession(authToken: result.token);
    final profile = await _refreshAndCacheCurrentUser();
    await _sessionManager.markProfileSyncedNow();
    return profile;
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) {
    return _apiService.generateOtp(
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      email: email,
    );
  }

  Future<UserDto> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) async {
    final result = await _apiService.verifyOtp(
      otp: otp,
      phoneNumber: phoneNumber,
      email: email,
    );
    await _sessionManager.persistSession(authToken: result.token);
    final profile = await _refreshAndCacheCurrentUser();
    await _sessionManager.markProfileSyncedNow();
    return profile;
  }

  Future<UserDto?> hydrateSession({
    required Duration profileRefreshTtl,
    void Function(UserDto cachedProfile)? onCachedProfile,
  }) {
    return _sessionManager.hydrateFromSession(
      getCachedProfile: _profileSyncContract.getCurrentUser,
      fetchFreshProfile: _profileSyncContract.refreshCurrentUser,
      profileRefreshTtl: profileRefreshTtl,
      onCachedProfile: onCachedProfile,
    );
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } finally {
      await _sessionManager.clearSession();
    }
  }

  Future<UserDto> _refreshAndCacheCurrentUser() async {
    return _profileSyncContract.refreshCurrentUser();
  }
}
