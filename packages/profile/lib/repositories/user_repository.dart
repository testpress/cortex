import 'package:core/data/data.dart';

/// Repository for managing user profile identity and metadata.
class UserRepository {
  final AppDatabase _db;
  final DataSource _source;

  UserRepository(this._db, this._source);

  /// Provides a reactive stream of the logged-in user profile from the database.
  Stream<UsersTableData?> watchCurrentUser() {
    return _db.select(_db.usersTable).watchSingleOrNull();
  }

  /// Fetches the cached profile metadata from the local database.
  Future<UsersTableData?> getCurrentProfile() async {
    return _db.select(_db.usersTable).getSingleOrNull();
  }

  /// Fetches the profile from the network and updates the local cache.
  Future<UserDto> refreshProfile() async {
    final user = await _source.getProfile();
    await _db.upsertUser(user.toCompanion());
    return user;
  }

  /// Persists profile changes to the backend and updates the local cache.
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final updated = await _source.updateProfile(data);
    await _db.upsertUser(updated.toCompanion());
  }
}
