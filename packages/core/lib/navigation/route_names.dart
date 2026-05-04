/// Centralized route names for the Cortex application.
/// 
/// Using constants ensures that all packages (core, courses, exams, testpress)
/// can refer to the same navigation targets without tight coupling to URL paths.
class AppRouteNames {
  static const lessonDetail = 'lesson-detail';
  static const videoDetail = 'video-detail';
  static const testDetail = 'test-detail';
  static const assessmentDetail = 'assessment-detail';
  
  // Tab routes
  static const home = 'home';
  static const study = 'study';
  static const exams = 'exams';
  static const explore = 'explore';
  static const profile = 'profile';
  static const info = 'info';
}
