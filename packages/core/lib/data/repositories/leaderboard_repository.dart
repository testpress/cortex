import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../data.dart';

part 'leaderboard_repository.g.dart';

class LeaderboardRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  LeaderboardRepository({
    required DataSource dataSource,
    required AppDatabase db,
  })  : _dataSource = dataSource,
        _db = db;

  Stream<List<LearnerDto>> watchLeaderboard(LeaderboardTimeline timeline, {int? limit}) async* {
    switch (timeline) {
      case LeaderboardTimeline.thisWeek:
        yield* _db.watchWeeklyLeaderboard(limit: limit).map((rows) => rows
            .map((row) => LearnerDto(
                  id: row.id,
                  rank: row.rank,
                  name: row.name,
                  avatar: row.avatar ?? '',
                  points: row.points,
                  coursesCompleted: row.coursesCompleted,
                  streakDays: row.streakDays,
                ))
            .toList());
        break;
      case LeaderboardTimeline.thisMonth:
        yield* _db.watchMonthlyLeaderboard(limit: limit).map((rows) => rows
            .map((row) => LearnerDto(
                  id: row.id,
                  rank: row.rank,
                  name: row.name,
                  avatar: row.avatar ?? '',
                  points: row.points,
                  coursesCompleted: row.coursesCompleted,
                  streakDays: row.streakDays,
                ))
            .toList());
        break;
      case LeaderboardTimeline.allTime:
        yield* _db.watchAllTimeLeaderboard(limit: limit).map((rows) => rows
            .map((row) => LearnerDto(
                  id: row.id,
                  rank: row.rank,
                  name: row.name,
                  avatar: row.avatar ?? '',
                  points: row.points,
                  coursesCompleted: row.coursesCompleted,
                  streakDays: row.streakDays,
                ))
            .toList());
        break;
    }
  }

  Future<void> refreshLeaderboard(LeaderboardTimeline timeline, {int limit = 10, int page = 1}) async {
    try {
      final freshLearners = await _dataSource.fetchLeaderboard(
        timeline: timeline,
        limit: limit,
        page: page,
      );

      List<Insertable> companions;
      switch (timeline) {
        case LeaderboardTimeline.thisWeek:
          companions = freshLearners
              .map((dto) => WeeklyLeaderboardTableCompanion(
                    id: Value(dto.id),
                    rank: Value(dto.rank),
                    name: Value(dto.name),
                    avatar: Value(dto.avatar),
                    points: Value(dto.points),
                    coursesCompleted: Value(dto.coursesCompleted),
                    streakDays: Value(dto.streakDays),
                    page: Value(page),
                  ))
              .toList();
          break;
        case LeaderboardTimeline.thisMonth:
          companions = freshLearners
              .map((dto) => MonthlyLeaderboardTableCompanion(
                    id: Value(dto.id),
                    rank: Value(dto.rank),
                    name: Value(dto.name),
                    avatar: Value(dto.avatar),
                    points: Value(dto.points),
                    coursesCompleted: Value(dto.coursesCompleted),
                    streakDays: Value(dto.streakDays),
                    page: Value(page),
                  ))
              .toList();
          break;
        case LeaderboardTimeline.allTime:
          companions = freshLearners
              .map((dto) => AllTimeLeaderboardTableCompanion(
                    id: Value(dto.id),
                    rank: Value(dto.rank),
                    name: Value(dto.name),
                    avatar: Value(dto.avatar),
                    points: Value(dto.points),
                    coursesCompleted: Value(dto.coursesCompleted),
                    streakDays: Value(dto.streakDays),
                    page: Value(page),
                  ))
              .toList();
          break;
      }

      await _db.saveLeaderboardPage(
        timeline: timeline,
        page: page,
        rows: companions,
      );
    } catch (e) {
      debugPrint('DEBUG: Failed to fetch leaderboard ($timeline): $e');
    }
  }
}

@Riverpod(keepAlive: true)
Future<LeaderboardRepository> leaderboardRepository(LeaderboardRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dataSource = ref.watch(dataSourceProvider);
  return LeaderboardRepository(
    dataSource: dataSource,
    db: db,
  );
}
