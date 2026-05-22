# Implementation Tasks Checklist — Refactor Leaderboard Tables

Follow these precise steps to refactor the leaderboard database and data fetching layers to support isolated caching, type safety, and pagination for weekly, monthly, and all-time scopes.

---

## 1. Schema & Models Refactoring

### [x] Task 1.1: Delete LearnersTable from `dashboard_tables.dart`
- **File**: `packages/core/lib/data/db/tables/dashboard_tables.dart`
- **Instructions**: Delete the old `@DataClassName('LearnersTableData') class LearnersTable extends Table { ... }` class entirely.

### [x] Task 1.2: Create Dedicated `leaderboard_tables.dart` File
- **File**: `packages/core/lib/data/db/tables/leaderboard_tables.dart` [NEW]
- **Instructions**: Create a new file containing the reusable `LeaderboardColumns` mixin and three isolated table classes `WeeklyLeaderboardTable`, `MonthlyLeaderboardTable`, and `AllTimeLeaderboardTable` with custom table name overrides, composite primary keys `{id, page}`, and distinct SQLite index declarations.
- **Target Code**:
  ```dart
  import 'package:drift/drift.dart';

  // 1. Reusable mixin for common leaderboard columns
  mixin LeaderboardColumns on Table {
    TextColumn get id => text()();
    TextColumn get name => text()();
    TextColumn get avatar => text().nullable()();
    RealColumn get points => real()();
    IntColumn get rank => integer()();
    IntColumn get coursesCompleted => integer().withDefault(const Constant(0))();
    IntColumn get streakDays => integer().withDefault(const Constant(0))();
    IntColumn get page => integer().withDefault(const Constant(1))();
  }

  // 2. Weekly Leaderboard Cache Table
  @DataClassName('WeeklyLeaderboardData')
  class WeeklyLeaderboardTable extends Table with LeaderboardColumns {
    @override
    String get tableName => 'weekly_leaderboard';

    @override
    Set<Column> get primaryKey => {id, page};

    @override
    List<Index> get indexes => [
          Index('weekly_rank_idx', 'rank'),
          Index('weekly_points_idx', 'points'),
        ];
  }

  // 3. Monthly Leaderboard Cache Table
  @DataClassName('MonthlyLeaderboardData')
  class MonthlyLeaderboardTable extends Table with LeaderboardColumns {
    @override
    String get tableName => 'monthly_leaderboard';

    @override
    Set<Column> get primaryKey => {id, page};

    @override
    List<Index> get indexes => [
          Index('monthly_rank_idx', 'rank'),
          Index('monthly_points_idx', 'points'),
        ];
  }

  // 4. All-Time Leaderboard Cache Table
  @DataClassName('AllTimeLeaderboardData')
  class AllTimeLeaderboardTable extends Table with LeaderboardColumns {
    @override
    String get tableName => 'all_time_leaderboard';

    @override
    Set<Column> get primaryKey => {id, page};

    @override
    List<Index> get indexes => [
          Index('all_time_rank_idx', 'rank'),
          Index('all_time_points_idx', 'points'),
        ];
  }
  ```

### [x] Task 1.3: Update AppDatabase Registration and Migrations in `app_database.dart`
- **File**: `packages/core/lib/data/db/app_database.dart`
- **Instructions**:
  1. Add import to `tables/leaderboard_tables.dart`.
  2. Remove `LearnersTable` from the `@DriftDatabase` `tables` annotation list and register `WeeklyLeaderboardTable`, `MonthlyLeaderboardTable`, and `AllTimeLeaderboardTable` instead.
  3. Bump `schemaVersion` from `21` to `22`.
  4. Inside the `onUpgrade` method, add a block for `from < 22` to safely drop the old `learners_table` and create the new tables.
- **Target Code**:
  - `@DriftDatabase` Annotation:
    ```dart
    @DriftDatabase(
      tables: [
        CoursesTable,
        ChaptersTable,
        LessonsTable,
        LiveClassesTable,
        ForumThreadsTable,
        ForumCommentsTable,
        UserProgressTable,
        AppSettingsTable,
        UsersTable,
        DashboardBannersTable,
        WeeklyLeaderboardTable,
        MonthlyLeaderboardTable,
        AllTimeLeaderboardTable,
        DashboardContentsTable,
        DownloadsTable,
        DoubtsTable,
        DoubtRepliesTable,
        BookmarkFoldersTable,
        BookmarkItemsTable,
      ],
    )
    ```
  - `schemaVersion` Getter:
    ```dart
    @override
    int get schemaVersion => 22;
    ```
  - `onUpgrade` Migration Section:
    ```dart
    if (from < 22) {
      // Safely drop the old learners table
      await m.deleteTable('learners_table');
      // Safely create the new leaderboard tables
      await createTableSafely(weeklyLeaderboardTable);
      await createTableSafely(monthlyLeaderboardTable);
      await createTableSafely(allTimeLeaderboardTable);
    }
    ```

