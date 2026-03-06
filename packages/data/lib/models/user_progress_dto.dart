import 'package:flutter/foundation.dart';

/// User progress DTO — tracks per-lesson progress for a user.
@immutable
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProgressDto &&
        other.userId == userId &&
        other.lessonId == lessonId &&
        other.courseId == courseId &&
        other.percentComplete == percentComplete &&
        other.lastAccessedAt == lastAccessedAt;
  }

  @override
  int get hashCode => Object.hash(
        userId,
        lessonId,
        courseId,
        percentComplete,
        lastAccessedAt,
      );
}
