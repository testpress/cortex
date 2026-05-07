import 'package:core/data/data.dart';

/// Abstract data source — implemented by [MockDataSource] and [HttpDataSource].
/// Repositories call these methods to populate the local Drift DB.
abstract class DataSource {
  /// Fetch all courses available to the current user.
  Future<PaginatedResponseDto<CourseDto>> getCourses(
      {int page = 1, int pageSize = 10, String? search, dynamic tags});

  /// Fetch full metadata for a single course from `/api/v3/courses/{id}/`.
  Future<CourseDto> getCourseDetail(String courseId);

  /// Fetch chapters for a specific course, optionally filtered by parentId.
  Future<List<ChapterDto>> getChapters(String courseId, {String? parentId});

  /// Fetch all course contents for a specific course (V3 flat list).
  Future<CourseCurriculumDto> getCourseContents(String courseId);
  
  /// Fetch running contents for a specific course.
  Future<CourseCurriculumDto> getRunningContents(String courseId);

  /// Fetch upcoming contents for a specific course.
  Future<CourseCurriculumDto> getUpcomingContents(String courseId);


  /// Fetch content attempts (History) for a specific course.
  Future<CourseCurriculumDto> getContentAttempts(String courseId);

  /// Fetch lessons for a specific chapter (Legacy/Sub-fetch).
  Future<List<LessonDto>> getLessons(String chapterId);

  /// Fetch full metadata for a single lesson from `/api/v2.4/contents/{id}/`.
  Future<LessonDto> getLessonDetail(String lessonId);

  /// Fetch today's live class schedule.
  Future<List<LiveClassDto>> getLiveClasses();

  /// Fetch discussion forum threads for a course.
  Future<List<ForumThreadDto>> getForumThreads(String courseId);

  /// Fetch forum categories available for a course.
  Future<List<ForumCategoryDto>> getForumCategories(String courseId);

  /// Fetch comments for a specific thread.
  Future<List<ForumCommentDto>> getForumComments(String threadId);

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

  /// Fetch popular tests for the Explore page.
  Future<List<PopularTestDto>> getPopularTests();

  /// Fetch hero banners for the dashboard from `/api/v3/dashboard/`.
  Future<List<DashboardBannerDto>> getDashboardBanners();

  /// Fetch top learners from `/api/v2.3/leaderboard/`.
  Future<List<LearnerDto>> getLearners();

  /// Fetch the latest content updates from `/api/v2.4/whats-new/`.
  Future<DashboardContentsDto> getWhatsNewFeed(DashboardSectionType sectionType);

  /// Fetch the resume learning feed from `/api/v2.4/resume/`.
  Future<DashboardContentsDto> getResumeLearningFeed(DashboardSectionType sectionType);
  // ── Exams ───────────────────────────────────────────────────────────────

  /// Fetch full metadata for an exam from `/api/v2.2.1/exams/{slug}/`.
  Future<ExamDto> getExam(String slug);

  /// Fetch list of historical attempts.
  Future<List<AttemptDto>> getAttempts(String attemptsUrl);

  /// Create an exam attempt.
  Future<AttemptDto> createAttempt(String attemptsUrl);

  /// Create a course-linked content attempt.
  Future<AttemptDto> createContentAttempt(String contentAttemptsUrl);

  /// Resume or start an attempt via its start URL.
  Future<AttemptDto> startAttempt(String startUrl);

  /// Fetch all questions for an attempt.
  Future<List<QuestionDto>> getQuestions(String questionsUrl);

  /// Submit a single answer to the backend.
  Future<void> submitAnswer(String answerUrl, AnswerDto answer);

  /// Send a heartbeat to maintain the attempt session.
  Future<AttemptDto> sendHeartbeat(String heartbeatUrl);

  /// End the exam attempt and finalize results.
  Future<AttemptDto> endExam(String endUrl);

  /// Start an attempt section via its start URL.
  Future<SectionDto> startSection(String startUrl);

  /// End an attempt section via its end URL.
  Future<SectionDto> endSection(String endUrl);

  /// Fetch the recently completed feed from `/api/v2.4/completed/`.
  Future<DashboardContentsDto> getRecentlyCompletedFeed(DashboardSectionType sectionType);

  /// Fetch the authenticated user's profile.
  Future<UserDto> getProfile();

  /// Update the authenticated user's profile with the given fields (supports multipart image updates).
  Future<UserDto> updateProfile(Map<String, dynamic> data);
  
  /// Fetch personal doubts for the current user.
  Future<List<DoubtDto>> getDoubts();

  /// Fetch replies for a specific doubt.
  Future<List<DoubtReplyDto>> getDoubtReplies(String doubtId);

  /// Mark a lesson as completed on the server.
  Future<void> markLessonCompleted(String lessonId);
  /// Directly downloads a file to the [savePath].
  Future<void> downloadFile({
    required String url,
    required String savePath,
    void Function(int count, int total)? onReceiveProgress,
    dynamic cancelToken,
    bool requireAuth = true,
  });
}
