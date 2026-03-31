import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'course_detail_provider.g.dart';

/// Fetches a single course by its ID.
@riverpod
Stream<CourseDto?> courseDetail(CourseDetailRef ref, String courseId) async* {
  final enrollment = await ref.watch(courseListProvider.future);
  yield enrollment.where((c) => c.id == courseId).firstOrNull;
  
  yield* ref.watch(courseListProvider.stream).map(
        (list) => list.where((c) => c.id == courseId).firstOrNull,
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
