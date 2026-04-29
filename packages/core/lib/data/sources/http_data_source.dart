import 'package:dio/dio.dart';
import 'package:core/data/data.dart';
import '../../network/api_endpoints.dart';
import '../../network/network_utils.dart';

/// HTTP data source stub — to be implemented when a real backend is available.
/// All methods throw [UnimplementedError] to surface accidental usage in tests.
///
/// Activate via: flutter run --dart-define=USE_MOCK=false
class HttpDataSource implements DataSource {
  final Dio _dio;

  HttpDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<PaginatedResponseDto<CourseDto>> getCourses({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.courseList,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (search != null && search.isNotEmpty) 'q': search,
        },
      ),
      fromJson: (json) => PaginatedResponseDto<CourseDto>.fromJson(
        json,
        (item) => CourseDto.fromJson(item),
      ),
    );
  }

  @override
  Future<CourseDto> getCourseDetail(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.courseDetail(courseId)),
      fromJson: CourseDto.fromJson,
    );
  }

  @override
  Future<List<ChapterDto>> getChapters(String courseId, {String? parentId}) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.courseChapters(courseId),
        queryParameters: {
          'parent_id': parentId ?? 'null',
        },
      ),
      fromJson: (data) {
        final results = data['results'] as Map<String, dynamic>?;
        final chaptersList = results?['chapters'] as List<dynamic>?;

        return chaptersList
                ?.map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
      },
    );
  }

  @override
  Future<List<LessonDto>> getCourseContents(String courseId) =>
      throw UnimplementedError(
        'HttpDataSource.getCourseContents is not yet implemented.',
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
      Future.value(mockForumThreads(courseId));

  @override
  Future<List<ForumCategoryDto>> getForumCategories(String courseId) =>
      Future.value(mockForumCategories);

  @override
  Future<List<ForumCommentDto>> getForumComments(String threadId) =>
      Future.value(mockForumComments(threadId));

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) =>
      throw UnimplementedError(
        'HttpDataSource.getUserProgress is not yet implemented.',
      );

  @override
  Future<List<ExploreBannerDto>> getExploreBanners() async => mockExploreBanners;

  @override
  Future<List<StudyTipDto>> getStudyTips() async => mockStudyTips;

  @override
  Future<List<ShortLessonDto>> getShortLessons() async => mockShortLessons;

  @override
  Future<List<DiscoveryCourseDto>> getDiscoveryCourses() async =>
      mockDiscoveryCourses;

  @override
  Future<List<PopularTestDto>> getPopularTests() async => mockPopularTests;



  @override
  Future<UserDto> getProfile() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.userProfile),
      fromJson: UserDto.fromJson,
    );
  }

  @override
  Future<UserDto> updateProfile(Map<String, dynamic> data) async {
    final dynamic body;
    // If the data contains a 'photo' key with a file path, we use FormData for multipart upload
    if (data.containsKey('photo') && data['photo'] is String) {
      final map = Map<String, dynamic>.from(data);
      map['photo'] = await MultipartFile.fromFile(
        map['photo'] as String,
        filename: 'profile_image.jpg',
      );
      body = FormData.fromMap(map);
    } else {
      body = data;
    }

    return performNetworkRequest(
      _dio.patch(ApiEndpoints.userProfile, data: body),
      fromJson: UserDto.fromJson,
    );
  }
}
