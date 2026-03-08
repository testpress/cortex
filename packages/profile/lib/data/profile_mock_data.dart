import 'package:core/core.dart';
import 'package:data/data.dart';

/// Mock recent activity items for the profile screen.
const mockRecentActivity = [
  RecentActivityDto(
    id: '1',
    type: ActivityType.video,
    title: "Newton's Laws of Motion - Advanced Problems",
    timeAgo: '2h ago',
    status: ActivityStatus.inProgress,
    progress: 60,
  ),
  RecentActivityDto(
    id: '2',
    type: ActivityType.test,
    title: 'Organic Chemistry: Reaction Mechanisms Test',
    timeAgo: 'Yesterday',
    status: ActivityStatus.completed,
    score: 85,
  ),
  RecentActivityDto(
    id: '3',
    type: ActivityType.lesson,
    title: 'Calculus: Derivatives and Applications',
    timeAgo: '2 days ago',
    status: ActivityStatus.completed,
  ),
  RecentActivityDto(
    id: '4',
    type: ActivityType.video,
    title: 'Thermodynamics: Heat Transfer Processes',
    timeAgo: '3 days ago',
    status: ActivityStatus.inProgress,
    progress: 35,
  ),
  RecentActivityDto(
    id: '5',
    type: ActivityType.assessment,
    title: 'Weekly Physics Assessment - Wave Motion',
    timeAgo: '4 days ago',
    status: ActivityStatus.completed,
    score: 92,
  ),
];

const mockStudyMomentum = StudyMomentumDto(
  currentStreak: 12,
  weeklyHours: 18.5,
  lessonsFinished: 45,
  testsAttempted: 8,
  assessmentsDone: 15,
  strongestSubject: 'Physics',
  weakSubject: 'Organic Chemistry',
  weekDays: [],
);
