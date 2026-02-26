import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_progress_dto.dart';
import 'repository_providers.dart';

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
Stream<RecentActivityVo?> recentActivity(Ref ref) async* {
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final courseRepo = await ref.watch(courseRepositoryProvider.future);

  // Hardcoded current user ID for MVP
  const userId = 'current_user';

  // Ensure mock data is loaded into DB
  try {
    await courseRepo.refreshCourses();
    await userRepo.refreshProgress(userId);
  } catch (_) {}

  yield* userRepo.watchProgress(userId).asyncMap((list) async {
    if (list.isEmpty) return null;

    // Sort by lastAccessedAt descending
    final sorted = List<UserProgressDto>.from(list)
      ..sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));

    final mostRecent = sorted.first;

    // Fetch details
    final courses = await courseRepo.watchCourses().first;
    final course = courses.firstWhere((c) => c.id == mostRecent.courseId);

    // In a real app, we'd fetch the specific lesson.
    // For mock, nested chapters might be missing in coarse list fetching.
    String lessonTitle = '';
    String chapterTitle = '';

    // Attempt rescue by finding the course again with chapters if needed
    // or just find the lesson across all lessons if possible.
    for (var c in courses) {
      if (c.chapters.isNotEmpty) {
        for (var chapter in c.chapters) {
          for (var lesson in chapter.lessons) {
            if (lesson.id == mostRecent.lessonId) {
              lessonTitle = lesson.title;
              chapterTitle = chapter.title;
              break;
            }
          }
        }
      }
    }

    return RecentActivityVo(
      lessonTitle: lessonTitle,
      courseTitle: course.title,
      chapterTitle: chapterTitle,
      progress: mostRecent.percentComplete,
      lessonId: mostRecent.lessonId,
      courseId: mostRecent.courseId,
    );
  });
}
