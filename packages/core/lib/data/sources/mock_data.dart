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
    id: 1,
    name: 'General Discussion',
    slug: 'general-discussion',
  ),
  ForumCategoryDto(id: 2, name: 'Lecture Questions', slug: 'lecture-questions'),
  ForumCategoryDto(id: 3, name: 'Assignment Help', slug: 'assignment-help'),
  ForumCategoryDto(id: 4, name: 'Study Resources', slug: 'study-resources'),
  ForumCategoryDto(id: 5, name: 'Exam Preparation', slug: 'exam-preparation'),
];

ForumCategoryDto? findMockForumCategoryById(int categoryId) {
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

List<ForumThreadDto> mockForumThreads({int page = 1, int? categoryId}) => [
  ForumThreadDto(
    threadId: 1,
    slug: 'integration-substitution-method',
    courseId: 'course-1',
    categoryId: categoryId,
    title: 'How to solve integration using substitution method?',
    summary:
        "I'm having trouble understanding when to use substitution method in integration. Can someone explain with an example? Specifically for problems involving trigonometric functions.",
    authorName: 'Priya Sharma',
    authorAvatar: 'https://ui-avatars.com/api/?name=Priya&format=png',
    createdAt: '2 hours ago',
    replyCount: 3,
    upvotes: 24,
    downvotes: 2,
    status: ForumThreadStatus.answered,
    imageUrl:
        'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&q=80&w=2070',
  ),
  ForumThreadDto(
    threadId: 2,
    slug: 'newtons-third-law-examples',
    courseId: 'course-1',
    categoryId: categoryId,
    title: "Understanding Newton's Third Law with examples",
    summary:
        "Can someone help me understand the practical applications of Newton's Third Law? I'm confused about action-reaction pairs in different scenarios.",
    authorName: 'Amit Patel',
    authorAvatar: 'https://ui-avatars.com/api/?name=Amit&format=png',
    createdAt: '5 hours ago',
    replyCount: 5,
    upvotes: 12,
    downvotes: 1,
    status: ForumThreadStatus.answered,
  ),
  ForumThreadDto(
    threadId: 3,
    slug: 'sn1-vs-sn2-reactions',
    courseId: 'course-1',
    categoryId: categoryId,
    title: 'Organic Chemistry — SN1 vs SN2 reactions',
    summary:
        'What are the key differences between SN1 and SN2 reactions? How do I identify which mechanism will occur in a given reaction?',
    authorName: 'Sneha Gupta',
    authorAvatar: 'https://ui-avatars.com/api/?name=Sneha&format=png',
    createdAt: '1 day ago',
    replyCount: 0,
    upvotes: 8,
    downvotes: 0,
    status: ForumThreadStatus.unanswered,
  ),
  ForumThreadDto(
    threadId: 4,
    slug: 'complex-numbers-geometric-interpretation',
    courseId: 'course-1',
    categoryId: categoryId,
    title: 'Complex numbers — geometric interpretation doubt',
    summary:
        'I need help understanding the geometric interpretation of complex number multiplication. Can someone explain with diagrams?',
    authorName: 'Rahul Singh',
    authorAvatar: 'https://ui-avatars.com/api/?name=Rahul&format=png',
    createdAt: '1 day ago',
    replyCount: 4,
    upvotes: 15,
    downvotes: 3,
    status: ForumThreadStatus.answered,
  ),
  ForumThreadDto(
    threadId: 5,
    slug: 'thermodynamics-entropy-clarification',
    courseId: 'course-1',
    categoryId: categoryId,
    title: 'Thermodynamics — Entropy concept clarification',
    summary:
        'Why does entropy always increase in an isolated system? Can someone provide a simple explanation without too much math?',
    authorName: 'Kavya Reddy',
    authorAvatar: 'https://ui-avatars.com/api/?name=Kavya&format=png',
    createdAt: '2 days ago',
    replyCount: 0,
    upvotes: 5,
    downvotes: 0,
    status: ForumThreadStatus.unanswered,
  ),
];

List<ForumCommentDto> mockForumComments(int threadId) {
  final prefix = 'fc-$threadId';
  return [
    ForumCommentDto(
      id: '$prefix-1',
      threadId: threadId,
      authorName: 'Dr. Rajesh Kumar',
      authorAvatar: 'https://ui-avatars.com/api/?name=Rajesh&format=png',
      content:
          'Great question! The substitution method works best when you can identify an inner function whose derivative also appears in the integral. For trigonometric functions, look for patterns like sin(x)cos(x) where you can substitute u = sin(x). Let me know if you need more specific examples.',
      createdAt: '1 hour 30 minutes ago',
      upvotes: 12,
      isInstructor: true,
    ),
    ForumCommentDto(
      id: '$prefix-2',
      threadId: threadId,
      authorName: 'Amit Verma',
      authorAvatar: 'https://ui-avatars.com/api/?name=Amit&format=png',
      content: 'I had the same doubt! The explanation really helped. Thanks!',
      createdAt: '45 minutes ago',
      upvotes: 3,
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
      coverImage:
          'https://d1j3vi2u94ebt0.cloudfront.net/institute/brilliantpalalms/chapter_contents/192570/7f977cf2e71e4ecba9909788605737a7.png',
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
      coverImage:
          'https://d1j3vi2u94ebt0.cloudfront.net/institute/brilliantpalalms/chapter_contents/363107/047b484129f04324b36ceaf5ebadf348.png',
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
      coverImage:
          'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
      contentType: DashboardContentType.video,
      sectionType: DashboardSectionType.recentlyCompleted,
    ),
    DashboardContentDto(
      id: '7',
      title: 'Genetics',
      chapterTitle: 'Biology Class 12',
      progress: 100,
      totalDuration: '2h 15m',
      coverImage:
          'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
      contentType: DashboardContentType.video,
      sectionType: DashboardSectionType.recentlyCompleted,
    ),
    DashboardContentDto(
      id: '8',
      title: 'Plant Physiology',
      chapterTitle: 'Biology Class 11',
      progress: 100,
      totalDuration: '1h 20m',
      coverImage:
          'https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=500&q=80',
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
    avatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    points: 1520,
    coursesCompleted: 12,
    streakDays: 15,
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
  ),
  LearnerDto(
    id: '4',
    rank: 4,
    name: 'DesignGuru',
    avatar:
        'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200',
    points: 980,
    coursesCompleted: 8,
    streakDays: 8,
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

/// Mock personal doubts
final List<DoubtDto> mockDoubts = [
  DoubtDto(
    id: 'doubt_1',
    topicId: 101,
    topicName: 'Physics',
    title: 'How to solve depreciation question in Accounts?',
    content:
        "I'm having trouble understanding how to calculate depreciation using the reducing balance method. Can someone explain with a simple example?",
    studentName: 'Arjun Sharma',
    replyCount: 3,
    status: DoubtStatus.active,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    createdHumanized: '2 hours ago',
  ),
  DoubtDto(
    id: 'doubt_2',
    topicId: 102,
    topicName: 'Chemistry',
    title: 'What is the difference between ionic and covalent bonding?',
    content: 'Which one is stronger?',
    studentName: 'Arjun Sharma',
    replyCount: 5,
    status: DoubtStatus.active,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    createdHumanized: '4 hours ago',
  ),
  DoubtDto(
    id: 'doubt_3',
    topicId: 103,
    topicName: 'Mathematics',
    title: 'Explain the concept of integration by parts with example',
    content: 'I don\'t understand the ILATE rule.',
    studentName: 'Arjun Sharma',
    replyCount: 0,
    status: DoubtStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    createdHumanized: '6 hours ago',
  ),
  DoubtDto(
    id: 'doubt_4',
    topicId: 104,
    topicName: 'Biology',
    title: 'How does photosynthesis work in C4 plants?',
    content: 'Is it different from C3 plants?',
    studentName: 'Arjun Sharma',
    replyCount: 2,
    status: DoubtStatus.active,
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    createdHumanized: '8 hours ago',
  ),
  DoubtDto(
    id: 'doubt_5',
    topicId: 105,
    topicName: 'Physics',
    title: "What are Newton's Laws of Motion in simple terms?",
    content: 'Can you give real life examples?',
    studentName: 'Arjun Sharma',
    replyCount: 7,
    status: DoubtStatus.active,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    createdHumanized: '1 day ago',
  ),
];

List<DoubtReplyDto> getMockDoubtReplies(String doubtId) {
  if (doubtId == 'doubt_1') {
    return [
      DoubtReplyDto(
        id: 'reply_1_1',
        doubtId: doubtId,
        content:
            'The straight line method is simple: Depreciation = (Cost - Salvage Value) / Useful Life. For example, if a machine costs ₹1,00,000 with a salvage value of ₹10,000 and a life of 10 years, annual depreciation is ₹9,000.',
        authorName: 'Dr. Rajesh Kumar',
        isMentor: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        createdHumanized: '1 hour ago',
      ),
      DoubtReplyDto(
        id: 'reply_1_2',
        doubtId: doubtId,
        content:
            'Got it! So the depreciation amount remains constant every year in this method, right?',
        authorName: 'Arjun Sharma',
        isMentor: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        createdHumanized: '30 minutes ago',
      ),
      DoubtReplyDto(
        id: 'reply_1_3',
        doubtId: doubtId,
        content: 'Exactly! That is why it is called the straight line method.',
        authorName: 'Dr. Rajesh Kumar',
        isMentor: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        createdHumanized: '15 minutes ago',
      ),
    ];
  }

  if (doubtId == 'doubt_2') {
    return [
      DoubtReplyDto(
        id: 'reply_2_1',
        doubtId: doubtId,
        content:
            'Ionic bonding involves the complete transfer of electrons from one atom to another, whereas covalent bonding involves sharing of electron pairs between atoms.',
        authorName: 'Prof. Anjali Sharma',
        isMentor: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      DoubtReplyDto(
        id: 'reply_2_2',
        doubtId: doubtId,
        content:
            'In general, ionic bonds are stronger than covalent bonds due to the strong electrostatic forces between oppositely charged ions.',
        authorName: 'Prof. Anjali Sharma',
        isMentor: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  if (doubtId == 'doubt_4') {
    return [
      DoubtReplyDto(
        id: 'reply_4_1',
        doubtId: doubtId,
        content:
            'Yes, it is very different! C4 plants have a special leaf anatomy called Kranz anatomy to minimize photorespiration, which C3 plants do not have.',
        authorName: 'Dr. Priya Verma',
        isMentor: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  return [];
}

/// Mock Post Categories
const mockPostCategories = [
  PostCategoryDto(
    id: 1,
    name: 'Tips & Tricks',
    order: 1,
    color: '3B82F6', // Blue
    slug: 'tips-tricks',
    isStarred: true,
  ),
  PostCategoryDto(
    id: 2,
    name: 'Updates',
    order: 2,
    color: '10B981', // Green
    slug: 'updates',
    isStarred: false,
  ),
];

/// Mock announcements / posts
const mockPosts = [
  PostDto(
    id: 1,
    slug: 'study-smart-not-hard',
    title: '📚 Study Smart, Not Hard',
    categoryId: 1,
    shortLink: 'smart-study',
    summary:
        'Master complex topics with our structured learning paths - Physics, Chemistry & Math all in one place',
    contentHtml:
        '<p>Master complex topics with our structured learning paths - Physics, Chemistry & Math all in one place</p>',
    publishedDate: '2026-06-01T10:00:00Z',
    allowComments: true,
  ),
  PostDto(
    id: 2,
    slug: 'daily-study-companion',
    title: '🎯 Your Daily Study Companion',
    categoryId: 2,
    shortLink: 'study-companion',
    summary:
        'Track progress across 45+ chapters with video lessons, practice sets, and chapter tests designed by experts',
    contentHtml:
        '<p>Track progress across 45+ chapters with video lessons, practice sets, and chapter tests designed by experts</p>',
    publishedDate: '2026-06-01T09:00:00Z',
    allowComments: true,
  ),
  PostDto(
    id: 3,
    slug: 'learn-at-your-pace',
    title: '⚡ Learn at Your Pace',
    categoryId: 1,
    shortLink: 'learn-pace',
    summary:
        '180+ hours of content available 24/7 - watch recordings, download notes, and practice anytime',
    contentHtml:
        '<p>180+ hours of content available 24/7 - watch recordings, download notes, and practice anytime</p>',
    publishedDate: '2026-06-01T08:00:00Z',
    allowComments: false,
  ),
];

final mockSubjectAnalytics = [
  const SubjectAnalyticsDto(
    id: 1,
    name: 'Biology',
    correct: 4,
    incorrect: 12,
    unanswered: 994,
    total: 1010,
    correctPercentage: 4 / 1010 * 100,
    leaf: false,
  ),
  const SubjectAnalyticsDto(
    id: 2,
    name: 'Botany',
    correct: 13,
    incorrect: 35,
    unanswered: 421,
    total: 469,
    correctPercentage: 13 / 469 * 100,
    leaf: true,
  ),
  const SubjectAnalyticsDto(
    id: 3,
    name: 'Chemistry',
    correct: 124,
    incorrect: 154,
    unanswered: 1699,
    total: 1977,
    correctPercentage: 124 / 1977 * 100,
    leaf: false,
  ),
  const SubjectAnalyticsDto(
    id: 4,
    name: 'Class 10 - Mathematics',
    correct: 12,
    incorrect: 4,
    unanswered: 332,
    total: 348,
    correctPercentage: 12 / 348 * 100,
    leaf: true,
  ),
  const SubjectAnalyticsDto(
    id: 5,
    name: 'Class 6 - Physics',
    correct: 58,
    incorrect: 105,
    unanswered: 1113,
    total: 1276,
    correctPercentage: 58 / 1276 * 100,
    leaf: false,
  ),
  const SubjectAnalyticsDto(
    id: 6,
    name: 'Zoology',
    correct: 2,
    incorrect: 1,
    unanswered: 237,
    total: 240,
    correctPercentage: 2 / 240 * 100,
    leaf: true,
  ),
  const SubjectAnalyticsDto(
    id: 7,
    name: 'Jee Chemistry',
    correct: 17,
    incorrect: 8,
    unanswered: 9,
    total: 34,
    correctPercentage: 17 / 34 * 100,
    parent: 3,
    leaf: true,
  ),
  const SubjectAnalyticsDto(
    id: 8,
    name: 'Jee Adv. Chemistry',
    correct: 0,
    incorrect: 0,
    unanswered: 25,
    total: 25,
    correctPercentage: 0.0,
    parent: 3,
    leaf: true,
  ),
  const SubjectAnalyticsDto(
    id: 9,
    name: 'Neet Chemistry',
    correct: 15,
    incorrect: 39,
    unanswered: 271,
    total: 325,
    correctPercentage: 15 / 325 * 100,
    parent: 3,
    leaf: true,
  ),
  const SubjectAnalyticsDto(
    id: 10,
    name: 'Class 6 Physics',
    correct: 213,
    incorrect: 107,
    unanswered: 680,
    total: 1000,
    correctPercentage: 213 / 1000 * 100,
    parent: 5,
    leaf: true,
  ),
  const SubjectAnalyticsDto(
    id: 11,
    name: 'Class 6 Chemistry',
    correct: 100,
    incorrect: 67,
    unanswered: 833,
    total: 1000,
    correctPercentage: 100 / 1000 * 100,
    parent: 5,
    leaf: true,
  ),
];
