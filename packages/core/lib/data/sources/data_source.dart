import 'package:core/data/data.dart';
import '../models/paginated_response_dto.dart';

/// Abstract data source — implemented by [MockDataSource] and [HttpDataSource].
/// Repositories call these methods to populate the local Drift DB.
abstract class DataSource {
  /// Fetch all courses available to the current user.
  Future<PaginatedResponseDto<CourseDto>> getCourses(
      {int page = 1, int pageSize = 10, String? search});

  /// Fetch full metadata for a single course from `/api/v3/courses/{id}/`.
  Future<CourseDto> getCourseDetail(String courseId);

  /// Fetch chapters for a specific course, optionally filtered by parentId.
  Future<List<ChapterDto>> getChapters(String courseId, {String? parentId});

  /// Fetch all course contents for a specific course (V3 flat list).
  Future<List<LessonDto>> getCourseContents(String courseId);

  /// Fetch lessons for a specific chapter (Legacy/Sub-fetch).
  Future<List<LessonDto>> getLessons(String chapterId);

  /// Fetch today's live class schedule.
  Future<List<LiveClassDto>> getLiveClasses();

  /// Fetch discussion forum threads for a course.
  Future<List<ForumThreadDto>> getForumThreads(String courseId);

  /// Fetch per-lesson progress for a user.
  Future<List<UserProgressDto>> getUserProgress(String userId);

  /// Fetch featured banners for Explore page.
  Future<List<ExploreBannerDto>> getExploreBanners();

  /// Fetch study tips / articles.
  Future<List<StudyTipDto>> getStudyTips();

  /// Fetch short lessons for discovery.
  Future<List<ShortLessonDto>> getShortLessons();

  /// Fetch courses specifically formatted for the Discovery/Explore page.
  Future<List<DiscoveryCourseDto>> getDiscoveryCourses();

  /// Fetch the authenticated user's profile.
  Future<UserDto> getProfile();

  /// Update the authenticated user's profile with the given fields (supports multipart image updates).
  Future<UserDto> updateProfile(Map<String, dynamic> data);
}
