import 'package:flutter/foundation.dart';

/// Day activity data.
@immutable
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DayActivityDto &&
        other.date == date &&
        other.dayLabel == dayLabel &&
        other.hasActivity == hasActivity &&
        other.minutes == minutes;
  }

  @override
  int get hashCode => Object.hash(date, dayLabel, hasActivity, minutes);
}

/// Study momentum DTO — user learning activity summary.
@immutable
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudyMomentumDto &&
        listEquals(other.weekDays, weekDays) &&
        other.weeklyHours == weeklyHours &&
        other.currentStreak == currentStreak &&
        other.latestActivityTitle == latestActivityTitle &&
        other.latestActivityTimeAgo == latestActivityTimeAgo &&
        other.lessonsFinished == lessonsFinished &&
        other.testsAttempted == testsAttempted &&
        other.assessmentsDone == assessmentsDone &&
        other.strongestSubject == strongestSubject &&
        other.weakSubject == weakSubject;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(weekDays),
        weeklyHours,
        currentStreak,
        latestActivityTitle,
        latestActivityTimeAgo,
        lessonsFinished,
        testsAttempted,
        assessmentsDone,
        strongestSubject,
        weakSubject,
      );
}
