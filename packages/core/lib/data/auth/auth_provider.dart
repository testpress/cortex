import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:flutter/foundation.dart';

part 'auth_provider.g.dart';

enum AuthStatus { unauthenticated, hydrating, authenticated }

class AuthState {
  const AuthState._({required this.phase, this.user});

  const AuthState.unauthenticated() : this._(phase: AuthStatus.unauthenticated);

  const AuthState.hydrating([UserDto? user])
    : this._(phase: AuthStatus.hydrating, user: user);

  const AuthState.authenticated(UserDto user)
    : this._(phase: AuthStatus.authenticated, user: user);

  final AuthStatus phase;
  final UserDto? user;

  UserDto get effectiveUser => user ?? const UserDto(id: '', name: 'Guest');
  bool get isAuthenticated => phase == AuthStatus.authenticated;
}

/// Provider for the currently authenticated user.
/// Manages session persistence via [SessionStorage] and profile sync via [UserRepository].
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  static const Duration _profileRefreshTtl = Duration(minutes: 5);
  bool _hydrationTriggered = false;
  Future<UserDto?>? _hydrationFuture;

  @override
  AuthState build() {
    // 1. Check if we have a persistent session token on disk
    final hasSession = SessionStorage.instance.hasSession;

    if (hasSession) {
      _hydrateFromSession();
      // Session exists but profile may still be hydrating.
      return const AuthState.hydrating();
    }

    // Default "guest" state if no session exists
    return const AuthState.unauthenticated();
  }

  Future<UserDto?> _hydrateFromSession() async {
    if (_hydrationFuture != null) {
      return _hydrationFuture!;
    }
    if (_hydrationTriggered) {
      final currentUser = state.user;
      if (currentUser != null && currentUser.id.isNotEmpty) {
        return currentUser;
      }
      return null;
    }
    _hydrationTriggered = true;
    _hydrationFuture = _runHydration();
    final result = await _hydrationFuture!;
    _hydrationFuture = null;
    return result;
  }

  Future<UserDto?> _runHydration() async {
    final repo = await ref.read(userRepositoryProvider.future);

    // 1. Cached-first: show local user immediately when available.
    final cachedProfile = await repo.getCachedProfile();
    if (cachedProfile != null) {
      state = AuthState.hydrating(cachedProfile);
    }

    // 2. Stale-while-revalidate with TTL.
    if (!_shouldRefreshProfile()) {
      return cachedProfile;
    }

    try {
      final profile = await repo.refreshProfile();
      state = AuthState.authenticated(profile);
      await SessionStorage.instance.markProfileSyncedNow();
      return profile;
    } catch (e, stackTrace) {
      debugPrint('Auth hydration failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      // 3. Offline-safe: keep cached state and do not force logout.
      return cachedProfile;
    }
  }

  Future<UserDto?> refreshFromSession() => _hydrateFromSession();

  bool _shouldRefreshProfile() {
    final lastSyncedAt = SessionStorage.instance.lastProfileSyncedAt;
    if (lastSyncedAt == null) return true;
    final age = DateTime.now().difference(lastSyncedAt);
    return age >= _profileRefreshTtl;
  }

  /// Perform a real login and update the internal session state.
  Future<void> login(String username, String password) async {
    final client = ref.read(authClientProvider);
    final repo = await ref.read(userRepositoryProvider.future);

    // 1. Hit the v2.5 Auth API
    final result = await client.login(username: username, password: password);
    final authToken = _requireAuthToken(result);

    // 2. Persist the tokens (using backend-provided keys)
    await SessionStorage.instance.persistSession(
      authToken: authToken,
      refreshToken: result['refresh'],
    );

    // 3. Fetch and persist the user profile
    final profile = await repo.refreshProfile();
    await SessionStorage.instance.markProfileSyncedNow();

    // 4. Update the reactive state
    state = AuthState.authenticated(profile);
  }

  /// Request an OTP for authentication.
  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) async {
    final client = ref.read(authClientProvider);
    await client.generateOtp(
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      email: email,
    );
  }

  /// Verify the OTP and update session state.
  Future<void> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) async {
    final client = ref.read(authClientProvider);
    final repo = await ref.read(userRepositoryProvider.future);

    final result = await client.verifyOtp(
      otp: otp,
      phoneNumber: phoneNumber,
      email: email,
    );
    final authToken = _requireAuthToken(result);

    await SessionStorage.instance.persistSession(
      authToken: authToken,
      refreshToken: result['refresh'],
    );

    final profile = await repo.refreshProfile();
    await SessionStorage.instance.markProfileSyncedNow();
    state = AuthState.authenticated(profile);
  }

  /// Terminates the current session and clears all tokens.
  Future<void> logout() async {
    await SessionStorage.instance.clear();
    _hydrationTriggered = false;
    _hydrationFuture = null;
    state = const AuthState.unauthenticated();
  }

  void updateProfile(UserDto newUser) {
    state = AuthState.authenticated(newUser);
  }

  String _requireAuthToken(Map<String, dynamic> result) {
    final token = result['token']?.toString().trim();
    if (token == null || token.isEmpty) {
      throw AuthException('Missing auth token in login response.');
    }
    return token;
  }
}
