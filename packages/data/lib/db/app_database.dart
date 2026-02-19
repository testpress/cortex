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

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CoursesTable,
    ChaptersTable,
    LessonsTable,
    LiveClassesTable,
    ForumThreadsTable,
    UserProgressTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Simplified for development: drop and recreate the table to handle renamed column
            await m.deleteTable(coursesTable.actualTableName);
            await m.createTable(coursesTable);
          }
        },
      );

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
      )..where((t) => t.courseId.equals(courseId)))
          .watch();

  Future<void> upsertForumThreads(List<ForumThreadsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(forumThreadsTable, rows));

  // ── User Progress ─────────────────────────────────────────────────────────

  Stream<List<UserProgressTableData>> watchProgressForUser(String userId) =>
      (select(
        userProgressTable,
      )..where((t) => t.userId.equals(userId)))
          .watch();

  Future<void> upsertProgress(List<UserProgressTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(userProgressTable, rows));
}

/// Opens the SQLite database from the app documents directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lms.db'));
    return NativeDatabase(file, logStatements: false);
  });
}
