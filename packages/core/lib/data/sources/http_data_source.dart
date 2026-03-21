import 'package:core/data/data.dart';
import '../models/paginated_response_dto.dart';
import '../network/api_client.dart';
import 'data_source.dart';
import 'remote/remote_course_dto.dart';

/// Active HTTP data source for remote API communication.
/// Uses [ApiClient] for centralized HTTP requests and error handling.
///
/// Only methods backed by a real API endpoint are implemented here.
/// Methods not yet integrated return empty results and are stubs until
/// their respective API integrations are added.
class HttpDataSource implements DataSource {
  final ApiClient _apiClient;

  HttpDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<PaginatedResponseDto<CourseDto>> getCourses({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _apiClient.get(
      '/api/v3/courses/',
      queryParameters: {'page': page, 'page_size': pageSize},
    );

    return PaginatedResponseDto<CourseDto>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => RemoteCourseDto.fromJson(json).toDomain(),
    );
  }

  // ── Not yet integrated — stubs return empty until real endpoints are added ──

  @override
  Future<List<ChapterDto>> getChapters(String courseId) async => [];

  @override
  Future<List<LessonDto>> getLessons(String chapterId) async => [];

  @override
  Future<List<LiveClassDto>> getLiveClasses() async => [];

  @override
  Future<List<ForumThreadDto>> getForumThreads(String courseId) async => [];

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) async => [];

  @override
  Future<List<ExploreBannerDto>> getExploreBanners() async => [];

  @override
  Future<List<StudyTipDto>> getStudyTips() async => [];

  @override
  Future<List<ShortLessonDto>> getShortLessons() async => [];

  @override
  Future<List<DiscoveryCourseDto>> getDiscoveryCourses() async => [];
}
