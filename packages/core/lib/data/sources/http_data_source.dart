import 'package:core/data/data.dart';
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
  Future<UserDto> getUserProfile() => throw UnimplementedError(
        'HttpDataSource.getUserProfile is not yet implemented.',
      );

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) =>
      throw UnimplementedError(
        'HttpDataSource.getUserProgress is not yet implemented.',
      );

  @override
  Future<List<ExploreBannerDto>> getExploreBanners() =>
      throw UnimplementedError(
        'HttpDataSource.getExploreBanners is not yet implemented.',
      );

  @override
  Future<List<StudyTipDto>> getStudyTips() => throw UnimplementedError(
        'HttpDataSource.getStudyTips is not yet implemented.',
      );

  @override
  Future<List<ShortLessonDto>> getShortLessons() => throw UnimplementedError(
        'HttpDataSource.getShortLessons is not yet implemented.',
      );

  @override
  Future<List<DiscoveryCourseDto>> getDiscoveryCourses() =>
      throw UnimplementedError(
        'HttpDataSource.getDiscoveryCourses is not yet implemented.',
      );
}
