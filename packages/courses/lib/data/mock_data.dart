import 'package:data/data.dart';

/// Mock current user
const mockCurrentUser = UserDto(
  id: 'user_1',
  name: 'Arjun Sharma',
  isPro: true,
);

/// Mock hero banners
const mockHeroBanners = [
  DashboardBannerDto(
    id: "1",
    imageUrl:
        "https://images.unsplash.com/photo-1762438135827-428acc0e8941?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwYWNoaWV2ZW1lbnQlMjBzdWNjZXNzJTIwY2VsZWJyYXRpb258ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "JEE 2025 Results: 95% Selection Rate",
  ),
  DashboardBannerDto(
    id: "2",
    imageUrl:
        "https://images.unsplash.com/photo-1584792264192-dd873d389386?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxlZHVjYXRpb24lMjBhbm5vdW5jZW1lbnQlMjBiYW5uZXJ8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "New Batch Starting: JEE 2027 Foundation",
  ),
  DashboardBannerDto(
    id: "3",
    imageUrl:
        "https://images.unsplash.com/photo-1660795864432-6e63a88bfb40?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxleGFtJTIwcmVzdWx0cyUyMGNlbGVicmF0aW9uJTIwc3R1ZGVudHN8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "Special Merit Scholarship Program",
  ),
];

/// Mock promotional banners (Updates & Announcements)
const mockPromotionBanners = [
  DashboardBannerDto(
    id: '1',
    imageUrl: '',
    title: '📚 Study Smart, Not Hard',
    description:
        'Master complex topics with our structured learning paths - Physics, Chemistry & Math all in one place',
    bgColor: 0xFFEFF6FF,
    textColor: 0xFF1E40AF,
  ),
  DashboardBannerDto(
    id: '2',
    imageUrl: '',
    title: '🎯 Your Daily Study Companion',
    description:
        'Track progress across 45+ chapters with video lessons, practice sets, and chapter tests designed by experts',
    bgColor: 0xFFECFDF5,
    textColor: 0xFF065F46,
  ),
  DashboardBannerDto(
    id: '3',
    imageUrl: '',
    title: '⚡ Learn at Your Pace',
    description:
        '180+ hours of content available 24/7 - watch recordings, download notes, and practice anytime',
    bgColor: 0xFFFAF5FF,
    textColor: 0xFF6B21A8,
  ),
];

/// Mock top learners
const mockTopLearners = [
  LearnerDto(
    id: '1',
    rank: 1,
    name: 'AlexR_21',
    avatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    points: 1520,
    coursesCompleted: 12,
    streakDays: 15,
    badges: [
      LearnerBadgeDto(icon: 'crown', label: 'Monthly Cham', color: 0xFFFBBF24),
      LearnerBadgeDto(icon: 'brain', label: 'Quiz Master', color: 0xFFEC4899),
      LearnerBadgeDto(icon: 'rocket', label: 'Fast Learner', color: 0xFF3B82F6),
      LearnerBadgeDto(icon: 'fire', label: 'Streak King', color: 0xFFF97316),
    ],
  ),
  LearnerDto(
    id: '2',
    rank: 2,
    name: 'LearnWithMira',
    avatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    points: 1340,
    coursesCompleted: 9,
    streakDays: 18,
    badges: [
      LearnerBadgeDto(icon: 'rocket', label: 'Top Designer', color: 0xFFF97316),
      LearnerBadgeDto(icon: 'brain', label: 'Quiz Master', color: 0xFFEC4899),
      LearnerBadgeDto(icon: 'fire', label: 'Streak Star', color: 0xFFF97316),
    ],
  ),
  LearnerDto(
    id: '3',
    rank: 3,
    name: 'CodeNinja_47',
    avatar:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    points: 1180,
    coursesCompleted: 8,
    streakDays: 12,
    badges: [
      LearnerBadgeDto(icon: 'rocket', label: 'Code Master', color: 0xFF3B82F6),
      LearnerBadgeDto(icon: 'brain', label: 'Quiz Pro', color: 0xFFEC4899),
    ],
  ),
];

/// Mock other learners (leaderboard list)
const mockOtherLearners = [
  LearnerDto(
    id: '4',
    rank: 4,
    name: 'DesignGuru',
    avatar:
        'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200',
    points: 980,
    coursesCompleted: 8,
    streakDays: 8,
    badges: [],
  ),
  LearnerDto(
    id: '5',
    rank: 5,
    name: 'MathMaster',
    avatar:
        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
    points: 890,
    coursesCompleted: 7,
    streakDays: 7,
    badges: [],
  ),
  LearnerDto(
    id: '6',
    rank: 6,
    name: 'GrowthHacker',
    avatar:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    points: 832,
    coursesCompleted: 6,
    streakDays: 7,
    badges: [],
  ),
  LearnerDto(
    id: '7',
    rank: 7,
    name: 'DevWizard',
    avatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    points: 791,
    coursesCompleted: 5,
    streakDays: 7,
    badges: [],
  ),
  LearnerDto(
    id: '8',
    rank: 8,
    name: 'You',
    avatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    points: 790,
    coursesCompleted: 4,
    streakDays: 4,
    badges: [],
  ),
  LearnerDto(
    id: '9',
    rank: 9,
    name: 'UIUXExplorer',
    avatar:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    points: 788,
    coursesCompleted: 4,
    streakDays: 6,
    badges: [],
  ),
  LearnerDto(
    id: '10',
    rank: 10,
    name: 'DataDriven',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    points: 765,
    coursesCompleted: 5,
    streakDays: 5,
    badges: [],
  ),
];

/// Mock quick access shortcuts
const mockQuickShortcuts = [
  QuickShortcutDto(
    id: '1',
    label: 'Recordings',
    iconType: ShortcutIconType.video,
  ),
  QuickShortcutDto(
    id: '2',
    label: 'Practice',
    iconType: ShortcutIconType.practice,
  ),
  QuickShortcutDto(id: '3', label: 'Tests', iconType: ShortcutIconType.tests),
  QuickShortcutDto(id: '4', label: 'Notes', iconType: ShortcutIconType.notes),
  QuickShortcutDto(
    id: '5',
    label: 'Ask Doubt',
    iconType: ShortcutIconType.doubts,
  ),
  QuickShortcutDto(
    id: '6',
    label: 'Schedule',
    iconType: ShortcutIconType.schedule,
  ),
];

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
