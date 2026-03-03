import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/course_dto.dart';
import '../models/chapter_dto.dart';
import '../models/lesson_dto.dart';
import 'repository_providers.dart';

part 'course_list_provider.g.dart';

/// Stream provider for the full course list.
/// On first watch: triggers a refresh from DataSource → Drift.
/// Thereafter: streams live updates from the Drift DB.
@riverpod
Stream<List<CourseDto>> courseList(CourseListRef ref) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchCourses();
}

/// Provider for a specific course's chapters.
@riverpod
Stream<List<ChapterDto>> courseChapters(
    CourseChaptersRef ref, String courseId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchChapters(courseId);
}

/// Provider for a specific chapter's lessons.
@riverpod
Stream<List<LessonDto>> chapterLessons(
    ChapterLessonsRef ref, String chapterId) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchLessons(chapterId);
}
