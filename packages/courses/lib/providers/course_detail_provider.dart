import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';

part 'course_detail_provider.g.dart';

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
@Riverpod(keepAlive: true)
Stream<CourseDto?> courseDetail(CourseDetailRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  
  // Note: chapters are now refreshed lazily via subChaptersProvider.
  // However, we still trigger background refreshes for chapters and full curriculum 
  // to ensure local data is available for specific screens (filters, leaf chapters).
  repo.refreshChapters(courseId).ignore();
  repo.refreshCourseContents(courseId).ignore();
  yield* repo.watchCourse(courseId);
}

/// A provider that watches chapters for a specific parent (folder).
/// Triggers a refresh if the folder has not been synced yet.
@riverpod
Stream<List<ChapterDto>> subChapters(
  SubChaptersRef ref,
  String courseId,
  String? parentId,
) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);

  // Check if this level has already been synced using the unified method
  final needsSync = !(await repo.isChaptersSynced(courseId, parentId: parentId));

  if (needsSync) {
    await repo.refreshChapters(courseId, parentId: parentId);
  } else {
    repo.refreshChapters(courseId, parentId: parentId).ignore();
  }

  yield* repo.watchChapters(courseId, parentId: parentId).map(
        (rows) => rows.map((row) => repo.rowToChapterDto(row)).toList(),
      );
}

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
@riverpod
Stream<List<LessonDto>> allCourseLessons(
  AllCourseLessonsRef ref,
  String courseId,
) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchLessonsForCourse(courseId);
}
