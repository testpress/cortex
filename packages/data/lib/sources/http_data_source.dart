import '../models/course_dto.dart';
import '../models/chapter_dto.dart';
import '../models/lesson_dto.dart';
import '../models/live_class_dto.dart';
import '../models/forum_thread_dto.dart';
import '../models/user_progress_dto.dart';
import 'data_source.dart';

/// HTTP data source stub — to be implemented when a real backend is available.
/// All methods throw [UnimplementedError] to surface accidental usage in tests.
///
/// Activate via: flutter run --dart-define=USE_MOCK=false
class HttpDataSource implements DataSource {
  const HttpDataSource();

  @override
  Future<List<CourseDto>> getCourses() => throw UnimplementedError(
    'HttpDataSource.getCourses is not yet implemented. Use MockDataSource.',
  );

  @override
  Future<List<ChapterDto>> getChapters(String courseId) =>
      throw UnimplementedError(
        'HttpDataSource.getChapters is not yet implemented.',
      );

  @override
  Future<List<LessonDto>> getLessons(String chapterId) =>
      throw UnimplementedError(
        'HttpDataSource.getLessons is not yet implemented.',
      );

  @override
  Future<List<LiveClassDto>> getLiveClasses() => throw UnimplementedError(
    'HttpDataSource.getLiveClasses is not yet implemented.',
  );

  @override
  Future<List<ForumThreadDto>> getForumThreads(String courseId) =>
      throw UnimplementedError(
        'HttpDataSource.getForumThreads is not yet implemented.',
      );

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) =>
      throw UnimplementedError(
        'HttpDataSource.getUserProgress is not yet implemented.',
      );
}
