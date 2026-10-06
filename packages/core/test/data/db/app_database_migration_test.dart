import 'package:core/data/data.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('AppDatabase schema migrations', () {
    test(
      'upgrades from v1 to v2 adding external link columns to courses_table',
      () async {
        // 1. Initialize a raw SQLite database representing schema v1
        final rawDb = sqlite3.openInMemory();

        rawDb.execute('''
        CREATE TABLE courses_table (
          id TEXT NOT NULL PRIMARY KEY,
          title TEXT NOT NULL,
          color_index INTEGER NOT NULL,
          chapter_count INTEGER NOT NULL,
          total_contents INTEGER NOT NULL DEFAULT 0,
          progress REAL NOT NULL DEFAULT 0.0,
          completed_lessons INTEGER NOT NULL DEFAULT 0,
          image TEXT,
          tags TEXT,
          allowed_devices TEXT,
          exams_count INTEGER NOT NULL DEFAULT 0,
          order_index INTEGER NOT NULL DEFAULT 0,
          is_chapters_synced INTEGER NOT NULL DEFAULT 0
        );
      ''');

        // Set user_version to 1 (v1 schema)
        rawDb.execute('PRAGMA user_version = 1;');

        // Insert pre-existing v1 data
        rawDb.execute('''
        INSERT INTO courses_table (
          id, title, color_index, chapter_count, total_contents, progress, completed_lessons, exams_count, order_index, is_chapters_synced
        ) VALUES (
          'c-101', 'Existing Flutter Course', 1, 4, 12, 45.0, 5, 0, 0, 1
        );
      ''');

        // 2. Open AppDatabase with the v1 database connection
        final db = AppDatabase(NativeDatabase.opened(rawDb));

        // 3. Query existing course via AppDatabase to trigger migration
        final courses = await db.watchAllCourses().first;

        // Verify user_version upgraded to 2
        final versionResult = await db
            .customSelect('PRAGMA user_version;')
            .getSingle();
        expect(versionResult.read<int>('user_version'), 2);

        // Verify existing row is intact and new columns default to null
        expect(courses.length, 1);
        final existingCourse = courses.first;
        expect(existingCourse.id, 'c-101');
        expect(existingCourse.title, 'Existing Flutter Course');
        expect(existingCourse.progress, 45.0);
        expect(existingCourse.completedLessons, 5);
        expect(existingCourse.isChaptersSynced, true);
        expect(existingCourse.externalContentLink, isNull);
        expect(existingCourse.externalLinkLabel, isNull);

        // 4. Insert new course containing externalContentLink & externalLinkLabel
        await db.upsertCourses([
          const CoursesTableCompanion(
            id: Value('c-102'),
            title: Value('Approval Course'),
            colorIndex: Value(2),
            chapterCount: Value(1),
            totalContents: Value(3),
            externalContentLink: Value('https://example.com/sso/register'),
            externalLinkLabel: Value('REQUEST PACKAGE'),
          ),
        ]);

        final updatedCourses = await db.watchAllCourses().first;
        expect(updatedCourses.length, 2);

        final approvalCourse = updatedCourses.firstWhere(
          (c) => c.id == 'c-102',
        );
        expect(approvalCourse.title, 'Approval Course');
        expect(
          approvalCourse.externalContentLink,
          'https://example.com/sso/register',
        );
        expect(approvalCourse.externalLinkLabel, 'REQUEST PACKAGE');

        await db.close();
      },
    );
  });
}
