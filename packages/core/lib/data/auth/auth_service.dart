import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final client = ref.read(authClientProvider);
  final userRepository = await ref.read(userRepositoryProvider.future);
  final sessionManager = ref.read(sessionManagerProvider);
  return AuthService(
    client: client,
    userRepository: userRepository,
    sessionManager: sessionManager,
  );
});

class AuthService {
  const AuthService({
    required AuthClient client,
    required UserRepository userRepository,
    required SessionManager sessionManager,
  }) : _client = client,
       _userRepository = userRepository,
       _sessionManager = sessionManager;

  final AuthClient _client;
  final UserRepository _userRepository;
  final SessionManager _sessionManager;

  Future<UserDto> login({
    required String username,
    required String password,
  }) async {
    final result = await _client.login(username: username, password: password);
    await _sessionManager.persistSession(
      authToken: result.token,
    );

    final profile = await _fetchAndCacheProfile();
    await _sessionManager.markProfileSyncedNow();
    return profile;
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) {
    return _client.generateOtp(
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
    final result = await _client.verifyOtp(
      otp: otp,
      phoneNumber: phoneNumber,
      email: email,
    );

    await _sessionManager.persistSession(
      authToken: result.token,
    );

    final profile = await _fetchAndCacheProfile();
    await _sessionManager.markProfileSyncedNow();
    return profile;
  }

  Future<void> logout() => _sessionManager.clearSession();

  Future<UserDto?> refreshFromSession({
    required Duration profileRefreshTtl,
    void Function(UserDto cachedProfile)? onCachedProfile,
  }) {
    return _sessionManager.hydrateFromSession(
      getCachedProfile: _userRepository.getCachedProfile,
      fetchFreshProfile: _fetchAndCacheProfile,
      profileRefreshTtl: profileRefreshTtl,
      onCachedProfile: onCachedProfile,
    );
  }

  Future<UserDto> _fetchAndCacheProfile() async {
    final profile = await _client.fetchProfile();
    await _userRepository.saveProfile(profile);
    return profile;
  }
}
