class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/api/v2.5/auth-token/';
  static const String generateOtp = '/api/v2.5/auth/generate-otp/';
  static const String verifyOtp = '/api/v2.5/auth/otp-login/';
  static const String logout = '/api/v2.4/auth/logout/';
  static const String logoutDevices = '/api/v2.4/auth/logout_devices/';
  static const String resetPassword = '/api/v2.3/password/reset/';
  static const String userProfile = '/api/v2.5/me/';
  static const String loginActivity = '/api/v2.3/me/login_activity/';
  static const String courseList = '/api/v3/courses/';
  static String courseDetail(String id) => '/api/v3/courses/$id/';
  static String courseChapters(String id) => '/api/v3/courses/$id/chapters/';
  static String courseContents(String id) => '/api/v3/courses/$id/contents/';
  static String runningContents(String id) =>
      '/api/v2.5/courses/$id/running_contents/';
  static String upcomingContents(String id) =>
      '/api/v2.5/courses/$id/upcoming_contents/';
  static String contentAttempts(String id) =>
      '/api/v2.5/courses/$id/content_attempts/';
  static String chapterContents(String id) =>
      '/api/v2.5/chapters/$id/contents/';
  static String lessonDetail(String id) => '/api/v2.4/contents/$id/';
  static String markCompleted(String id) =>
      '/api/v2.5/chapter_contents/$id/attempts/';
  static const String updateVideoAttempt =
      '/api/v2.5/chapter_content_attempts/videos/update/';
  static const String bannerAds = '/api/v2.4/banner-ads/';

  // Posts / Announcements
  static const String posts = '/api/v3/posts/';
  static const String postCategories = '/api/v2.3/posts/categories/';

  static const String leaderboard = '/api/v2.3/leaderboard/';
  static const String myRank = '/api/v2.3/me/rank/';
  static const String competitorTargets = '/api/v2.3/me/targets/';
  static const String competitorThreats = '/api/v2.3/me/threats/';
  static const String whatsNewFeed = '/api/v2.4/whats-new/';
  static const String resumeLearning = '/api/v2.4/resume/';
  static const String recentlyCompleted = '/api/v2.4/completed/';

  // Exams
  static const String subjectReports =
      '/api/v3/analytics/overall-subject-analytics/';
  static String subjectAnalytics(String attemptId) =>
      '/api/v2.3/attempts/$attemptId/review/subjects/';
  static String contentAttemptEnd(String id) =>
      '/api/v2.3/content_attempts/$id/end/';

  static String solutionsReview(String attemptId) =>
      '/api/v2.3/attempts/$attemptId/review/';

  // Exam Routing (v3 and v2.x hardcoded)
  static String examQuestions(String attemptId) =>
      '/api/v3/attempts/$attemptId/user_answers/?page_size=1000';
  static String submitAnswer(String attemptId, String questionId) =>
      '/api/v3/attempts/$attemptId/user_answers/$questionId/';
  static String startAttempt(String attemptId) =>
      '/api/v2.3/attempts/$attemptId/start/';
  static String endAttempt(String attemptId) =>
      '/api/v2.3/attempts/$attemptId/end/';
  static String reviewAttempt(String attemptId) =>
      '/api/v2.5/attempts/$attemptId/review/';
  static String startSection(String attemptId, String sectionOrder) =>
      '/api/v3/attempts/$attemptId/section/$sectionOrder/start/';
  static String endSection(String attemptId, String sectionOrder) =>
      '/api/v3/attempts/$attemptId/section/$sectionOrder/end/';
  static String heartbeat(String attemptId) =>
      '/api/v2.3/attempts/$attemptId/heartbeat/';
  static String sectionHeartbeat(String attemptId, String sectionOrder) =>
      '/api/v2.3/attempts/$attemptId/section/$sectionOrder/heartbeat/';

  // Forum
  static const String forumCategories = '/api/v2.3/forum/categories/';
  static const String forumThreads = '/api/v2.5/discussions/';
  static String forumThreadDetail(String slug) =>
      '/api/v2.5/discussions/$slug/';
  static String forumComments(int threadId) =>
      '/api/v2.5/discussions/$threadId/comments/';

  // Uploads
  static const String imageUpload = '/api/v2.3/image_upload/';

  // Bookmarks
  static const String bookmarkFolders = '/api/v2.5/folders/';
  static const String createBookmarkFolder = '/api/v3/bookmarks/folders/';
  static String updateBookmarkFolder(String id) => '/api/v2.5/folders/$id/';
  static String deleteBookmarkFolder(String id) => '/api/v2.5/folders/$id/';
  static const String bookmarks = '/api/v3/bookmarks/';
  static const String bookmarksV2_4 = '/api/v2.4/bookmarks/';
  static String deleteBookmark(String id) => '/api/v3/bookmarks/$id/';

  // Helpdesk / Doubts
  static const String helpdeskTopics = '/api/v2.5/helpdesk/topics/';
  static const String helpdeskTickets = '/api/v3/helpdesk/';
  static String helpdeskTicketDetail(String id) => '/api/v3/helpdesk/$id/';
  static String helpdeskTicketFollowup(String id) =>
      '/api/v3/helpdesk/$id/followup/';
  static const String imageUploadV3 = '/api/v3/upload-image/';
}
