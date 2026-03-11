import 'package:flutter/foundation.dart';

enum ActivityType { video, test, lesson, assessment, notes }

enum ActivityStatus { inProgress, completed }

@immutable
class RecentActivityDto {
  final String id;
  final ActivityType type;
  final String title;
  final String timeAgo;
  final ActivityStatus status;
  final int? progress;
  final int? score;

  const RecentActivityDto({
    required this.id,
    required this.type,
    required this.title,
    required this.timeAgo,
    required this.status,
    this.progress,
    this.score,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecentActivityDto &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.timeAgo == timeAgo &&
        other.status == status &&
        other.progress == progress &&
        other.score == score;
  }

  @override
  int get hashCode => Object.hash(
        id,
        type,
        title,
        timeAgo,
        status,
        progress,
        score,
      );
}
