import 'package:drift/drift.dart';

import 'package:core/data/data.dart';

/// Repository for user progress tracking.
class UserRepository {
  final AppDatabase _db;
  final DataSource _source;

  UserRepository(this._db, this._source);

  Stream<List<UserProgressDto>> watchProgress(String userId) {
    return _db.watchProgressForUser(userId).map(
          (rows) => rows
              .map(
                (r) => UserProgressDto(
                  userId: r.userId,
                  lessonId: r.lessonId,
                  courseId: r.courseId,
                  percentComplete: r.percentComplete,
                  lastAccessedAt: r.lastAccessedAt,
                ),
              )
              .toList(),
        );
  }

  Future<void> refreshProgress(String userId) async {
    final progress = await _source.getUserProgress(userId);
    final companions = progress
        .map(
          (dto) => UserProgressTableCompanion.insert(
            userId: dto.userId,
            lessonId: dto.lessonId,
            courseId: dto.courseId,
            percentComplete: Value(dto.percentComplete),
            lastAccessedAt: dto.lastAccessedAt,
          ),
        )
        .toList();
    await _db.upsertProgress(companions);
  }

  Future<void> updateProgress(UserProgressDto dto) async {
    await _db.upsertProgress([
      UserProgressTableCompanion.insert(
        userId: dto.userId,
        lessonId: dto.lessonId,
        courseId: dto.courseId,
        percentComplete: Value(dto.percentComplete),
        lastAccessedAt: dto.lastAccessedAt,
      ),
    ]);
  }

  // ── Profile ──────────────────────────────────────────────────────────────

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