### [x] Task 1.4: Add Type-Safe DB Query Operations to `AppDatabase`
- **File**: `packages/core/lib/data/db/app_database.dart`
- **Instructions**: Add separate, type-safe database queries (`watchWeeklyLeaderboard({int? limit})`, etc.) and a generic `saveLeaderboardPage` helper to wipe cache on page 1 and append subsequent pages.
- **Target Code**:
  ```dart
  Stream<List<WeeklyLeaderboardData>> watchWeeklyLeaderboard({int? limit}) {
    final query = select(weeklyLeaderboardTable)..orderBy([(t) => OrderingTerm.asc(t.rank)]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.watch();
  }

  Stream<List<MonthlyLeaderboardData>> watchMonthlyLeaderboard({int? limit}) {
    final query = select(monthlyLeaderboardTable)..orderBy([(t) => OrderingTerm.asc(t.rank)]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.watch();
  }

  Stream<List<AllTimeLeaderboardData>> watchAllTimeLeaderboard({int? limit}) {
    final query = select(allTimeLeaderboardTable)..orderBy([(t) => OrderingTerm.asc(t.rank)]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.watch();
  }

  Future<void> saveLeaderboardPage({
    required LeaderboardTimeline timeline,
    required int page,
    required List<Insertable> rows,
  }) {
    return transaction(() async {
      switch (timeline) {
        case LeaderboardTimeline.thisWeek:
          if (page == 1) {
            await delete(weeklyLeaderboardTable).go();
          }
          await batch((b) => b.insertAllOnConflictUpdate(
              weeklyLeaderboardTable, rows.cast<WeeklyLeaderboardTableCompanion>()));
          break;
        case LeaderboardTimeline.thisMonth:
          if (page == 1) {
            await delete(monthlyLeaderboardTable).go();
          }
          await batch((b) => b.insertAllOnConflictUpdate(
              monthlyLeaderboardTable, rows.cast<MonthlyLeaderboardTableCompanion>()));
          break;
        case LeaderboardTimeline.allTime:
          if (page == 1) {
            await delete(allTimeLeaderboardTable).go();
          }
          await batch((b) => b.insertAllOnConflictUpdate(
              allTimeLeaderboardTable, rows.cast<AllTimeLeaderboardTableCompanion>()));
          break;
      }
    });
  }
  ```

### [x] Task 1.5: Execute Code Generation using Build Runner
- **Directory**: `packages/core`
- **Instructions**: Run the Drift build_runner compiler command in the terminal to generate the database schema mappings (`app_database.g.dart`).
- **Command**:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

---

## 2. API & Network Refactoring

### [x] Task 2.1: Define LeaderboardTimeline Enum and Extensions
- **File**: `packages/core/lib/data/models/dashboard_dto.dart`
- **Instructions**: Add `LeaderboardTimeline` enum and its query mapping extensions (allTime maps to `null`) at the bottom of the file.
- **Target Code**:
  ```dart
  enum LeaderboardTimeline {
    allTime,
    thisWeek,
    thisMonth,
  }

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

### [x] Task 2.2: Refactor `DataSource` Interfaces
- **File**: `packages/core/lib/data/sources/data_source.dart`
- **Instructions**: Delete `Future<List<LearnerDto>> getLearners();`. Add a parameter-driven paginated fetch method.
- **Target Code**:
  ```diff
