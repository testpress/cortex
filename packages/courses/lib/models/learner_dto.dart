class LearnerDto {
  final String id;
  final int rank;
  final String name;
  final String avatar;
  final int points;
  final int coursesCompleted;
  final int streakDays;
  final List<LearnerBadgeDto> badges;

  const LearnerDto({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    required this.coursesCompleted,
    required this.streakDays,
    required this.badges,
  });
}

class LearnerBadgeDto {
  final String icon;
  final String label;
  final int color; // ARGB

  const LearnerBadgeDto({
    required this.icon,
    required this.label,
    required this.color,
  });
}
