import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/course_content.dart';
import 'course_detail_provider.dart';

part 'chapter_detail_provider.g.dart';

/// Provider that fetches a specific chapter with its lessons.
/// This provider maps the underlying DTOs to the [Chapter] domain model.
@riverpod
Future<Chapter?> chapterDetail(
  ChapterDetailRef ref,
  String courseId,
  String chapterId,
) async {
  final courseDto = await ref.watch(courseDetailProvider(courseId).future);
  if (courseDto == null) return null;

  final chapterDto = courseDto.chapters
      .where((c) => c.id == chapterId)
      .firstOrNull;
  if (chapterDto == null) return null;

  return Chapter(
    id: chapterDto.id,
    title: chapterDto.title,
    lessonCount: chapterDto.lessonCount,
    assessmentCount: chapterDto.assessmentCount,
    courseTitle: courseDto.title,
    lessons: chapterDto.lessons
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
            content: l.content.map(LessonContentItem.fromDto).toList(),
          ),
        )
        .toList(),
  );
}
