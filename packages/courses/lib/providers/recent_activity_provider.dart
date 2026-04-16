import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'recent_activity_provider.g.dart';

class RecentActivityVo {
  final String lessonTitle;
  final String courseTitle;
  final String chapterTitle;
  final int progress;
  final String lessonId;
  final String courseId;

  RecentActivityVo({
    required this.lessonTitle,
    required this.courseTitle,
    required this.chapterTitle,
    required this.progress,
    required this.lessonId,
    required this.courseId,
  });
}

/// Provider for the most recently accessed lesson (for the Resume card).
@riverpod
Stream<RecentActivityVo?> recentActivity(RecentActivityRef ref) async* {
  final userProgressRepo = await ref.watch(userProgressRepositoryProvider.future);
  final courseRepo = await ref.watch(courseRepositoryProvider.future);
  
  final userIdStream = ref.watch(userIdProvider);
  final userId = userIdStream.value;
  
  if (userId == null) {
    yield null;
    return;
  }

  // Trigger background refresh of progress when this provider is watched
  userProgressRepo.refreshProgress(userId).ignore();

  yield* userProgressRepo.watchProgress(userId).asyncMap((list) async {
    if (list.isEmpty) return null;

    // Sort by lastAccessedAt descending
    final sorted = List<UserProgressDto>.from(list)
      ..sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));

    final mostRecent = sorted.first;

    // Efficiently fetch details from DB using join
    final details = await courseRepo.getLessonDetails(mostRecent.lessonId);

    return RecentActivityVo(
      lessonTitle: details?.lessonTitle ?? '',
      courseTitle: details?.courseTitle ?? '',
      chapterTitle: details?.chapterTitle ?? '',
      progress: mostRecent.percentComplete,
      lessonId: mostRecent.lessonId,
      courseId: mostRecent.courseId,
    );
  });
}
