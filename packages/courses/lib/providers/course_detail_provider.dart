import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'course_detail_provider.g.dart';

/// Fetches a single course by its ID.
@riverpod
Future<CourseDto?> courseDetail(CourseDetailRef ref, String courseId) async {
  final enrollment = await ref.watch(courseListProvider.future);
  return enrollment.where((c) => c.id == courseId).firstOrNull;
}

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
@riverpod
Future<List<LessonDto>> allCourseLessons(
  AllCourseLessonsRef ref,
  String courseId,
) async {
  final repo = await ref.watch(courseRepositoryProvider.future);
  final chapters = await repo.refreshChapters(courseId);
  
  final allLessons = <LessonDto>[];
  for (final chapter in chapters) {
    final lessons = await repo.refreshLessons(chapter.id);
    allLessons.addAll(lessons);
  }
  return allLessons;
}
