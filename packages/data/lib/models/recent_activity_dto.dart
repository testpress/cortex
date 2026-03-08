enum ActivityType { video, test, lesson, assessment, notes }

enum ActivityStatus { inProgress, completed }

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
}
