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
  Future<UserDto> updateProfile(
    Map<String, dynamic> data,
  ) async {
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
