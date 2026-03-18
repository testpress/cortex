import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_dto.dart';
import 'session_storage.dart';

final sessionManagerProvider = Provider<SessionManager>((ref) {
  return SessionManager(SessionStorage.instance);
});

class SessionManager {
  SessionManager(this._storage);

  final SessionStorage _storage;

  bool _hydrationTriggered = false;
  Future<UserDto?>? _hydrationFuture;

  bool get hasSession => _storage.hasSession;

  Future<void> persistSession({
    required String authToken,
    String? refreshToken,
  }) {
    return _storage.persistSession(
      authToken: authToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> markProfileSyncedNow() => _storage.markProfileSyncedNow();

  Future<void> clearSession() async {
    await _storage.clear();
    resetHydrationState();
  }

  void resetHydrationState() {
    _hydrationTriggered = false;
    _hydrationFuture = null;
  }

  Future<UserDto?> hydrateFromSession({
    required Future<UserDto?> Function() getCachedProfile,
    required Future<UserDto> Function() fetchFreshProfile,
    required Duration profileRefreshTtl,
    void Function(UserDto cachedProfile)? onCachedProfile,
  }) async {
    if (_hydrationFuture != null) {
      return _hydrationFuture!;
    }

    if (_hydrationTriggered) {
      return null;
    }

    _hydrationTriggered = true;
    _hydrationFuture = _runHydration(
      getCachedProfile: getCachedProfile,
      fetchFreshProfile: fetchFreshProfile,
      profileRefreshTtl: profileRefreshTtl,
      onCachedProfile: onCachedProfile,
    );

    final result = await _hydrationFuture!;
    _hydrationFuture = null;
    return result;
  }

  Future<UserDto?> _runHydration({
    required Future<UserDto?> Function() getCachedProfile,
    required Future<UserDto> Function() fetchFreshProfile,
    required Duration profileRefreshTtl,
    void Function(UserDto cachedProfile)? onCachedProfile,
  }) async {
    final cachedProfile = await getCachedProfile();
    if (cachedProfile != null) {
      onCachedProfile?.call(cachedProfile);
    }

    if (!_shouldRefreshProfile(profileRefreshTtl)) {
      return cachedProfile;
    }

    try {
      final refreshed = await fetchFreshProfile();
      await _storage.markProfileSyncedNow();
      return refreshed;
    } catch (_) {
      return cachedProfile;
    }
  }

  bool _shouldRefreshProfile(Duration ttl) {
    final lastSyncedAt = _storage.lastProfileSyncedAt;
    if (lastSyncedAt == null) return true;
    final age = DateTime.now().difference(lastSyncedAt);
    return age >= ttl;
  }
}
