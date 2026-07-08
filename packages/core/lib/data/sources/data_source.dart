import 'dart:io';
import 'package:core/data/data.dart';

/// Abstract data source — implemented by [MockDataSource] and [HttpDataSource].
/// Repositories call these methods to populate the local Drift DB.
abstract class DataSource {
  /// Fetch all courses available to the current user.
  Future<PaginatedResponseDto<CourseDto>> getCourses({
    int page = 1,
    int pageSize = 10,
    String? search,
    dynamic tags,
  });

  /// Fetch full metadata for a single course from `/api/v3/courses/{id}/`.
  Future<CourseDto> getCourseDetail(String courseId);

  /// Fetch chapters for a specific course, optionally filtered by parentId.
  Future<List<ChapterDto>> getChapters(String courseId, {String? parentId});

  /// Fetch full metadata for a single chapter by slug.
  Future<ChapterDto> getChapterDetail(String slug);

  /// Fetch all course contents for a specific course (V3 flat list).
  /// [chapterId] is an optional filter to fetch only a specific branch.
  /// [type] is an optional filter to scope results to a content type (video, assessment, test, etc).
  /// Returns a Stream to support incremental/paginated updates.
  Stream<CourseCurriculumDto> getCourseContents(
    String courseId, {
    String? chapterId,
    String? type,
  });

  /// Fetch running contents for a specific course.
  Future<CourseCurriculumDto> getRunningContents(
    String courseId, {
    String? chapterId,
  });

  /// Fetch upcoming contents for a specific course.
  Future<CourseCurriculumDto> getUpcomingContents(
    String courseId, {
    String? chapterId,
  });

  /// Fetch content attempts (History) for a specific course.
  Future<CourseCurriculumDto> getContentAttempts(
    String courseId, {
    String? chapterId,
  });

  /// Fetch lessons for a specific chapter (Legacy/Sub-fetch).
  Future<List<LessonDto>> getLessons(String chapterId);

  /// Fetch full metadata for a single lesson from `/api/v2.4/contents/{id}/`.
  Future<LessonDto> getLessonDetail(String lessonId);

  /// Fetch today's live class schedule.
  Future<List<LiveClassDto>> getLiveClasses();

  /// Fetch all forum categories (global, not course-scoped).
  Future<List<ForumCategoryDto>> getForumCategories();

  /// Fetch paginated global forum threads, optionally filtered by category.
  Future<PaginatedResponseDto<ForumThreadDto>> getForumThreads({
    int page = 1,
    int? categoryId,
    String? searchQuery,
  });

  /// Fetch a single forum thread by slug.
  Future<ForumThreadDto> getForumThread(String slug);

  // ── Forum Comments ─────────────────────────────────────────────────────────

  Future<PaginatedResponseDto<ForumCommentDto>> getForumComments({
    required int threadId,
    int page = 1,
  });

  Future<ForumCommentDto> postForumComment({
    required int threadId,
    required String content,
  });

  Future<ForumThreadDto> postForumThread({
    required String title,
    required String contentHtml,
    required String categorySlug,
    String? courseId,
  });

  Future<String> uploadImage(File file);

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

  /// Fetch leaderboards from `/api/v2.3/leaderboard/` for a specific timeline and page.
  Future<List<LearnerDto>> fetchLeaderboard({
    required LeaderboardTimeline timeline,
    int limit = 10,
    int page = 1,
  });

  /// Fetch the authenticated user's current rank and leaderboard stats.
  Future<LearnerDto> fetchMyRank();

  /// Fetch users strictly ranked above the current user.
  Future<List<LearnerDto>> fetchCompetitorTargets();

  /// Fetch users ranked equal to or below the current user.
  Future<List<LearnerDto>> fetchCompetitorThreats();

  /// Fetch the latest content updates from `/api/v2.4/whats-new/`.
  Future<DashboardContentsDto> getWhatsNewFeed(
    DashboardSectionType sectionType,
  );

  /// Fetch the resume learning feed from `/api/v2.4/resume/`.
  Future<DashboardContentsDto> getResumeLearningFeed(
    DashboardSectionType sectionType,
  );

  // ── Posts / Announcements ────────────────────────────────────────────────

  /// Fetch a paginated list of posts/announcements.
  Future<PaginatedResponseDto<PostDto>> getPosts({
    int page = 1,
    String? categorySlug,
  });

  /// Fetch a list of post categories.
  Future<List<PostCategoryDto>> getPostCategories();

  // ── Exams ───────────────────────────────────────────────────────────────

  /// Fetch list of historical attempts.
  Future<List<AttemptDto>> getAttempts(String attemptsUrl);

  /// Create a standalone exam attempt
  Future<AttemptDto> createAttempt(
    String attemptsUrl, {
    Map<String, dynamic>? data,
  });

  /// Create a course-linked exam attempt (which tracks course progress)
  Future<AttemptDto> createContentAttempt(
    String contentAttemptsUrl, {
    Map<String, dynamic>? data,
  });

