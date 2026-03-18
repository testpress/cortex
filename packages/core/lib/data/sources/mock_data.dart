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


/// Mock Auth Client that reuses [mockCurrentUser] and updates [SessionStorage].
class MockAuthClient {
  Future<void> login({required String username, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (username == 'error') {
      throw AuthException('Incorrect username or password.');
    }
    SessionStorage.instance.persistSession(authToken: 'mock_token');
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    SessionStorage.instance.persistSession(authToken: 'mock_token');
  }

  Future<UserDto> resolveCurrentUser({bool forceRefresh = false}) async {
    return mockCurrentUser;
  }
}
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
