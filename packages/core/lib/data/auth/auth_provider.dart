import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

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
/// Manages session persistence via [SessionStorage] and profile sync via [AuthRepository].
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  static const Duration _profileRefreshTtl = Duration(minutes: 5);
  Future<UserDto?>? _hydrationFuture;

  @override
  AuthState build() {
    final sessionManager = ref.read(sessionManagerProvider);
    final hasSession = sessionManager.hasSession;

    if (hasSession) {
      _hydrateFromSession();
      return const AuthState.hydrating();
    }

    return const AuthState.unauthenticated();
  }

  Future<UserDto?> _hydrateFromSession() async {
    if (_hydrationFuture != null) {
      return _hydrationFuture!;
    }
    _hydrationFuture = _runHydration();
    final result = await _hydrationFuture!;
    _hydrationFuture = null;
    return result;
  }

  Future<UserDto?> _runHydration() async {
    final repository = await ref.read(authRepositoryProvider.future);
    final profile = await repository.hydrateSession(
      profileRefreshTtl: _profileRefreshTtl,
      onCachedProfile: (cached) {
        state = AuthState.hydrating(cached);
      },
    );
    if (profile != null) {
      state = AuthState.authenticated(profile);
    }
    return profile;
  }

  Future<UserDto?> refreshFromSession() => _hydrateFromSession();

  Future<void> login(String username, String password) async {
    final repository = await ref.read(authRepositoryProvider.future);
    final profile = await repository.login(
      username: username,
      password: password,
    );
    state = AuthState.authenticated(profile);
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) async {
    final repository = await ref.read(authRepositoryProvider.future);
    await repository.generateOtp(
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
    final repository = await ref.read(authRepositoryProvider.future);
    final profile = await repository.verifyOtp(
      otp: otp,
      phoneNumber: phoneNumber,
      email: email,
    );
    state = AuthState.authenticated(profile);
  }

  Future<void> logout() async {
    final repository = await ref.read(authRepositoryProvider.future);
    await repository.logout();
    final sessionManager = ref.read(sessionManagerProvider);
    sessionManager.resetHydrationState();
    _hydrationFuture = null;
    state = const AuthState.unauthenticated();
  }

  void updateProfile(UserDto newUser) {
    state = AuthState.authenticated(newUser);
  }
}
