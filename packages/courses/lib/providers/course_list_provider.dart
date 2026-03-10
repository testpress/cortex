import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:data/data.dart';
import 'package:data/providers/database_provider.dart';
import 'package:data/providers/data_source_provider.dart';
import '../repositories/course_repository.dart';

part 'course_list_provider.g.dart';

@Riverpod(keepAlive: true)
Future<CourseRepository> courseRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return CourseRepository(db, source);
}

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
