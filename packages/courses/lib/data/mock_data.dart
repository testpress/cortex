import 'package:data/models/live_class_dto.dart';
import 'package:data/models/assignment_dto.dart';
import 'package:data/models/test_dto.dart';
import 'package:data/models/study_momentum_dto.dart';

/// Mock live classes for today.
const mockTodayClasses = [
  LiveClassDto(
    id: '1',
    subject: 'Physics - Thermodynamics',
    topic: 'Laws of Thermodynamics & Heat Engines',
    time: '10:00 AM - 12:00 PM',
    faculty: 'Prof. Anita Sharma',
    status: LiveClassStatus.completed,
  ),
  LiveClassDto(
    id: '2',
    subject: 'Chemistry - Organic Chemistry',
    topic: 'Reaction Mechanisms',
    time: '3:00 PM - 5:00 PM',
    faculty: 'Dr. Rajesh Kumar',
    status: LiveClassStatus.live,
  ),
  LiveClassDto(
    id: '3',
    subject: 'Mathematics - Calculus II',
    topic: 'Integration Techniques',
    time: '5:30 PM - 7:30 PM',
    faculty: 'Dr. Vikram Singh',
    status: LiveClassStatus.upcoming,
  ),
  LiveClassDto(
    id: '4',
    subject: 'English - Communication Skills',
    topic: 'Essay Writing & Comprehension',
    time: '8:00 PM - 9:00 PM',
    faculty: 'Ms. Priya Verma',
    status: LiveClassStatus.upcoming,
  ),
];

/// Mock assignments/assessments.
const mockAssignments = [
  AssignmentDto(
    id: '1',
    title: 'Problem Set - Differentiation',
    subject: 'Mathematics',
    dueTime: '11:59 PM',
    status: AssignmentStatus.overdue,
    progress: 0,
    description: 'Chapter 5 - Problems 1-20',
  ),
  AssignmentDto(
    id: '2',
    title: 'Thermodynamics Numericals',
    subject: 'Physics',
    dueTime: '6:00 PM',
    status: AssignmentStatus.pending,
    progress: 45,
    description: 'Heat transfer & entropy problems',
  ),
  AssignmentDto(
    id: '3',
    title: 'Organic Reaction Worksheet',
    subject: 'Chemistry',
    dueTime: '9:00 PM',
    status: AssignmentStatus.pending,
    progress: 80,
    description: '25 reactions with mechanisms',
  ),
  AssignmentDto(
    id: '4',
    title: 'Comprehension Exercises',
    subject: 'English',
    dueTime: '11:00 PM',
    status: AssignmentStatus.submitted,
    progress: 100,
    description: 'Reading passages & analysis',
  ),
];

/// Mock tests.
const mockTests = [
  TestDto(
    id: '1',
    title: 'Weekly Mock Test - Physics',
    time: 'Tomorrow, 9:00 AM',
    duration: '3 hours',
    type: TestType.mock,
    isImportant: true,
  ),
  TestDto(
    id: '2',
    title: 'Chapter Test - Organic Chemistry',
    time: 'Jan 5, 2:00 PM',
    duration: '1.5 hours',
    type: TestType.chapter,
  ),
  TestDto(
    id: '3',
    title: 'Calculus Practice Test',
    time: 'Jan 6, 10:00 AM',
    duration: '2 hours',
    type: TestType.practice,
  ),
];

/// Mock study momentum.
final mockStudyMomentum = StudyMomentumDto(
  weekDays: [
    DayActivityDto(
      date: DateTime.now().subtract(const Duration(days: 6)),
      dayLabel: 'M',
      hasActivity: true,
      minutes: 120,
    ),
    DayActivityDto(
      date: DateTime.now().subtract(const Duration(days: 5)),
      dayLabel: 'T',
      hasActivity: true,
      minutes: 90,
    ),
    DayActivityDto(
      date: DateTime.now().subtract(const Duration(days: 4)),
      dayLabel: 'W',
      hasActivity: true,
      minutes: 150,
    ),
    DayActivityDto(
      date: DateTime.now().subtract(const Duration(days: 3)),
      dayLabel: 'T',
      hasActivity: true,
      minutes: 60,
    ),
    DayActivityDto(
      date: DateTime.now().subtract(const Duration(days: 2)),
      dayLabel: 'F',
      hasActivity: true,
      minutes: 210,
    ),
    DayActivityDto(
      date: DateTime.now().subtract(const Duration(days: 1)),
      dayLabel: 'S',
      hasActivity: true,
      minutes: 45,
    ),
    DayActivityDto(
      date: DateTime.now(),
      dayLabel: 'S',
      hasActivity: true,
      minutes: 180,
    ),
  ],
  weeklyHours: 14.5,
  currentStreak: 12,
  latestActivityTitle: 'Completed Calculus Mock Test',
  latestActivityTimeAgo: '1h ago',
  lessonsFinished: 45,
  testsAttempted: 18,
  assessmentsDone: 32,
  strongestSubject: 'Mathematics',
  weakSubject: 'Organic Chemistry',
);
