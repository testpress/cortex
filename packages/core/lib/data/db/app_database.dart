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
import 'tables/forum_comments_table.dart';
import 'tables/user_progress_table.dart';
import 'tables/app_settings_table.dart';
import 'tables/users_table.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Courses table migration (simplified for development, but ideally non-destructive)
            await m.deleteTable(coursesTable.actualTableName);
            await m.createTable(coursesTable);
          }

          // Helper to add columns only if they don't already exist.
          // This prevents crashes like "duplicate column name" during development migrations.
          Future<void> addColumnSafely(TableInfo table, GeneratedColumn col) async {
            final res = await customSelect(
              "PRAGMA table_info('${table.actualTableName}')",
            ).get();
            final existingColumns = res.map((r) => r.read<String>('name'));
            if (!existingColumns.contains(col.name)) {
              await m.addColumn(table, col);
            }
          }

          // Helper to create tables safely
          Future<void> createTableSafely(TableInfo table) async {
            final res = await customSelect(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='${table.actualTableName}'",
            ).get();
            if (res.isEmpty) {
              await m.createTable(table);
            }
          }

          if (from < 3) {
            // Phase-2: Add new columns to lessonsTable without deleting existing data
            await addColumnSafely(lessonsTable, lessonsTable.contentUrl);
            await addColumnSafely(lessonsTable, lessonsTable.subtitle);
            await addColumnSafely(lessonsTable, lessonsTable.subjectName);
            await addColumnSafely(lessonsTable, lessonsTable.subjectIndex);
            await addColumnSafely(lessonsTable, lessonsTable.lessonNumber);
            await addColumnSafely(lessonsTable, lessonsTable.totalLessons);
          }
          if (from < 4) {
            await addColumnSafely(lessonsTable, lessonsTable.isBookmarked);
          }
          if (from < 5) {
            await m.createTable(appSettingsTable);
          }
          if (from < 6) {
            // Non-destructive migration to preserve user settings.
            // We read the existing row (if any) using raw SQL since the generated mapping might expect the new schema.
            final existing = await customSelect('SELECT * FROM app_settings_table LIMIT 1').getSingleOrNull();

            // Recreate the table to apply the new primary key constraint.
            await m.deleteTable(appSettingsTable.actualTableName);
            await m.createTable(appSettingsTable);

            if (existing != null) {
              // Restore the previously saved settings into the new table structure.
              await into(appSettingsTable).insert(
                AppSettingsTableCompanion(
                  id: const Value(1),
                  appearanceMode: Value(existing.read<String>('appearance_mode')),
                  videoQuality: Value(existing.read<String>('video_quality')),
                  autoPlayNext: Value(existing.read<bool>('auto_play_next')),
                  textSize: Value(existing.read<String>('text_size')),
                  highContrast: Value(existing.read<bool>('high_contrast')),
                ),
              );
            }
          }
          if (from < 7) {
            await m.createTable(usersTable);
          }
          if (from < 8) {
            // Forum integration (Initial tables)
            await createTableSafely(forumThreadsTable);
            await createTableSafely(forumCommentsTable);
          }
          if (from < 9) {
            // Version 9 includes:
            // 1. Combined sync flags for courses and chapters.
            // 2. Status filters for lessons (Running/Upcoming/History).
            await addColumnSafely(chaptersTable, chaptersTable.isChaptersSynced);
            await addColumnSafely(coursesTable, coursesTable.isChaptersSynced);
            await addColumnSafely(lessonsTable, lessonsTable.isRunning);
            await addColumnSafely(lessonsTable, lessonsTable.isUpcoming);
            await addColumnSafely(lessonsTable, lessonsTable.hasAttempts);
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
            highContrast: AppSettingsDefaults.highContrast);
      }
      return entry;
    });
  }

  /// Update app settings.
  Future<void> updateSettings(AppSettingsTableCompanion companion) {
    return (update(appSettingsTable)..where((t) => t.id.equals(1)))
        .write(companion);
  }

  // ── Courses ──────────────────────────────────────────────────────────────

  /// Watch all courses as a live stream.
  Stream<List<CoursesTableData>> watchAllCourses() =>
      select(coursesTable).watch();

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

  /// Watch all lessons for a specific course by joining with chapters.
  Stream<List<LessonsTableData>> watchLessonsForCourse(String courseId) {
    final query = select(lessonsTable).join([
      innerJoin(
        chaptersTable,
        chaptersTable.id.equalsExp(lessonsTable.chapterId),
      ),
    ])
      ..where(chaptersTable.courseId.equals(courseId))
      ..orderBy([OrderingTerm.asc(lessonsTable.orderIndex)]);

    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(lessonsTable)).toList();
    });
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
    await (update(lessonsTable)..where((t) => t.id.equals(id))).write(
      LessonsTableCompanion(
        isBookmarked: Value(!lesson.isBookmarked),
      ),
    );
  }

  /// Updates the progress status of a lesson.
  Future<void> updateLessonProgress(
      String id, LessonProgressStatus status) async {
    await (update(lessonsTable)..where((t) => t.id.equals(id))).write(
      LessonsTableCompanion(
        progressStatus: Value(status.name),
      ),
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

  // ── Live Classes ──────────────────────────────────────────────────────────

  Stream<List<LiveClassesTableData>> watchAllLiveClasses() =>
      select(liveClassesTable).watch();

  Future<void> upsertLiveClasses(List<LiveClassesTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(liveClassesTable, rows));

  // ── Forum Threads ─────────────────────────────────────────────────────────

  Stream<List<ForumThreadsTableData>> watchThreadsForCourse(String courseId) =>
      (select(
        forumThreadsTable,
      )..where((t) => t.courseId.equals(courseId)))
          .watch();

  Stream<ForumThreadsTableData?> watchThreadById(String threadId) =>
      (select(forumThreadsTable)..where((t) => t.id.equals(threadId)))
          .watchSingleOrNull();

  Future<void> upsertForumThreads(List<ForumThreadsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(forumThreadsTable, rows));

  // ── Forum Comments ─────────────────────────────────────────────────────────

  Stream<List<ForumCommentsTableData>> watchCommentsForThread(String threadId) =>
      (select(
        forumCommentsTable,
      )..where((t) => t.threadId.equals(threadId)))
          .watch();

  Future<void> upsertForumComments(List<ForumCommentsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(forumCommentsTable, rows));

  // ── User Progress ─────────────────────────────────────────────────────────

  Stream<List<UserProgressTableData>> watchProgressForUser(String userId) =>
      (select(
        userProgressTable,
      )..where((t) => t.userId.equals(userId)))
          .watch();

  Future<void> upsertProgress(List<UserProgressTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(userProgressTable, rows));

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
    ])
      ..where(lessonsTable.id.equals(lessonId));

    return query.getSingleOrNull();
  }
}

/// Opens the SQLite database from the app documents directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lms.db'));
    return NativeDatabase(file, logStatements: false);
  });
}
