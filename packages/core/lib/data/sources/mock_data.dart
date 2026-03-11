import 'package:core/data/data.dart';

/// Mock current user
final mockCurrentUser = UserDto(
  id: 'user_1',
  name: 'Arjun Sharma',
  email: 'arjun.sharma@example.com',
  phone: '+91 9876543210',
  avatar:
      'https://images.unsplash.com/photo-1529068755536-a5ade0dcb4e8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwcG9ydHJhaXR8ZW58MXx8fHwxNzY3ODY0MjA2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
  isPro: true,
  joinedDate: DateTime(2023, 8, 15),
);

DateTime mockStudyMomentumReferenceDate = DateTime(2026, 3, 11);

/// Mock study momentum.
final mockStudyMomentum = StudyMomentumDto(
  weekDays: [
    DayActivityDto(
      date: mockStudyMomentumReferenceDate.subtract(const Duration(days: 6)),
      dayLabel: 'M',
      hasActivity: true,
      minutes: 120,
    ),
    DayActivityDto(
      date: mockStudyMomentumReferenceDate.subtract(const Duration(days: 5)),
      dayLabel: 'T',
      hasActivity: true,
      minutes: 90,
    ),
    DayActivityDto(
      date: mockStudyMomentumReferenceDate.subtract(const Duration(days: 4)),
      dayLabel: 'W',
      hasActivity: true,
      minutes: 150,
    ),
    DayActivityDto(
      date: mockStudyMomentumReferenceDate.subtract(const Duration(days: 3)),
      dayLabel: 'T',
      hasActivity: true,
      minutes: 60,
    ),
    DayActivityDto(
      date: mockStudyMomentumReferenceDate.subtract(const Duration(days: 2)),
      dayLabel: 'F',
      hasActivity: true,
      minutes: 210,
    ),
    DayActivityDto(
      date: mockStudyMomentumReferenceDate.subtract(const Duration(days: 1)),
      dayLabel: 'S',
      hasActivity: true,
      minutes: 45,
    ),
    DayActivityDto(
      date: mockStudyMomentumReferenceDate,
      dayLabel: 'S',
      hasActivity: true,
      minutes: 180,
    ),
  ],
  weeklyHours: 14.5,
  currentStreak: 12,
  latestActivityTitle: 'Calculus Mock Test',
  latestActivityTimeAgo: '1h ago',
  lessonsFinished: 45,
  testsAttempted: 18,
  assessmentsDone: 32,
  strongestSubject: 'Mathematics',
  weakSubject: 'Organic Chemistry',
);
