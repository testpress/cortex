import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/course_content.dart';
import 'course_list_provider.dart';

part 'chapter_detail_provider.g.dart';

/// Provider that fetches a specific chapter with its lessons.
/// This provider maps the underlying DTOs to the [Chapter] domain model.
@riverpod
Future<Chapter?> chapterDetail(
  ChapterDetailRef ref,
  String courseId,
  String chapterId,
) async {
  final repo = await ref.watch(courseRepositoryProvider.future);

  // 1. Fetch the chapter directly from DB. 
  // This ensures we find sub-chapters that aren't in the course's root list.
  final chapterData = await repo.watchChapter(chapterId).first;
  if (chapterData == null) return null;

  // 2. Fetch lessons for this chapter
  final lessonsData = await repo.watchLessons(chapterId).first;

  // 3. Get course title for display
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
            isBookmarked: l.isBookmarked,
            isRunning: l.isRunning,
            isUpcoming: l.isUpcoming,
            hasAttempts: l.hasAttempts,
            contentUrl: l.contentUrl,
            image: l.image,
          ),
        )
        .toList(),
  );
}
