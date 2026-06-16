import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/courses_table.dart';
import 'tables/chapters_table.dart';
import 'tables/lessons_table.dart';
import 'tables/live_classes_table.dart';
import 'tables/forum_threads_table.dart';
import 'tables/user_progress_table.dart';
import 'tables/app_settings_table.dart';
import 'tables/users_table.dart';
import 'tables/downloads_table.dart';
import 'tables/doubts_table.dart';
import 'tables/bookmarks_table.dart';
import 'tables/posts_table.dart';
import 'package:core/data/data.dart';

part 'app_database.g.dart';

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
    DoubtTopicsTable,
    BookmarkFoldersTable,
    BookmarkItemsTable,
    PostCategoriesTable,
    PostsTable,
    SubjectAnalyticsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 29;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // For beta development, recreate all tables instead of complex migrations
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
        await m.createTable(table);
      }
    },
  );

  // ── User Profiling ───────────────────────────────────────────────────────

  /// Fetch a user from the local cache.
  Future<UsersTableData?> getUserById(String id) =>
      (select(usersTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Watch a user's metadata for live updates.
  Stream<UsersTableData?> watchUserById(String id) =>
      (select(usersTable)..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Insert or replace user metadata.
  Future<void> upsertUser(UsersTableCompanion companion) =>
      into(usersTable).insertOnConflictUpdate(companion);

  /// Wipe all data from all local tables.
  /// Typically used during logout for a clean factory-reset state.
  Future<void> purgeAllData() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  // ── App Settings ─────────────────────────────────────────────────────────

  /// Fetch the singleton settings row.
  Future<AppSettingsTableData> getAppSettings() async {
    return transaction(() async {
      await into(appSettingsTable).insert(
        const AppSettingsTableCompanion(id: Value(1)),
        mode: InsertMode.insertOrIgnore,
      );
      return await select(appSettingsTable).getSingle();
    });
  }

  /// Watch settings for live updates.
  Stream<AppSettingsTableData> watchAppSettings() {
    return select(appSettingsTable).watchSingleOrNull().map((entry) {
      if (entry == null) {
        // Initial insert happens out-of-band to establish the row.
        // Returning a default until the watchdog picks up the new row.
        return const AppSettingsTableData(
          id: 1,
          appearanceMode: AppSettingsDefaults.appearanceMode,
          videoQuality: AppSettingsDefaults.videoQuality,
          autoPlayNext: AppSettingsDefaults.autoPlayNext,
          textSize: AppSettingsDefaults.textSize,
          highContrast: AppSettingsDefaults.highContrast,
          appLanguage: AppSettingsDefaults.appLanguage,
        );
      }
      return entry;
    });
  }

  /// Update app settings.
  Future<void> updateSettings(AppSettingsTableCompanion companion) {
    return (update(
      appSettingsTable,
    )..where((t) => t.id.equals(1))).write(companion);
  }

  /// Marks an attempt ID as quiz-mode in the DB.
  Future<void> setQuizModeAttempt(String attemptId) async {
    final settings = await getAppSettings();
    final existing = settings.quizModeAttemptsJson;
    final Map<String, dynamic> map = existing != null
        ? Map<String, dynamic>.from(jsonDecode(existing) as Map)
        : {};
    map[attemptId] = true;
    await (update(appSettingsTable)..where((t) => t.id.equals(1))).write(
      AppSettingsTableCompanion(quizModeAttemptsJson: Value(jsonEncode(map))),
    );
  }

  /// Returns true if an attempt was originally started in quiz mode.
  Future<bool> isQuizModeAttempt(String attemptId) async {
    final settings = await getAppSettings();
    final existing = settings.quizModeAttemptsJson;
    if (existing == null) return false;
    final map = jsonDecode(existing) as Map;
    return map[attemptId] == true;
  }

  // ── Courses ──────────────────────────────────────────────────────────────

  /// Watch all courses as a live stream.
  Stream<List<CoursesTableData>> watchAllCourses() => (select(
    coursesTable,
  )..orderBy([(t) => OrderingTerm.asc(t.orderIndex)])).watch();

  /// Insert or replace a list of courses.
  Future<void> upsertCourses(List<CoursesTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(coursesTable, rows));

  // ── Chapters ─────────────────────────────────────────────────────────────

  /// Watch chapters for a given course, ordered by index.
  Stream<List<ChaptersTableData>> watchChaptersForCourse(String courseId) =>
      (select(chaptersTable)
            ..where((t) => t.courseId.equals(courseId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .watch();

  Future<void> upsertChapters(List<ChaptersTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(chaptersTable, rows));

  // ── Lessons ───────────────────────────────────────────────────────────────

  /// Watch all lessons in the database.
  /// Used for mapping the overall course structure.
  Stream<List<LessonsTableData>> watchAllLessons() => (select(
    lessonsTable,
  )..orderBy([(t) => OrderingTerm.asc(t.orderIndex)])).watch();

  /// Watch all lessons for a specific course.
  Stream<List<LessonsTableData>> watchLessonsForCourse(String courseId) {
    return watchAllLessons();
  }

  /// Watch lessons for a given chapter, ordered by index.
  Stream<List<LessonsTableData>> watchLessonsForChapter(String chapterId) =>
      (select(lessonsTable)
            ..where((t) => t.chapterId.equals(chapterId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .watch();

  /// Fetch a single lesson by its primary ID.
  Future<LessonsTableData?> getLessonById(String id) =>
      (select(lessonsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Watch a single lesson's data.
  Stream<LessonsTableData?> watchLesson(String id) =>
      (select(lessonsTable)..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Toggles the bookmark status of a lesson.
  Future<void> toggleLessonBookmark(String id) async {
    final lesson = await getLessonById(id);
    if (lesson == null) return;
    final isCurrentlyBookmarked = lesson.bookmarkId != null;
    await (update(lessonsTable)..where((t) => t.id.equals(id))).write(
      LessonsTableCompanion(
        bookmarkId: Value(
          isCurrentlyBookmarked ? null : 1,
        ), // Local toggle / dummy ID
      ),
    );
  }

  /// Updates the progress status of a lesson.
  Future<void> updateLessonProgress(
    String id,
    LessonProgressStatus status,
  ) async {
    await (update(lessonsTable)..where((t) => t.id.equals(id))).write(
      LessonsTableCompanion(progressStatus: Value(status.name)),
    );
  }

  Future<void> upsertLessons(List<LessonsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(lessonsTable, rows));

  /// Deletes all lessons for a specific chapter.
  /// Useful during synchronization to clear out old or incorrectly associated data.
  Future<void> deleteLessonsForChapter(String chapterId) =>
      (delete(lessonsTable)..where((t) => t.chapterId.equals(chapterId))).go();

  /// Deletes lessons by their IDs.
  /// Useful for pruning orphaned records.
  Future<void> deleteLessonsByIds(Iterable<String> ids) =>
      (delete(lessonsTable)..where((t) => t.id.isIn(ids))).go();

  /// Watch just the exam metadata JSON for a lesson by its slug.
  Stream<String?> watchLessonExamMetadataBySlug(String slug) {
    return (select(lessonsTable)..where((t) => t.slug.equals(slug)))
        .watchSingleOrNull()
        .map((row) => row?.examMetadataJson);
  }

  /// Update the exam metadata JSON for a lesson by its slug.
  Future<void> updateLessonExamMetadata(String slug, String json) async {
    await (update(lessonsTable)..where((t) => t.slug.equals(slug))).write(
      LessonsTableCompanion(examMetadataJson: Value(json)),
    );
  }

  // ── Live Classes ──────────────────────────────────────────────────────────

  Stream<List<LiveClassesTableData>> watchAllLiveClasses() =>
      select(liveClassesTable).watch();

  Future<void> upsertLiveClasses(List<LiveClassesTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(liveClassesTable, rows));

  // ── Forum Threads ─────────────────────────────────────────────────────────

  Stream<List<ForumThreadsTableData>> watchAllThreads() =>
      select(forumThreadsTable).watch();

  Stream<ForumThreadsTableData?> watchThreadBySlug(String slug) => (select(
    forumThreadsTable,
  )..where((t) => t.id.equals(slug))).watchSingleOrNull();

  Stream<List<ForumThreadsTableData>> watchThreadsForCourse(String courseId) =>
      (select(
        forumThreadsTable,
      )..where((t) => t.courseId.equals(courseId))).watch();

  Stream<ForumThreadsTableData?> watchThreadById(String threadId) => (select(
    forumThreadsTable,
  )..where((t) => t.id.equals(threadId))).watchSingleOrNull();

  Future<void> upsertForumThreads(List<ForumThreadsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(forumThreadsTable, rows));

  // ── Forum Comments ─────────────────────────────────────────────────────────

  Stream<List<ForumCommentsTableData>> watchCommentsForThread(int threadId) =>
      (select(forumCommentsTable)
            ..where((t) => t.threadId.equals(threadId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<void> upsertForumComments(List<ForumCommentsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(forumCommentsTable, rows));

  // ── User Progress ─────────────────────────────────────────────────────────

  Stream<List<UserProgressTableData>> watchProgressForUser(String userId) =>
      (select(
        userProgressTable,
      )..where((t) => t.userId.equals(userId))).watch();

  Future<void> upsertProgress(List<UserProgressTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(userProgressTable, rows));

  // ── Dashboard Banners ─────────────────────────────────────────────────────

  Stream<List<DashboardBannersTableData>> watchDashboardBanners() =>
      select(dashboardBannersTable).watch();

  Future<void> upsertDashboardBanners(
    List<DashboardBannersTableCompanion> rows,
  ) => batch((b) => b.insertAllOnConflictUpdate(dashboardBannersTable, rows));

  // ── Leaderboard Cache ─────────────────────────────────────────────────────

  Stream<List<WeeklyLeaderboardData>> watchWeeklyLeaderboard({int? limit}) {
    final query = select(weeklyLeaderboardTable)
      ..orderBy([(t) => OrderingTerm.asc(t.rank)]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.watch();
  }

  Stream<List<MonthlyLeaderboardData>> watchMonthlyLeaderboard({int? limit}) {
    final query = select(monthlyLeaderboardTable)
      ..orderBy([(t) => OrderingTerm.asc(t.rank)]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.watch();
  }

  Stream<List<AllTimeLeaderboardData>> watchAllTimeLeaderboard({int? limit}) {
    final query = select(allTimeLeaderboardTable)
      ..orderBy([(t) => OrderingTerm.asc(t.rank)]);
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
          await batch(
            (b) => b.insertAllOnConflictUpdate(
              weeklyLeaderboardTable,
              rows.cast<WeeklyLeaderboardTableCompanion>(),
            ),
          );
          break;
        case LeaderboardTimeline.thisMonth:
          if (page == 1) {
            await delete(monthlyLeaderboardTable).go();
          }
          await batch(
            (b) => b.insertAllOnConflictUpdate(
              monthlyLeaderboardTable,
              rows.cast<MonthlyLeaderboardTableCompanion>(),
            ),
          );
          break;
        case LeaderboardTimeline.allTime:
          if (page == 1) {
            await delete(allTimeLeaderboardTable).go();
          }
          await batch(
            (b) => b.insertAllOnConflictUpdate(
              allTimeLeaderboardTable,
              rows.cast<AllTimeLeaderboardTableCompanion>(),
            ),
          );
          break;
      }
    });
  }

  // ── Dashboard Feed Management ─────────────────────────────────────────────

  /// Watch a specific dashboard section.
  Stream<List<DashboardContentData>> watchDashboardSection(
    DashboardSectionType sectionType,
  ) {
    final query = select(dashboardContentsTable)
      ..where((t) => t.sectionType.equalsValue(sectionType))
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]);

    return query.watch();
  }

  /// Wipe and refresh a specific dashboard section.
  Future<void> wipeAndInsertDashboardSection(
    DashboardSectionType sectionType,
    List<DashboardContentsTableCompanion> rows,
  ) {
    return transaction(() async {
      await (delete(
        dashboardContentsTable,
      )..where((t) => t.sectionType.equalsValue(sectionType))).go();
      await batch((b) => b.insertAll(dashboardContentsTable, rows));
    });
  }

  // ── Combined Lookups ──────────────────────────────────────────────────────

  /// Efficiently fetches lesson, chapter, and course data for a single lesson.
  Future<TypedResult?> getLessonDetails(String lessonId) {
    final query = select(lessonsTable).join([
      innerJoin(
        chaptersTable,
        chaptersTable.id.equalsExp(lessonsTable.chapterId),
      ),
      innerJoin(
        coursesTable,
        coursesTable.id.equalsExp(chaptersTable.courseId),
      ),
    ])..where(lessonsTable.id.equals(lessonId));

    return query.getSingleOrNull();
  }

  // ── Doubts ────────────────────────────────────────────────────────────────

  Stream<List<DoubtRepliesTableData>> watchRepliesForDoubt(String doubtId) =>
      (select(doubtRepliesTable)
            ..where((t) => t.doubtId.equals(doubtId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<void> upsertDoubtReplies(List<DoubtRepliesTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(doubtRepliesTable, rows));

  Stream<List<DoubtTopicsTableData>> watchDoubtTopics({int? parentId}) {
    final query = select(doubtTopicsTable);
    if (parentId != null) {
      query.where((t) => t.parentId.equals(parentId));
    } else {
      query.where((t) => t.parentId.isNull());
    }
    return query.watch();
  }

  Future<void> upsertDoubtTopics(List<DoubtTopicsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(doubtTopicsTable, rows));

  // ── Posts / Announcements ──────────────────────────────────────────────────

  Stream<List<PostData>> watchPosts() => (select(
    postsTable,
  )..orderBy([(t) => OrderingTerm.desc(t.publishedDate)])).watch();

  Future<void> upsertPosts(List<PostsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(postsTable, rows));

  /// Replaces all posts — used on page 1 / pull-to-refresh.
  /// Runs in a single transaction so the stream emits only once.
  Future<void> replacePosts(List<PostsTableCompanion> rows) =>
      transaction(() async {
        await delete(postsTable).go();
        await batch((b) => b.insertAllOnConflictUpdate(postsTable, rows));
      });

  Stream<List<PostCategoryData>> watchPostCategories() => (select(
    postCategoriesTable,
  )..orderBy([(t) => OrderingTerm.asc(t.displayOrder)])).watch();

  /// Replaces all post categories — categories aren't paginated.
  Future<void> replacePostCategories(List<PostCategoriesTableCompanion> rows) =>
      transaction(() async {
        await delete(postCategoriesTable).go();
        await batch(
          (b) => b.insertAllOnConflictUpdate(postCategoriesTable, rows),
        );
      });
}

/// Opens the SQLite database from the app documents directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lms.db'));
    return NativeDatabase(file, logStatements: false);
  });
}
