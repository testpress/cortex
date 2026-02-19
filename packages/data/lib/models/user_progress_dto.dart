/// User progress DTO — tracks per-lesson progress for a user.
class UserProgressDto {
  final String userId;
  final String lessonId;
  final String courseId;
  final int percentComplete; // 0–100
  final DateTime lastAccessedAt;

  const UserProgressDto({
    required this.userId,
    required this.lessonId,
    required this.courseId,
    required this.percentComplete,
    required this.lastAccessedAt,
  });
}
