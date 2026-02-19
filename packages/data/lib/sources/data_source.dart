import '../models/course_dto.dart';
import '../models/chapter_dto.dart';
import '../models/lesson_dto.dart';
import '../models/live_class_dto.dart';
import '../models/forum_thread_dto.dart';
import '../models/user_progress_dto.dart';

/// Abstract data source — implemented by [MockDataSource] and [HttpDataSource].
/// Repositories call these methods to populate the local Drift DB.
abstract class DataSource {
  /// Fetch all courses available to the current user.
  Future<List<CourseDto>> getCourses();

  /// Fetch chapters for a specific course.
  Future<List<ChapterDto>> getChapters(String courseId);

  /// Fetch lessons for a specific chapter.
  Future<List<LessonDto>> getLessons(String chapterId);

  /// Fetch today's live class schedule.
  Future<List<LiveClassDto>> getLiveClasses();

  /// Fetch discussion forum threads for a course.
  Future<List<ForumThreadDto>> getForumThreads(String courseId);

  /// Fetch per-lesson progress for a user.
  Future<List<UserProgressDto>> getUserProgress(String userId);
}
