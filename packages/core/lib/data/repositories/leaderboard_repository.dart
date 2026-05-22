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

  Stream<List<LearnerDto>> watchLeaderboard(LeaderboardTimeline timeline, {int? limit}) {
    switch (timeline) {
      case LeaderboardTimeline.thisWeek:
        return _db.watchWeeklyLeaderboard(limit: limit).map((rows) => rows.map(_mapWeekly).toList());
      case LeaderboardTimeline.thisMonth:
        return _db.watchMonthlyLeaderboard(limit: limit).map((rows) => rows.map(_mapMonthly).toList());
      case LeaderboardTimeline.allTime:
        return _db.watchAllTimeLeaderboard(limit: limit).map((rows) => rows.map(_mapAllTime).toList());
    }
  }

  LearnerDto _mapWeekly(WeeklyLeaderboardData row) => _toLearnerDto(
        id: row.id,
        rank: row.rank,
        name: row.name,
        avatar: row.avatar,
        points: row.points,
        coursesCompleted: row.coursesCompleted,
        streakDays: row.streakDays,
      );

  LearnerDto _mapMonthly(MonthlyLeaderboardData row) => _toLearnerDto(
        id: row.id,
        rank: row.rank,
        name: row.name,
        avatar: row.avatar,
        points: row.points,
        coursesCompleted: row.coursesCompleted,
        streakDays: row.streakDays,
      );

  LearnerDto _mapAllTime(AllTimeLeaderboardData row) => _toLearnerDto(
        id: row.id,
        rank: row.rank,
        name: row.name,
        avatar: row.avatar,
        points: row.points,
        coursesCompleted: row.coursesCompleted,
        streakDays: row.streakDays,
      );

  LearnerDto _toLearnerDto({
    required String id,
    required int rank,
    required String name,
    required String? avatar,
    required double points,
    required int coursesCompleted,
    required int streakDays,
  }) {
    return LearnerDto(
      id: id,
      rank: rank,
      name: name,
      avatar: avatar ?? '',
      points: points,
      coursesCompleted: coursesCompleted,
      streakDays: streakDays,
    );
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
