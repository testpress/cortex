import 'dart:io';

import 'package:core/data/data.dart';
import '../models/paginated_response_dto.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';
import 'data_source.dart';

/// Active HTTP data source for remote API communication.
/// Uses [ApiClient] for centralized HTTP requests and error handling.
class HttpDataSource implements DataSource {
  final ApiClient _apiClient;
  final _mock = const MockDataSource();

  HttpDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<PaginatedResponseDto<CourseDto>> getCourses({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '/api/v3/courses/',
        queryParameters: {'page': page, 'page_size': pageSize},
      );

      return PaginatedResponseDto<CourseDto>.fromJson(
        response.data,
        (json) => CourseDto.fromJson(json),
      );
    } on ApiException catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        return PaginatedResponseDto(results: []);
      }
      rethrow;
    }
  }

  @override
  Future<List<ChapterDto>> getChapters(String courseId) =>
      _mock.getChapters(courseId);

  @override
  Future<List<LessonDto>> getLessons(String chapterId) =>
      _mock.getLessons(chapterId);

  @override
  Future<List<LiveClassDto>> getLiveClasses() => _mock.getLiveClasses();

  @override
  Future<List<ForumThreadDto>> getForumThreads(String courseId) =>
      _mock.getForumThreads(courseId);

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) =>
      _mock.getUserProgress(userId);

  @override
  Future<List<ExploreBannerDto>> getExploreBanners() =>
      _mock.getExploreBanners();

  @override
  Future<List<StudyTipDto>> getStudyTips() => _mock.getStudyTips();

  @override
  Future<List<ShortLessonDto>> getShortLessons() => _mock.getShortLessons();

  @override
  Future<List<DiscoveryCourseDto>> getDiscoveryCourses() =>
      _mock.getDiscoveryCourses();
}