  /// Resume or start an attempt via its start URL.
  Future<AttemptDto> startAttempt(String attemptId);

  /// Fetch all questions for an attempt using v3 unified endpoint.
  Future<List<QuestionDto>> getQuestions(String attemptId);

  /// Fetch all questions directly for an offline exam using v2.4 endpoint without creating an attempt.
  Future<List<QuestionDto>> getOfflineExamQuestions(String examId);

  /// Submit offline exam answers in bulk.
  Future<void> submitOfflineExamAnswers(
    String examId,
    Map<String, dynamic> payload,
  );

  /// Submit a single answer to the backend.
  Future<QuizReviewResultDto?> submitAnswer(
    String attemptId,
    String questionId,
    AnswerDto answer,
  );

  /// Report a question for errors (e.g. incorrect answer, unclear).
  Future<void> reportQuestion(String questionId, Map<String, dynamic> payload);

  /// Send a heartbeat to maintain the attempt session.
  Future<AttemptDto> sendHeartbeat(String attemptId);

  /// Fetch last watched position from an attempts URL.
  Future<String?> getLastWatchedPosition(String attemptsUrl);

  /// Update video attempt with new time ranges
  Future<void> updateVideoAttempt({
    required int chapterContentId,
    required String lastWatchPosition,
    required List<List<double>> watchedTimeRanges,
  });

  /// End the exam attempt and finalize results.
  Future<AttemptDto> endExam(String attemptId);

  /// Fetch all review items / solution details for an attempt.
  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl);

  /// Fetch subject-wise analytics for a specific attempt.
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(String analyticsUrl);

  /// Fetch subject analytics for the root dashboard screen or nested subtopics.
  Future<PaginatedResponseDto<SubjectAnalyticsDto>> getAnalyticsData({
    int page = 1,
    int? parentId,
  });

  /// Start an attempt section.
  Future<SectionDto> startSection(String attemptId, String sectionOrder);

  /// End an attempt section.
  Future<SectionDto> endSection(String attemptId, String sectionOrder);

  /// Fetch the recently completed feed from `/api/v2.4/completed/`.
  Future<DashboardContentsDto> getRecentlyCompletedFeed(
    DashboardSectionType sectionType,
  );

  /// Fetch the authenticated user's profile.
  Future<UserDto> getProfile();

  /// Update the authenticated user's profile with the given fields (supports multipart image updates).
  Future<UserDto> updateProfile(Map<String, dynamic> data);

  /// Fetch the authenticated user's login activity.
  Future<PaginatedLoginActivityDto> getLoginActivity({int page = 1});

  /// Fetch personal doubts for the current user.
  Future<PaginatedResponseDto<DoubtDto>> getDoubts({
    int page = 1,
    String? searchQuery,
    int? chapterContentId,
    String? queryType,
  });

  /// Fetch the detail for a specific doubt, including its replies.
  /// Returns both the [DoubtDto] (with fresh status/content) and its [DoubtReplyDto] list.
  Future<({DoubtDto doubt, List<DoubtReplyDto> replies})> getDoubtReplies(
    String doubtId,
  );

  /// Fetch dynamic doubt categories/topics hierarchy.
  Future<List<DoubtTopicDto>> getDoubtTopics({int? parentId});

  /// Create a new doubt on the server.
  Future<DoubtDto> createDoubt({
    required String title,
    required String description,
    int? topicId,
    int? chapterContentId,
    int? questionId,
    int? queryType,
  });

  /// Post a reply comment to a doubt, optionally resolving or closing it.
  Future<DoubtReplyDto> postDoubtReply({
    required String doubtId,
    String? comment,
    bool? shouldResolve,
    bool? shouldClose,
  });

  /// Upload an image specifically for doubts attachments storage.
  Future<String> uploadDoubtImage(File file, {int? ticketId});

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

  // ── Bookmarks ───────────────────────────────────────────────────────────

  /// Fetch user's bookmark folders.
  Future<List<BookmarkFolderDto>> getBookmarkFolders();

  /// Fetch a paginated list of bookmarks (v2.4).
  Future<PaginatedResponseDto<BookmarkDto>> getBookmarks({
    int page = 1,
    String? folder,
    String? order,
    String? filter,
  });

  /// Create a new bookmark folder.
  Future<BookmarkFolderDto> createBookmarkFolder(String name);

  /// Update an existing bookmark folder.
  Future<BookmarkFolderDto> updateBookmarkFolder(int id, String name);

  /// Delete an existing bookmark folder.
  Future<void> deleteBookmarkFolder(int id);

  /// Create a new bookmark for a lesson.
  Future<BookmarkDto> createBookmark({
    required String category,
    required int lessonId,
    String? folder,
    String? bookmarkType,
  });

  /// Delete a bookmark by its server-side ID.
  Future<void> deleteBookmark(String bookmarkId);
}
