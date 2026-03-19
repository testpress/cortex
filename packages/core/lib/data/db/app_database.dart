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
import 'package:core/data/data.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CoursesTable,
    ChaptersTable,
    LessonsTable,
    LiveClassesTable,
    ForumThreadsTable,
    UserProgressTable,
    AppSettingsTable,
    UsersTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 6;

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
      Future<void> addColumnSafely(GeneratedColumn col) async {
        final res = await customSelect(
          'PRAGMA table_info(${lessonsTable.actualTableName})',
        ).get();
        final existingColumns = res.map((r) => r.read<String>('name'));
        if (!existingColumns.contains(col.name)) {
          await m.addColumn(lessonsTable, col);
        }
      }

      if (from < 3) {
        // Phase-2: Add new columns to lessonsTable without deleting existing data
        await addColumnSafely(lessonsTable.contentJson);
        await addColumnSafely(lessonsTable.subtitle);
        await addColumnSafely(lessonsTable.subjectName);
        await addColumnSafely(lessonsTable.subjectIndex);
        await addColumnSafely(lessonsTable.lessonNumber);
        await addColumnSafely(lessonsTable.totalLessons);
      }
      if (from < 4) {
        await addColumnSafely(lessonsTable.isBookmarked);
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

        // Also create the users table from the auth session integration
        await m.createTable(usersTable);
      }
    },
  );

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
      LessonsTableCompanion(isBookmarked: Value(!lesson.isBookmarked)),
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

  // ── Live Classes ──────────────────────────────────────────────────────────

  Stream<List<LiveClassesTableData>> watchAllLiveClasses() =>
      select(liveClassesTable).watch();

  Future<void> upsertLiveClasses(List<LiveClassesTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(liveClassesTable, rows));

  // ── Forum Threads ─────────────────────────────────────────────────────────

  Stream<List<ForumThreadsTableData>> watchThreadsForCourse(String courseId) =>
      (select(
        forumThreadsTable,
      )..where((t) => t.courseId.equals(courseId))).watch();

  Future<void> upsertForumThreads(List<ForumThreadsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(forumThreadsTable, rows));

  // ── User Progress ─────────────────────────────────────────────────────────

  Stream<List<UserProgressTableData>> watchProgressForUser(String userId) =>
      (select(
        userProgressTable,
      )..where((t) => t.userId.equals(userId))).watch();

  Future<void> upsertProgress(List<UserProgressTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(userProgressTable, rows));

  // ── User Identity ────────────────────────────────────────────────────────

  /// Fetches a single user by ID and watches for changes.
  Stream<UsersTableData?> watchUser(String id) {
    return (select(
      usersTable,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Upserts a user profile into the local database (used during login/sync).
  Future<void> upsertUser(UsersTableCompanion entry) async {
    await into(usersTable).insertOnConflictUpdate(entry);
  }

  /// Fetches any cached user profile (single-user app assumption).
  Future<UsersTableData?> getAnyUser() {
    return (select(usersTable)..limit(1)).getSingleOrNull();
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
}

/// Opens the SQLite database from the app documents directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lms.db'));
    return NativeDatabase(file, logStatements: false);
  });
}
