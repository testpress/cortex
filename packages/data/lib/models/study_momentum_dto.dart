/// Day activity data.
class DayActivityDto {
  final DateTime date;
  final String dayLabel;
  final bool hasActivity;
  final int minutes;

  const DayActivityDto({
    required this.date,
    required this.dayLabel,
    required this.hasActivity,
    this.minutes = 0,
  });
}

/// Study momentum DTO — user learning activity summary.
class StudyMomentumDto {
  final List<DayActivityDto> weekDays;
  final double weeklyHours;
  final int currentStreak;
  final String? latestActivityTitle;
  final String? latestActivityTimeAgo;
  final int lessonsFinished;
  final int testsAttempted;
  final int assessmentsDone;
  final String? strongestSubject;
  final String? weakSubject;

  const StudyMomentumDto({
    required this.weekDays,
    required this.weeklyHours,
    required this.currentStreak,
    this.latestActivityTitle,
    this.latestActivityTimeAgo,
    this.lessonsFinished = 0,
    this.testsAttempted = 0,
    this.assessmentsDone = 0,
    this.strongestSubject,
    this.weakSubject,
  });
}
