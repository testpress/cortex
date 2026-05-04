import 'package:core/data/data.dart';

/// Mock current user
var mockCurrentUser = UserDto(
  id: 'user_1',
  name: 'Arjun Sharma',
  firstName: 'Arjun',
  lastName: 'Sharma',
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

/// Mock explore banners.
final mockExploreBanners = [
  const ExploreBannerDto(
    id: '1',
    title: 'Master Data Science in 2025',
    subtitle: 'Complete learning path with projects',
    thumbnail:
        'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
    ctaText: 'Start Learning',
  ),
  const ExploreBannerDto(
    id: '2',
    title: 'AI & Machine Learning',
    subtitle: 'From basics to advanced concepts',
    thumbnail:
        'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800',
    ctaText: 'Start Learning',
  ),
  const ExploreBannerDto(
    id: '3',
    title: 'Communication Skills',
    subtitle: 'Build confidence in public speaking',
    thumbnail:
        'https://images.unsplash.com/photo-1591115765373-5207764f72e7?w=800',
    ctaText: 'Start Learning',
  ),
];

/// Mock study tips.
final mockStudyTips = [
  const StudyTipDto(
    id: '1',
    title: '5 Effective Study Techniques for Exam Success',
    description:
        'Discover proven methods to boost retention and ace your exams',
    thumbnail:
        'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400',
    tag: 'Tips',
    colorIndex: 0,
  ),
  const StudyTipDto(
    id: '2',
    title: 'New Course Added: Advanced Physics',
    description:
        'Comprehensive course covering mechanics, thermodynamics, and more',
    thumbnail:
        'https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=400',
    tag: 'Update',
    colorIndex: 2,
  ),
  const StudyTipDto(
    id: '3',
    title: 'JEE Main 2026 - Important Dates & Tips',
    description: 'Complete guide to preparation timeline and strategy',
    thumbnail:
        'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
    tag: 'Exam',
    colorIndex: 4,
  ),
];

/// Mock short lessons (Most Viewed Videos).
final mockShortLessons = [
  const ShortLessonDto(
    id: '1',
    title: "Newton's Laws of Motion - Full Concept",
    duration: '45 min',
    thumbnail:
        'https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=800',
    author: 'Dr. Rajesh Kumar',
    viewCount: '125k',
    isNew: true,
  ),
  const ShortLessonDto(
    id: '2',
    title: 'Organic Chemistry: Basics of SN1/SN2',
    duration: '38 min',
    thumbnail:
        'https://images.unsplash.com/photo-1603126857599-f6e157fa2fe6?w=800',
    author: 'Prof. Anjali Sharma',
    viewCount: '98k',
  ),
  const ShortLessonDto(
    id: '3',
    title: 'Integration Techniques in 10 Minutes',
    duration: '10 min',
    thumbnail:
        'https://images.unsplash.com/photo-1635372722656-389f87a941b7?w=800',
    author: 'Dr. Vikram Singh',
    viewCount: '210k',
  ),
  const ShortLessonDto(
    id: '4',
    title: 'Cell Biology: Mitosis vs Meiosis',
    duration: '15 min',
    thumbnail:
        'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=800',
    author: 'Dr. Priya Verma',
    viewCount: '156k',
  ),
];


/// Mock discovery courses.
final mockDiscoveryCourses = [
  const DiscoveryCourseDto(
    id: 'exp_1',
    title: 'Python Programming',
    thumbnail:
        'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400',
    duration: '12-week course',
    learnerCount: '2.5k learners',
    price: '₹99',
    badge: 'Best Seller',
    isTrending: true,
  ),
  const DiscoveryCourseDto(
    id: 'exp_2',
    title: 'Web Development',
    thumbnail:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400',
    duration: '16-week course',
    learnerCount: '3.2k learners',
    price: 'Free',
    isTrending: true,
  ),
  const DiscoveryCourseDto(
    id: 'exp_3',
    title: 'Data Structures & Algorithms',
    thumbnail:
        'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=400',
    duration: '10 weeks',
    learnerCount: '2.1k learners',
    price: '₹129',
    badge: 'New',
    isRecommended: true,
  ),
  const DiscoveryCourseDto(
    id: 'exp_4',
    title: 'UI/UX Design Fundamentals',
    thumbnail:
        'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?w=400',
    duration: '6 weeks',
    learnerCount: '1.5k learners',
    price: '₹79',
    isRecommended: true,
  ),
];

const mockForumCategories = [
  ForumCategoryDto(
    id: 'general_discussion',
    name: 'General Discussion',
  ),
  ForumCategoryDto(
    id: 'lecture_questions',
    name: 'Lecture Questions',
  ),
  ForumCategoryDto(
    id: 'assignment_help',
    name: 'Assignment Help',
  ),
  ForumCategoryDto(
    id: 'study_resources',
    name: 'Study Resources',
  ),
  ForumCategoryDto(
    id: 'exam_preparation',
    name: 'Exam Preparation',
  ),
];

ForumCategoryDto? findMockForumCategoryById(String categoryId) {
  for (final category in mockForumCategories) {
    if (category.id == categoryId) {
      return category;
    }
  }
  return null;
}

/// Mock popular tests for Explore.
final mockPopularTests = [
  const PopularTestDto(
    id: 'test-1',
    title: 'JEE Main 2026 Mock Test 1',
    time: '10:00 AM',
    duration: '3h 0m',
    type: PopularTestType.mock,
    isImportant: true,
    thumbnail:
        'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800',
  ),
  const PopularTestDto(
    id: 'test-2',
    title: 'Physics Chapter 1 Practice',
    time: 'Anytime',
    duration: '45m',
    type: PopularTestType.practice,
    thumbnail:
        'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800',
  ),
  const PopularTestDto(
    id: 'test-3',
    title: 'Chemistry Revision Test',
    time: 'Anytime',
    duration: '1h 30m',
    type: PopularTestType.mock,
    thumbnail:
        'https://images.unsplash.com/photo-1603126857599-f6e157fa2fe6?w=800',
  ),
];


List<ForumThreadDto> mockForumThreads(String courseId) => [
      ForumThreadDto(
        id: 'ft-1-$courseId',
        courseId: courseId,
        title: 'How to solve integration using substitution method?',
        description:
            "I'm having trouble understanding when to use substitution method in integration. Can someone explain with an example? Specifically for problems involving trigonometric functions.",
        authorName: 'Priya Sharma',
        authorAvatar: 'https://ui-avatars.com/api/?name=Priya&format=png',
        timeAgo: '2 hours ago',
        replyCount: 3,
        upvotes: 24,
        downvotes: 2,
        status: ForumThreadStatus.answered,
        imageUrl:
            'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&q=80&w=2070',
      ),
      ForumThreadDto(
        id: 'ft-2-$courseId',
        courseId: courseId,
        title: "Understanding Newton's Third Law with examples",
        description:
            "Can someone help me understand the practical applications of Newton's Third Law? I'm confused about action-reaction pairs in different scenarios.",
        authorName: 'Amit Patel',
        authorAvatar: 'https://ui-avatars.com/api/?name=Amit&format=png',
        timeAgo: '5 hours ago',
        replyCount: 5,
        upvotes: 12,
        downvotes: 1,
        status: ForumThreadStatus.answered,
      ),
      ForumThreadDto(
        id: 'ft-3-$courseId',
        courseId: courseId,
        title: 'Organic Chemistry — SN1 vs SN2 reactions',
        description:
            'What are the key differences between SN1 and SN2 reactions? How do I identify which mechanism will occur in a given reaction?',
        authorName: 'Sneha Gupta',
        authorAvatar: 'https://ui-avatars.com/api/?name=Sneha&format=png',
        timeAgo: '1 day ago',
        replyCount: 0,
        upvotes: 8,
        downvotes: 0,
        status: ForumThreadStatus.unanswered,
      ),
      ForumThreadDto(
        id: 'ft-4-$courseId',
        courseId: courseId,
        title: 'Complex numbers — geometric interpretation doubt',
        description:
            'I need help understanding the geometric interpretation of complex number multiplication. Can someone explain with diagrams?',
        authorName: 'Rahul Singh',
        authorAvatar: 'https://ui-avatars.com/api/?name=Rahul&format=png',
        timeAgo: '1 day ago',
        replyCount: 4,
        upvotes: 15,
        downvotes: 3,
        status: ForumThreadStatus.answered,
      ),
      ForumThreadDto(
        id: 'ft-5-$courseId',
        courseId: courseId,
        title: 'Thermodynamics — Entropy concept clarification',
        description:
            'Why does entropy always increase in an isolated system? Can someone provide a simple explanation without too much math?',
        authorName: 'Kavya Reddy',
        authorAvatar: 'https://ui-avatars.com/api/?name=Kavya&format=png',
        timeAgo: '2 days ago',
        replyCount: 0,
        upvotes: 5,
        downvotes: 0,
        status: ForumThreadStatus.unanswered,
      ),
    ];

List<ForumCommentDto> mockForumComments(String threadId) {
  if (threadId.contains('ft-1')) {
    return [
      ForumCommentDto(
        id: 'fc-1-$threadId',
        threadId: threadId,
        authorName: 'Dr. Rajesh Kumar',
        authorAvatar: 'https://ui-avatars.com/api/?name=Rajesh&format=png',
        content:
            'Great question! The substitution method works best when you can identify an inner function whose derivative also appears in the integral. For trigonometric functions, look for patterns like sin(x)cos(x) where you can substitute u = sin(x). Let me know if you need more specific examples.',
        timeAgo: '1 hour 30 minutes ago',
        upvotes: 12,
        isInstructor: true,
      ),
      ForumCommentDto(
        id: 'fc-2-$threadId',
        threadId: threadId,
        authorName: 'Amit Verma',
        authorAvatar: 'https://ui-avatars.com/api/?name=Amit&format=png',
        content: 'I had the same doubt! The explanation really helped. Thanks!',
        timeAgo: '45 minutes ago',
        upvotes: 3,
      ),
    ];
  }

  return [
    ForumCommentDto(
      id: 'fc-1-$threadId',
      threadId: threadId,
      authorName: 'Dr. Anita Sharma',
      authorAvatar: 'https://ui-avatars.com/api/?name=Anita&format=png',
      content:
          'The substitution method is generally best when you see a function and its derivative (or a multiple of it) within the integrand.',
      timeAgo: '1 hour ago',
      upvotes: 8,
    ),
    ForumCommentDto(
      id: 'fc-2-$threadId',
      threadId: threadId,
      authorName: 'Rahul Singh',
      authorAvatar: 'https://ui-avatars.com/api/?name=Rahul&format=png',
      content: 'Can you show an example with tan(x) and sec^2(x)?',
      timeAgo: '45 mins ago',
      upvotes: 2,
    ),
  ];
}

/// Mock learners for leaderboard
const mockWhatsNewFeed = DashboardContentsDto(
  items: [
    DashboardContentDto(
      id: '1',
      title: 'Introduction to Calculus',
      chapterTitle: 'Calculus Basics',
      contentType: DashboardContentType.video,
      sectionType: DashboardSectionType.whatsNew,
      totalDuration: '42 mins',
      coverImage: 'https://placeholder.com/video1.png',
    ),
    DashboardContentDto(
      id: '2',
      title: 'Practice Set 1',
      chapterTitle: 'Calculus Basics',
      contentType: DashboardContentType.test,
      sectionType: DashboardSectionType.whatsNew,
      totalDuration: '45 mins',
      remainingDuration: '',
      coverImage: 'https://placeholder.com/test1.png',
    ),
  ],
);

const mockResumeLearningFeed = DashboardContentsDto(
  items: [
    DashboardContentDto(
      id: '376154',
      title: 'Rectilinear Motion : Part 01',
      chapterTitle: 'Rectilinear Motion',
      contentType: DashboardContentType.video,
      sectionType: DashboardSectionType.resumeLearning,
      totalDuration: '1h 36m',
      remainingDuration: '45m',
      coverImage: 'https://d1j3vi2u94ebt0.cloudfront.net/institute/brilliantpalalms/chapter_contents/192570/7f977cf2e71e4ecba9909788605737a7.png',
      progress: 65.0,
    ),
    DashboardContentDto(
      id: '363107',
      title: 'IISER Previous Year Model - 2025',
      chapterTitle: 'IISER PREVIOUS YEAR MODEL EXAM [ 2017-2025]',
      contentType: DashboardContentType.test,
      sectionType: DashboardSectionType.resumeLearning,
      totalDuration: '3h',
      remainingDuration: '2h 15m',
      coverImage: 'https://d1j3vi2u94ebt0.cloudfront.net/institute/brilliantpalalms/chapter_contents/363107/047b484129f04324b36ceaf5ebadf348.png',
      progress: 0.0,
    ),
  ],
);

const mockRecentlyCompletedFeed = DashboardContentsDto(
  items: [
    DashboardContentDto(
      id: '6',
      title: 'Cell Biology',
      chapterTitle: 'Biology Class 11',
      progress: 100,
      totalDuration: '1h',
      coverImage: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
      contentType: DashboardContentType.video,
      sectionType: DashboardSectionType.recentlyCompleted,
    ),
    DashboardContentDto(
      id: '7',
      title: 'Genetics',
      chapterTitle: 'Biology Class 12',
      progress: 100,
      totalDuration: '2h 15m',
      coverImage: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
      contentType: DashboardContentType.video,
      sectionType: DashboardSectionType.recentlyCompleted,
    ),
    DashboardContentDto(
      id: '8',
      title: 'Plant Physiology',
      chapterTitle: 'Biology Class 11',
      progress: 100,
      totalDuration: '1h 20m',
      coverImage: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
      contentType: DashboardContentType.video,
      sectionType: DashboardSectionType.recentlyCompleted,
    ),
  ],
);

const mockLearners = [
  LearnerDto(
    id: '1',
    rank: 1,
    name: 'AlexR_21',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    points: 1520,
    coursesCompleted: 12,
    streakDays: 15,
  ),
  LearnerDto(
    id: '2',
    rank: 2,
    name: 'LearnWithMira',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    points: 1340,
    coursesCompleted: 9,
    streakDays: 18,
  ),
  LearnerDto(
    id: '3',
    rank: 3,
    name: 'CodeNinja_47',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    points: 1180,
    coursesCompleted: 8,
    streakDays: 12,
  ),
  LearnerDto(
    id: '4',
    rank: 4,
    name: 'DesignGuru',
    avatar: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200',
    points: 980,
    coursesCompleted: 8,
    streakDays: 8,
  ),
  LearnerDto(
    id: '5',
    rank: 5,
    name: 'MathMaster',
    avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
    points: 890,
    coursesCompleted: 7,
    streakDays: 7,
  ),
  LearnerDto(
    id: '6',
    rank: 6,
    name: 'GrowthHacker',
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    points: 832,
    coursesCompleted: 6,
    streakDays: 7,
  ),
  LearnerDto(
    id: '7',
    rank: 7,
    name: 'DevWizard',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    points: 791,
    coursesCompleted: 5,
    streakDays: 7,
  ),
  LearnerDto(
    id: '8',
    rank: 8,
    name: 'You',
    avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    points: 790,
    coursesCompleted: 4,
    streakDays: 4,
  ),
  LearnerDto(
    id: '9',
    rank: 9,
    name: 'UIUXExplorer',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    points: 788,
    coursesCompleted: 4,
    streakDays: 6,
  ),
  LearnerDto(
    id: '10',
    rank: 10,
    name: 'DataDriven',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    points: 765,
    coursesCompleted: 5,
    streakDays: 5,
  ),
];
