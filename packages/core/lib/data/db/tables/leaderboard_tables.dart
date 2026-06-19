import 'package:drift/drift.dart';

mixin LeaderboardColumns on Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatar => text().nullable()();
  RealColumn get points => real()();
  IntColumn get rank => integer()();
  IntColumn get page => integer().withDefault(const Constant(1))();
}

@DataClassName('WeeklyLeaderboardData')
@TableIndex(name: 'weekly_rank_idx', columns: {#rank})
@TableIndex(name: 'weekly_points_idx', columns: {#points})
class WeeklyLeaderboardTable extends Table with LeaderboardColumns {
  @override
  String get tableName => 'weekly_leaderboard';

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MonthlyLeaderboardData')
@TableIndex(name: 'monthly_rank_idx', columns: {#rank})
@TableIndex(name: 'monthly_points_idx', columns: {#points})
class MonthlyLeaderboardTable extends Table with LeaderboardColumns {
  @override
  String get tableName => 'monthly_leaderboard';

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AllTimeLeaderboardData')
@TableIndex(name: 'all_time_rank_idx', columns: {#rank})
@TableIndex(name: 'all_time_points_idx', columns: {#points})
class AllTimeLeaderboardTable extends Table with LeaderboardColumns {
  @override
  String get tableName => 'all_time_leaderboard';

  @override
  Set<Column> get primaryKey => {id};
}
