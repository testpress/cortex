import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../models/user_progress_dto.dart';
import '../sources/data_source.dart';

/// Repository for user progress tracking.
class UserRepository {
  final AppDatabase _db;
  final DataSource _source;

  UserRepository(this._db, this._source);

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