-  /// Fetch top learners from `/api/v2.3/leaderboard/`.
-  Future<List<LearnerDto>> getLearners();
+  /// Fetch leaderboards from `/api/v2.3/leaderboard/` for a specific timeline and page.
+  Future<List<LearnerDto>> fetchLeaderboard({
+    required LeaderboardTimeline timeline,
+    int limit = 10,
+    int page = 1,
+  });
  ```

### [x] Task 2.3: Refactor `HttpDataSource` Implementation
- **File**: `packages/core/lib/data/sources/http_data_source.dart`
- **Instructions**: Delete the old `getLearners()` method and implement `fetchLeaderboard()` with dynamic limit/page parameters and correct timeline query injection.
- **Target Code**:
  ```dart
  @override
  Future<List<LearnerDto>> fetchLeaderboard({
    required LeaderboardTimeline timeline,
    int limit = 10,
    int page = 1,
  }) async {
    final Map<String, dynamic> params = {
      'limit': limit,
      'page': page,
    };
    final timelineStr = timeline.timelineQuery;
    if (timelineStr != null) {
      params['timeline'] = timelineStr;
    }

    return performNetworkRequest(
      _dio.get(ApiEndpoints.leaderboard, queryParameters: params),
      fromJson: (data) {
        final results = data['results'] as List<dynamic>?;
        if (results == null) return [];
        final learners = <LearnerDto>[];
        for (var i = 0; i < results.length; i++) {
          final calculatedRank = (page - 1) * limit + i + 1;
          learners.add(LearnerDto.fromJson(results[i] as Map<String, dynamic>, calculatedRank));
        }
        return learners;
      },
    );
  }
  ```

### [x] Task 2.4: Refactor `MockDataSource` Implementation
- **File**: `packages/core/lib/data/sources/mock_data_source.dart`
- **Instructions**: Delete the old `getLearners()` method and implement `fetchLeaderboard()` matching the new signature.
- **Target Code**:
  ```dart
  @override
  Future<List<LearnerDto>> fetchLeaderboard({
    required LeaderboardTimeline timeline,
    int limit = 10,
    int page = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockLearners;
  }
  ```

---

## 3. Repository & State Layer Integration

### [x] Task 3.1: Create Dedicated `LeaderboardRepository`
- **File**: `packages/core/lib/data/repositories/leaderboard_repository.dart` [NEW]
- **Instructions**: Create a new repository to manage all weekly, monthly, and all-time leaderboard fetches and caches, completely isolated from `DashboardRepository`. Define the `leaderboardRepositoryProvider` Riverpod provider.
- **Target Code**:
  ```dart
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
  ```

### [x] Task 3.2: Export `LeaderboardRepository` in `packages/core/lib/data/data.dart`
- **File**: `packages/core/lib/data/data.dart`
- **Instructions**: Export `repositories/leaderboard_repository.dart` in the main core data barrel file.

### [x] Task 3.3: Refactor `DashboardRepository` to remove old leaderboard methods
- **File**: `packages/core/lib/data/repositories/dashboard_repository.dart`
- **Instructions**: Clean up the now-obsolete `watchLearners()` and `refreshLearners()` methods from `DashboardRepository`.

### [x] Task 3.4: Refactor Riverpod Providers in `dashboard_providers.dart`
- **File**: `packages/courses/lib/providers/dashboard_providers.dart`
- **Instructions**:
  1. In `dashboardBootstrap`, resolve both `dashboardRepositoryProvider.future` and `leaderboardRepositoryProvider.future`.
  2. Call `leaderboardRepository.refreshLeaderboard(LeaderboardTimeline.thisWeek)` instead of `repository.refreshLearners()`.
  3. Update `learnersProvider` to accept timeline & optional limit, and read `leaderboardRepositoryProvider.future` to stream results.
- **Target Code**:
  - `dashboardBootstrap`:
    ```dart
    @riverpod
    Future<void> dashboardBootstrap(Ref ref) async {
      final repository = await ref.watch(dashboardRepositoryProvider.future);
      final leaderboardRepository = await ref.watch(leaderboardRepositoryProvider.future);
      
      await Future.wait([
        repository.refreshHeroBanners(),
        leaderboardRepository.refreshLeaderboard(LeaderboardTimeline.thisWeek),
        repository.refreshWhatsNewFeed(),
        repository.refreshResumeLearningFeed(),
        repository.refreshRecentlyCompletedFeed(),
      ]);
    }
    ```
  - `learners` Provider:
    ```dart
    @riverpod
    Stream<List<LearnerDto>> learners(
      Ref ref, {
      LeaderboardTimeline timeline = LeaderboardTimeline.thisWeek,
      int? limit,
    }) async* {
      final repository = await ref.watch(leaderboardRepositoryProvider.future);
      yield* repository.watchLeaderboard(timeline, limit: limit);
    }
    ```

### [x] Task 3.5: Execute Code Generation for Repositories and Riverpod Providers
- **Directories**: `packages/core` and `packages/courses`
- **Instructions**: Run build_runner code generation in both directories to build repository and provider generated files (`leaderboard_repository.g.dart`, `dashboard_repository.g.dart`, `dashboard_providers.g.dart`).
- **Commands**:
  - In `packages/core`:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
  - In `packages/courses`:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

---

## 4. UI Layer Integration & Verification

### [x] Task 4.1: Update `PaidActiveHomeScreen` to explicit Weekly Timeline with Limit 10
- **File**: `packages/testpress/lib/screens/dashboard/paid_active_home_screen.dart`
- **Instructions**: Locate `final learnersState = ref.watch(learnersProvider);`. Explicitly watch the weekly timeline with `limit: 10`.
- **Target Code**:
  ```dart
  final learnersState = ref.watch(learnersProvider(
    timeline: dto.LeaderboardTimeline.thisWeek,
    limit: 10,
  ));
  ```
