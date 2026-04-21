import 'package:dio/dio.dart';
import 'package:core/data/data.dart';
import '../../network/api_endpoints.dart';
import '../../network/network_utils.dart';
import 'curriculum_parser.dart';

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
  Future<CourseCurriculumDto> getCourseContents(String courseId) async {
    final List<LessonDto> allLessons = [];
    final List<ChapterDto> allChapters = [];
    String? nextUrl = ApiEndpoints.courseContents(courseId);

    // Follow pagination links to ensure a complete blueprint of the course.
    // This prevents the "5 vs 2" lesson count inconsistency.
    while (nextUrl != null) {
      final responseData = await performNetworkRequest(
        _dio.get(nextUrl),
        fromJson: (data) => data,
      );

      final curriculum = CurriculumParser.parseFullCurriculum(responseData);
      allLessons.addAll(curriculum.lessons);
      allChapters.addAll(curriculum.chapters);

      // Extract next page URL, handling both absolute and relative paths.
      final next = responseData['next'] as String?;
      if (next != null && !next.startsWith('http')) {
        nextUrl = '${AppConfig.apiBaseUrl}$next';
      } else {
        nextUrl = next;
      }
    }

    print('DEBUG_SYNC: Final Course contents ($courseId) -> Total Lessons: ${allLessons.length}, Total Chapters: ${allChapters.length}');
    
    return CourseCurriculumDto(
      lessons: allLessons,
      chapters: allChapters,
    );
  }

  @override
  Future<CourseCurriculumDto> getRunningContents(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.runningContents(courseId)),
      fromJson: (data) => CurriculumParser.parseFullCurriculum(data),
    );
  }

  @override
  Future<CourseCurriculumDto> getUpcomingContents(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.upcomingContents(courseId)),
      fromJson: (data) => CurriculumParser.parseFullCurriculum(data),
    );
  }

  @override
  Future<CourseCurriculumDto> getContentAttempts(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.contentAttempts(courseId)),
      fromJson: (data) => CurriculumParser.parseFullCurriculum(data),
    );
  }


  @override
  Future<List<LessonDto>> getLessons(String chapterId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.chapterContents(chapterId)), 
      fromJson: (data) => CurriculumParser.mapLessons(data, chapterId: chapterId),
    );
  }

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
