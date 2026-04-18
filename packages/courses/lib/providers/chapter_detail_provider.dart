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
  
  // 1. Get the chapter data
  final chapterRow = await ref.watch(StreamProvider((_) => repo.watchChapter(chapterId)).future);
  if (chapterRow == null) return null;

  // 2. Fetch the course for title
  final courseStream = repo.watchCourses().map((l) => l.where((c) => c.id == courseId).firstOrNull);
  final courseRow = await ref.watch(StreamProvider((_) => courseStream).future);

  // 3. Refresh lessons in background
  repo.refreshLessons(chapterId).ignore();

  // 4. Watch lessons
  final lessonsStream = repo.watchLessons(chapterId);
  final lessonsRow = await ref.watch(StreamProvider((_) => lessonsStream).future);

  return Chapter(
    id: chapterRow.id,
    title: chapterRow.title,
    lessonCount: chapterRow.lessonCount,
    assessmentCount: chapterRow.assessmentCount,
    courseTitle: courseRow?.title,
    image: chapterRow.image,
    lessons: lessonsRow
        .map(
          (l) => Lesson(
            id: l.id,
            title: l.title,
            type: repo.rowToLessonDto(l).type,
            progressStatus: repo.rowToLessonDto(l).progressStatus,
            duration: l.duration,
            isLocked: l.isLocked,
            subtitle: l.subtitle,
            subjectName: l.subjectName,
            subjectIndex: l.subjectIndex,
            lessonNumber: l.lessonNumber,
            totalLessons: l.totalLessons,
            contentUrl: l.contentUrl,
          ),
        )
        .toList(),
  );
}
