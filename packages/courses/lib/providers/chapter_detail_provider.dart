import 'package:async/async.dart' show StreamGroup;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/course_content.dart';
import 'course_list_provider.dart';
import '../repositories/course_repository.dart';

part 'chapter_detail_provider.g.dart';

/// Provider that fetches a specific chapter with its lessons.
/// This provider maps the underlying DTOs to the [Chapter] domain model.
@Riverpod(keepAlive: true)
Stream<Chapter?> chapterDetail(
  ChapterDetailRef ref,
  String courseId,
  String chapterId,
) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);

  // 1. Optimized Check: If we have both metadata and lessons locally,
  // yield immediately to avoid the loader. Sync in background.
  final chapterRow = await repo.getChapter(chapterId);
  final localLessons = await repo.getLessons(chapterId);

  if (chapterRow != null && localLessons.isNotEmpty) {
    repo.syncChapterContents(courseId, chapterId).ignore();
    yield* _watchChapter(repo, courseId, chapterId);
    return;
  }

  // 2. Fetch from network only if data is missing.
  await repo.syncChapterContents(courseId, chapterId);
  yield* _watchChapter(repo, courseId, chapterId);
}

/// Helper stream that maps database rows to the Chapter domain model.
Stream<Chapter?> _watchChapter(
  CourseRepository repo,
  String courseId,
  String chapterId,
) {
  final chapterStream = repo.watchChapter(chapterId);
  final lessonsStream = repo.watchLessons(chapterId);

  // Trigger update whenever either the chapter metadata OR the lessons list changes
  return StreamGroup.merge([chapterStream, lessonsStream]).asyncMap((_) async {
    final chapterData = await repo.getChapter(chapterId);
    if (chapterData == null) return null;

    final lessonsData = await repo.getLessons(chapterId);
    final courses = await repo.watchCourses().first;
    final course = courses.where((c) => c.id == courseId).firstOrNull;

    return Chapter(
      id: chapterData.id,
      title: chapterData.title,
      lessonCount: chapterData.lessonCount,
      assessmentCount: chapterData.assessmentCount,
      courseTitle: course?.title,
      image: chapterData.image,
      lessons: lessonsData
          .map((l) => repo.rowToLessonDto(l))
          .map(
            (l) => Lesson(
              id: l.id,
              title: l.title,
              type: l.type,
              progressStatus: l.progressStatus,
              duration: l.duration,
              isLocked: l.isLocked,
              subtitle: l.subtitle,
              subjectName: l.subjectName,
              subjectIndex: l.subjectIndex,
              lessonNumber: l.lessonNumber,
              totalLessons: l.totalLessons,
              contentUrl: l.contentUrl,
              isBookmarked: l.isBookmarked,
              isRunning: l.isRunning,
              isUpcoming: l.isUpcoming,
              hasAttempts: l.hasAttempts,
              image: l.image,
              nextContentId: l.nextContentId,
              previousContentId: l.previousContentId,
              htmlContent: l.htmlContent,
            ),
          )
          .toList(),
    );
  });
}
