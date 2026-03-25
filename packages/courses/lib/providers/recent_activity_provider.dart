import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'course_list_provider.dart';

part 'recent_activity_provider.g.dart';

class RecentActivityVo {
  final String lessonTitle;
  final String courseTitle;
  final String chapterTitle;
  final String lessonId;
  final String courseId;

  RecentActivityVo({
    required this.lessonTitle,
    required this.courseTitle,
    required this.chapterTitle,
    required this.lessonId,
    required this.courseId,
  });
}

/// Provider for the most recently accessed lesson (for the Resume card).
@riverpod
Stream<RecentActivityVo?> recentActivity(RecentActivityRef ref) async* {
  final courseRepo = await ref.watch(courseRepositoryProvider.future);

  yield* courseRepo.watchRecentLesson().asyncMap((lesson) async {
    if (lesson == null) return null;

    // Efficiently fetch details from DB using join
    final result = await courseRepo.getLessonDetails(lesson.id);

    return RecentActivityVo(
      lessonTitle: lesson.title,
      courseTitle: result?.courseTitle ?? '',
      chapterTitle: result?.chapterTitle ?? '',
      lessonId: lesson.id,
      courseId: result?.courseId ?? '',
    );
  });
}
