import 'package:core/data/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the shared [CourseApiService] instance.
final courseApiServiceProvider = Provider<CourseApiService>((ref) {
  final dio = ref.read(dioProvider);
  return CourseApiService(dio);
});

/// Service responsible for course-related API calls.
///
/// This is a scaffold for parallel API integration work. Endpoint wiring and
/// response mapping will be implemented in follow-up changes.
class CourseApiService {
  CourseApiService(this._dio);

  // Used in follow-up implementation when endpoint wiring is added.
  // ignore: unused_field
  final Dio _dio;

  Future<List<CourseDto>> getCourses() {
    throw UnimplementedError('CourseApiService.getCourses is not implemented');
  }

  Future<CourseDto> getCourse(String courseId) {
    throw UnimplementedError('CourseApiService.getCourse is not implemented');
  }

  Future<List<ChapterDto>> getChapters(String courseId) {
    throw UnimplementedError('CourseApiService.getChapters is not implemented');
  }

  Future<List<LessonDto>> getLessons(String chapterId) {
    throw UnimplementedError('CourseApiService.getLessons is not implemented');
  }
}
