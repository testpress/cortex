import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'profile_providers.g.dart';

/// Provides enrolled courses directly from the DB layer to avoid depending on the `courses` package.
@riverpod
Stream<List<CourseDto>> profileEnrollment(Ref ref) async* {
  final db = await ref.watch(appDatabaseProvider.future);
  yield* db.watchAllCourses().map(
    (rows) => rows
        .map<CourseDto>(
          (row) => CourseDto(
            id: row.id,
            title: row.title,
            colorIndex: row.colorIndex,
            chapterCount: row.chapterCount,
            totalContents: row.totalContents,
            progress: row.progress,
            completedLessons: row.completedLessons,
          ),
        )
        .toList(),
  );
}

final isLogoutSheetOpenProvider = StateProvider<bool>((ref) => false);
