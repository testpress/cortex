import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';

part 'course_detail_provider.g.dart';

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
@Riverpod(keepAlive: true)
Stream<CourseDto?> courseDetail(CourseDetailRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  
  // Start the background refresh so the DB gets updated.
  repo.refreshChapters(courseId).ignore();

  yield* repo.watchCourse(courseId);
}

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
@riverpod
Future<List<LessonDto>> allCourseLessons(
  AllCourseLessonsRef ref,
  String courseId,
) async {
  final course = await ref.watch(courseDetailProvider(courseId).future);
  if (course == null) return [];

  return course.chapters.expand((chapter) => chapter.lessons).toList();
}
