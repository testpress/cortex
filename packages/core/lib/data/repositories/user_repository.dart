import 'package:drift/drift.dart';
import 'package:core/data/data.dart';

/// Repository for managing both user identity and progress.
class UserRepository {
  final AppDatabase _db;
  final DataSource _source;

  UserRepository(this._db, this._source);

  /// Returns cached user profile when available.
  Future<UserDto?> getCachedProfile() async {
    final cached = await _db.getAnyUser();
    if (cached == null) return null;
    return _mapToDto(cached);
  }

  /// Refetches the current user profile from the API/Mock source and updates the local DB.
  Future<UserDto> refreshProfile() async {
    final profile = await _source.getUserProfile();
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

  // ── User Progress ──────────────────────────────────────────────────────

  Stream<List<UserProgressDto>> watchProgress(String userId) {
    return _db
        .watchProgressForUser(userId)
        .map(
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
}
