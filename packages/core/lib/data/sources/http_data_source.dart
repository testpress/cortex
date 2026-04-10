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
  Future<List<LessonDto>> getCourseContents(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.courseContents(courseId)),
      fromJson: (data) => _mapLessons(data),
    );
  }

  @override
  Future<List<LessonDto>> getRunningContents(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.runningContents(courseId)),
      fromJson: (data) => _mapLessons(data),
    );
  }

  @override
  Future<List<LessonDto>> getUpcomingContents(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.upcomingContents(courseId)),
      fromJson: (data) => _mapLessons(data),
    );
  }

  @override
  Future<List<LessonDto>> getContentAttempts(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.contentAttempts(courseId)),
      fromJson: (data) => _mapLessons(data),
    );
  }

  List<LessonDto> _mapLessons(dynamic data, {String? chapterId}) {
    if (data is! Map) {
      return [];
    }
    
    final results = data['results'];
    List<dynamic>? list;
    Map<String, String> chapterNames = {};

    if (results is Map) {
      // Handle both V2.5 (chapter_contents) and V3 (contents) structures
      // Also check for 'results' nested inside 'results' which happens in some V3 layouts
      list = (results['contents'] ?? 
              results['chapter_contents'] ?? 
              results['results']) as List<dynamic>?;
      
      // Extract chapter metadata if available to enrich lessons
      final chaptersList = results['chapters'] as List<dynamic>?;
      if (chaptersList != null) {
        for (var c in chaptersList) {
          final id = c['id']?.toString();
          final name = c['name'] as String?;
          if (id != null && name != null) chapterNames[id] = name;
        }
      }
    } else if (results is List) {
      list = results;
    }

    final lessons = list?.map((e) {
      final json = e as Map<String, dynamic>;
      
      // Filter out curriculum items that are actually chapters
      final type = (json['content_type'] ?? json['type'] ?? json['kind'])?.toString().toLowerCase();
      if (type == 'chapter') return null;

      final dto = LessonDto.fromJson(json);
      
      // Enrich with chapter title if we found it in the metadata
      if (dto.chapterTitle == null || dto.chapterTitle!.isEmpty) {
        final name = chapterNames[dto.chapterId] ?? chapterNames[json['chapter']?.toString() ?? ''];
        if (name != null) return dto.copyWith(chapterTitle: name);
      }

      // Enforce specific chapter ID if provided (useful when API doesn't return it for specific chapter fetch)
      if (chapterId != null && (dto.chapterId.isEmpty || dto.chapterId == '0')) {
        return dto.copyWith(chapterId: chapterId);
      }


      return dto;
    }).whereType<LessonDto>().toList() ?? [];

    return lessons;
  }

  @override
  Future<List<LessonDto>> getLessons(String chapterId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.chapterContents(chapterId)), 
      fromJson: (data) => _mapLessons(data, chapterId: chapterId),
    );
  }

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
