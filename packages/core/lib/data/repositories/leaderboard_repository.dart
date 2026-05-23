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
        return _db.watchWeeklyLeaderboard(limit: limit).map((rows) => rows.map((r) => r.toDto()).toList());
      case LeaderboardTimeline.thisMonth:
        return _db.watchMonthlyLeaderboard(limit: limit).map((rows) => rows.map((r) => r.toDto()).toList());
      case LeaderboardTimeline.allTime:
        return _db.watchAllTimeLeaderboard(limit: limit).map((rows) => rows.map((r) => r.toDto()).toList());
    }
  }

  Future<void> refreshLeaderboard(LeaderboardTimeline timeline, {int limit = 10, int page = 1}) async {
    try {
      final freshLearners = await _dataSource.fetchLeaderboard(
        timeline: timeline,
        limit: limit,
        page: page,
      );

      final companions = <Insertable>[];
      for (final dto in freshLearners) {
        switch (timeline) {
          case LeaderboardTimeline.thisWeek:
            companions.add(dto.toWeeklyCompanion(page));
            break;
          case LeaderboardTimeline.thisMonth:
            companions.add(dto.toMonthlyCompanion(page));
            break;
          case LeaderboardTimeline.allTime:
            companions.add(dto.toAllTimeCompanion(page));
            break;
        }
      }

      await _db.saveLeaderboardPage(
        timeline: timeline,
        page: page,
        rows: companions,
      );
    } catch (e) {
      debugPrint('LeaderboardRepository: Failed to refresh leaderboard ($timeline): $e');
    }
  }

  /// Fetches the current user's competitors (above and below).
  /// This completely bypasses the local DB and fetches directly from the API.
  Future<List<LearnerDto>> getCompetitors() async {
    final futures = await Future.wait([
      _dataSource.fetchMyRank(),
      _dataSource.fetchCompetitorTargets(),
      _dataSource.fetchCompetitorThreats(),
    ]);

    final myRankData = futures[0] as LearnerDto;
    final targetsData = futures[1] as List<LearnerDto>;
    final threatsData = futures[2] as List<LearnerDto>;

    return _assembleCompetitors(myRankData, targetsData, threatsData);
  }

  List<LearnerDto> _assembleCompetitors(
    LearnerDto myRankData,
    List<LearnerDto> targetsData,
    List<LearnerDto> threatsData,
  ) {
    final int currentUserRank = myRankData.rank;
    final double currentUserTrophies = myRankData.points;
    final List<LearnerDto> competitors = [];

    // Targets (Above)
    for (int i = 0; i < targetsData.length; i++) {
      final int offset = targetsData.length - i;
      final int approxRank = currentUserRank - offset < 1 ? 1 : currentUserRank - offset;
      competitors.add(targetsData[i].copyWith(rank: approxRank));
    }

    // Current User
    competitors.add(myRankData.copyWith(isCurrentUser: true));

    // Threats (Below)
    int currentThreatRank = currentUserRank;
    for (int i = 0; i < threatsData.length; i++) {
      final threatData = threatsData[i];
      final threatTrophies = threatData.points;
      
      if (threatTrophies == currentUserTrophies) {
        // Tied
        competitors.add(threatData.copyWith(rank: currentUserRank));
      } else {
        currentThreatRank++;
        competitors.add(threatData.copyWith(rank: currentThreatRank));
      }
    }

    return competitors;
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

// ── Private Mapping Helpers ───────────────────────────────────────────────────
// These extensions isolate the tedious field-by-field mapping from repository
// business logic. Adding or renaming a column only requires updating here.

LearnerDto _buildDto({
  required String id,
  required int rank,
  required String name,
  required String? avatar,
  required double points,
  required int coursesCompleted,
  required int streakDays,
}) =>
    LearnerDto(
      id: id,
      rank: rank,
      name: name,
      avatar: avatar ?? '',
      points: points,
      coursesCompleted: coursesCompleted,
      streakDays: streakDays,
    );

// ── Database Row → Domain DTO ─────────────────────────────────────────────────

extension on WeeklyLeaderboardData {
  LearnerDto toDto() => _buildDto(
        id: id,
        rank: rank,
        name: name,
        avatar: avatar,
        points: points,
        coursesCompleted: coursesCompleted,
        streakDays: streakDays,
      );
}

extension on MonthlyLeaderboardData {
  LearnerDto toDto() => _buildDto(
        id: id,
        rank: rank,
        name: name,
        avatar: avatar,
        points: points,
        coursesCompleted: coursesCompleted,
        streakDays: streakDays,
      );
}

extension on AllTimeLeaderboardData {
  LearnerDto toDto() => _buildDto(
        id: id,
        rank: rank,
        name: name,
        avatar: avatar,
        points: points,
        coursesCompleted: coursesCompleted,
        streakDays: streakDays,
      );
}

// ── Domain DTO → Database Companion ──────────────────────────────────────────

extension on LearnerDto {
  WeeklyLeaderboardTableCompanion toWeeklyCompanion(int page) =>
      WeeklyLeaderboardTableCompanion(
        id: Value(id),
        rank: Value(rank),
        name: Value(name),
        avatar: Value(avatar),
        points: Value(points),
        coursesCompleted: Value(coursesCompleted),
        streakDays: Value(streakDays),
        page: Value(page),
      );

  MonthlyLeaderboardTableCompanion toMonthlyCompanion(int page) =>
      MonthlyLeaderboardTableCompanion(
        id: Value(id),
        rank: Value(rank),
        name: Value(name),
        avatar: Value(avatar),
        points: Value(points),
        coursesCompleted: Value(coursesCompleted),
        streakDays: Value(streakDays),
        page: Value(page),
      );

  AllTimeLeaderboardTableCompanion toAllTimeCompanion(int page) =>
      AllTimeLeaderboardTableCompanion(
        id: Value(id),
        rank: Value(rank),
        name: Value(name),
        avatar: Value(avatar),
        points: Value(points),
        coursesCompleted: Value(coursesCompleted),
        streakDays: Value(streakDays),
        page: Value(page),
      );
}
