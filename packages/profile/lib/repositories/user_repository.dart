import 'package:core/data/data.dart';
import 'package:drift/drift.dart';
import '../network/user_api_service.dart';

/// Repository for user profile resource operations.
class UserRepository {
  final AppDatabase _db;
  final UserApiService _apiService;

  UserRepository(this._db, this._apiService);

  /// Returns current user from local cache when available.
  Future<UserDto?> getCurrentUser() async {
    final cached = await _db.getAnyUser();
    if (cached == null) return null;
    return _mapToDto(cached);
  }

  Future<UserDto?> getCachedProfile() => getCurrentUser();

  /// Persists the provided profile to local storage.
  Future<void> saveProfile(UserDto profile) async {
    await _db.upsertUser(
      UsersTableCompanion.insert(
        id: profile.id,
        name: profile.name,
        email: Value(profile.email),
        phone: Value(profile.phone),
        avatar: Value(profile.avatar),
        isPro: Value(profile.isPro),
        joinedDate: Value(profile.joinedDate),
      ),
    );
  }

  Future<UserDto> refreshCurrentUser() async {
    final profile = await _apiService.fetchCurrentUser();
    await saveProfile(profile);
    return profile;
  }

  Future<UserDto> updateCurrentUser({
    required String name,
    String? phone,
  }) async {
    final profile = await _apiService.updateCurrentUser(
      name: name,
      phone: phone,
    );
    await saveProfile(profile);
    return profile;
  }

  UserDto _mapToDto(UsersTableData r) {
    return UserDto(
      id: r.id,
      name: r.name,
      email: r.email,
      phone: r.phone,
      avatar: r.avatar,
      isPro: r.isPro,
      joinedDate: r.joinedDate,
    );
  }

}
