import 'package:async/async.dart' show StreamGroup;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';
import '../repositories/course_repository.dart';

part 'chapter_detail_provider.g.dart';

/// Provider that fetches a specific chapter with its lessons.
/// This provider maps the underlying DTOs to the [ChapterDto] domain model.
@Riverpod(keepAlive: true)
Stream<(ChapterDto, String?)?> chapterDetail(
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

/// Helper stream that maps database rows to the ChapterDto and course title.
Stream<(ChapterDto, String?)?> _watchChapter(
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

    final chapterDto = repo.rowToChapterDto(chapterData);
    final lessonDtos = lessonsData.map(repo.rowToLessonDto).toList();

    return (chapterDto.copyWith(lessons: lessonDtos), course?.title);
  });
}

@riverpod
class ChapterDetailController extends _$ChapterDetailController {
  @override
  bool build() => true;

  Future<void> initialSync(String courseId, String chapterId) async {
    final sentry = ref.read(sentryServiceProvider);
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      await Future.wait([
        repo.syncChapterContents(courseId, chapterId),
        repo.refreshContentStatuses(courseId, chapterId: chapterId),
      ]);
    } catch (e, st) {
      sentry.captureException(e, stackTrace: st);
    } finally {
      state = false;
    }
  }

  Future<void> refresh(String courseId, String chapterId) async {
    state = true;
    final sentry = ref.read(sentryServiceProvider);
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      await Future.wait([
        repo.syncChapterContents(courseId, chapterId),
        repo.refreshContentStatuses(courseId, chapterId: chapterId),
      ]);
    } catch (e, st) {
      sentry.captureException(e, stackTrace: st);
      rethrow;
    } finally {
      state = false;
    }
  }
}
