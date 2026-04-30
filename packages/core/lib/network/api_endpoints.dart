class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/api/v2.5/auth-token/';
  static const String generateOtp = '/api/v2.5/auth/generate-otp/';
  static const String verifyOtp = '/api/v2.5/auth/otp-login/';
  static const String logout = '/api/v2.5/auth/logout/';
  static const String resetPassword = '/api/v2.3/password/reset/';
  static const String userProfile = '/api/v2.5/me/';
  static const String courseList = '/api/v3/courses/';
  static String courseDetail(String id) => '/api/v3/courses/$id/';
  static String courseChapters(String id) => '/api/v3/courses/$id/chapters/';
  static String courseContents(String id) => '/api/v3/courses/$id/contents/';
  static String runningContents(String id) => '/api/v2.5/courses/$id/running_contents/';
  static String upcomingContents(String id) => '/api/v2.5/courses/$id/upcoming_contents/';
  static String contentAttempts(String id) => '/api/v2.5/courses/$id/content_attempts/';
  static String chapterContents(String id) => '/api/v2.5/chapters/$id/contents/';
  static String lessonDetail(String id) => '/api/v2.4/contents/$id/';
  static String markCompleted(String id) => '/api/v2.5/chapter_contents/$id/attempts/';
}
