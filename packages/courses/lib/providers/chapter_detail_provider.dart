import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'chapter_detail_provider.g.dart';

/// Fetches a specific chapter by ID within a course context.
@riverpod
Stream<ChapterDto?> chapterDetail(
  ChapterDetailRef ref,
  String courseId,
  String chapterId,
) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchChapters(courseId).map(
        (chapters) => chapters.where((c) => c.id == chapterId).firstOrNull,
      );
}
