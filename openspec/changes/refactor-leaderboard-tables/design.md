## Context

The system currently uses a single Drift `LearnersTable` inside `dashboard_tables.dart` with a single entry point `refreshLearners` and `watchLearners`. This was designed only for the weekly leaderboard.
To support Weekly, Monthly, and All-Time leaderboards with separate pagination and filtering, we need to restructure the persistence layer. Otherwise, primary key collisions will occur when a user exists in multiple leaderboards with different ranks or points.

To keep the database schema modular, type-safe, and scalable, we will extract the leaderboard tables from `dashboard_tables.dart` into a new dedicated file: `packages/core/lib/data/db/tables/leaderboard_tables.dart`.

## Goals / Non-Goals

**Goals:**
- Keep persistence DRY by using a Drift Table mixin.
- Isolate caching into a new dedicated schema file: `packages/core/lib/data/db/tables/leaderboard_tables.dart`.
- Support infinite scroll and pagination by adding a `page` column to the schema and setting a composite primary key `{id, page}`.
- Remove all `dynamic` database query return types to enforce compile-time type safety.
- Optimize query performance with indexes on `rank` and `points`.
- Map correct query parameters for timelines, returning `null` for `allTime` (which matches the backend contract).
- Provide clean, custom database table names for easier migration and maintenance.

**Non-Goals:**
- Designing the leaderboard frontend UI tabs or screens (this change focuses solely on the database, repository, and provider layer refactor).

## Decisions

### 1. Dedicated Schema File (`leaderboard_tables.dart`)
- **Rationale**: Since we are expanding from a single `LearnersTable` to three tables and a shared mixin, grouping these into their own file is much cleaner than keeping them mixed within `dashboard_tables.dart`.
- **Location**: `packages/core/lib/data/db/tables/leaderboard_tables.dart`

### 2. Drift Table Mixin (`LeaderboardColumns`)
- **Rationale**: All leaderboard tables share identical schema. Reusing them via a mixin avoids repeating column definitions across three tables.
- **Columns**: `id`, `name`, `avatar` (nullable), `points`, `rank`, `coursesCompleted`, `streakDays`, and `page` (with default value `1`).

### 3. Custom Table Names & Composite Keys
To ensure clean migrations and support infinite scroll/pagination, we override the table names explicitly and use composite primary keys:
- `WeeklyLeaderboardTable`: overrides `tableName` to `'weekly_leaderboard'`. Primary key: `{id, page}`.
- `MonthlyLeaderboardTable`: overrides `tableName` to `'monthly_leaderboard'`. Primary key: `{id, page}`.
- `AllTimeLeaderboardTable`: overrides `tableName` to `'all_time_leaderboard'`. Primary key: `{id, page}`.

### 4. Database Indexes
Add indexes on `rank` and `points` to optimize pagination ordering:
```dart
@override
List<Index> get indexes => [
  Index('rank_idx', 'rank'),
  Index('points_idx', 'points'),
];
```

### 5. Type-Safe Persistence Query Layer
Expose type-safe methods on `AppDatabase` instead of using generic lists or `dynamic`.
```dart
Stream<List<WeeklyLeaderboardData>> watchWeeklyLeaderboard();
Stream<List<MonthlyLeaderboardData>> watchMonthlyLeaderboard();
Stream<List<AllTimeLeaderboardData>> watchAllTimeLeaderboard();

Future<void> saveLeaderboardPage({
  required LeaderboardTimeline timeline,
  required int page,
  required List<Insertable> rows,
});
```

### 6. Corrected Timeline Network Mapping
- **Timeline Enum**:
  ```dart
  enum LeaderboardTimeline {
    allTime,
    thisWeek,
    thisMonth,
  }
  ```
- **Timeline Mapping**:
  ```dart
  extension LeaderboardTimelineExtension on LeaderboardTimeline {
    String? get timelineQuery {
      switch (this) {
        case LeaderboardTimeline.allTime:
          return null; // backend does not expect query param for all_time
        case LeaderboardTimeline.thisWeek:
          return 'this_week';
        case LeaderboardTimeline.thisMonth:
          return 'this_month';
      }
    }
  }
  ```

### 7. Unified Network Layer (Dynamic Pagination Params)
Consolidate any individual leaderboard calls into a single method:
```dart
Future<List<LearnerDto>> fetchLeaderboard({
  required LeaderboardTimeline timeline,
  int limit = 10,
  int page = 1,
});
```

### 8. Dedicated Leaderboard Repository (`LeaderboardRepository`)
- **Rationale**: To prevent duplicate churn, structural boundary-crossing, and simplify the upcoming dedicated leaderboard UI feature (supporting pagination, custom timelines, and caching), we extract the sync and persistence operations from `DashboardRepository` to a dedicated `LeaderboardRepository`.
- **Location**: `packages/core/lib/data/repositories/leaderboard_repository.dart`
- **Interface**:
  ```dart
  class LeaderboardRepository {
    final DataSource _dataSource;
    final AppDatabase _db;

    LeaderboardRepository({
      required DataSource dataSource,
      required AppDatabase db,
    });

    Stream<List<LearnerDto>> watchLeaderboard(LeaderboardTimeline timeline, {int? limit});
    Future<void> refreshLeaderboard(LeaderboardTimeline timeline, {int limit = 10, int page = 1});
  }
  ```

## Risks / Trade-offs

- **Risk**: Database migrations for existing users who already have `LearnersTable`.
- **Mitigation / Migration Safety**: Since the database is a cache of API responses, dropping the table is completely safe and appropriate. We drop the table in version `22` and safely create the new three tables. Any transient offline data is cleanly repopulated upon the next network sync.
