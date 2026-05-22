import 'package:core/data/data.dart';

final List<BookmarkFolderDto> _mockFolders = [
  const BookmarkFolderDto(id: 1, name: 'Physics Notes', bookmarksCount: 2),
  const BookmarkFolderDto(id: 2, name: 'Important Derivations', bookmarksCount: 1),
  const BookmarkFolderDto(id: 3, name: 'NEET Prep', bookmarksCount: 0),
];

final List<BookmarkDto> _mockBookmarks = [
  const BookmarkDto(id: 101, folderId: 1, folderName: 'Physics Notes', lessonId: 1001),
  const BookmarkDto(id: 102, folderId: 1, folderName: 'Physics Notes', lessonId: 1002),
  const BookmarkDto(id: 103, folderId: 2, folderName: 'Important Derivations', lessonId: 1003),
];

/// Static mock data source for development and testing.
/// Implements [DataSource]; no network calls are made.
/// Data is derived from the React reference design.
class MockDataSource implements DataSource {
  const MockDataSource();

  // ─────────────────────────────────────────────────────────────────────────
  // Courses
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<PaginatedResponseDto<CourseDto>> getCourses({
    int page = 1,
    int pageSize = 10,
    String? search,
    dynamic tags,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    var results = _getMockCourses(page);

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      // Concatenate all mock pages for "global" search simulation in mock
      final allCourses = <CourseDto>[
        ..._getMockCourses(1),
        ..._getMockCourses(2),
        ..._getMockCourses(3),
      ];
      results = allCourses
          .where((c) => c.title.toLowerCase().contains(query))
          .toList();

      return PaginatedResponseDto(
        results: results,
        next: null, // Simple mock search doesn't paginate
        count: results.length,
      );
    }

    final next = page < 3
        ? 'https://lmsdemo.testpress.in/api/v3/courses/?page=${page + 1}'
        : null;

    return PaginatedResponseDto(
      results: results,
      next: next,
      count: 15,
    );
  }

  List<CourseDto> _getMockCourses(int page) {
    if (page == 1) {
      return [
        const CourseDto(
          id: 'jee-main-2026',
          title: 'JEE Main 2026',
          colorIndex: 0, // indigo
          chapterCount: 12,
          totalDuration: '180 hrs',
          totalContents: 120,
          progress: 34,
          completedLessons: 28,
          totalLessons: 84,
        ),
        const CourseDto(
          id: 'neet-2026',
          title: 'NEET 2026',
          colorIndex: 4, // rose
          chapterCount: 10,
          totalDuration: '160 hrs',
          totalContents: 110,
          progress: 18,
          completedLessons: 14,
          totalLessons: 76,
        ),
        const CourseDto(
          id: 'jee-advanced-2026',
          title: 'JEE Advanced 2026',
          colorIndex: 3, // violet
          chapterCount: 8,
          totalDuration: '120 hrs',
          totalContents: 80,
          progress: 5,
          completedLessons: 3,
          totalLessons: 60,
        ),
        const CourseDto(
          id: 'biology-neet-2026',
          title: 'NEET Biology Mastery',
          colorIndex: 2, // emerald
          chapterCount: 15,
          totalDuration: '200 hrs',
          totalContents: 150,
          progress: 45,
          completedLessons: 45,
          totalLessons: 100,
        ),
        const CourseDto(
          id: 'english-core-2026',
          title: 'CBSE English Core',
          colorIndex: 5, // pink
          chapterCount: 6,
          totalDuration: '40 hrs',
          totalContents: 40,
          progress: 10,
          completedLessons: 2,
          totalLessons: 20,
        ),
      ];
    } else if (page == 2) {
      return [
        const CourseDto(
          id: 'maths-foundation',
          title: 'Maths Foundation 2025',
          colorIndex: 1,
          chapterCount: 15,
          totalDuration: '100 hrs',
          totalContents: 90,
          progress: 0,
          completedLessons: 0,
          totalLessons: 50,
        ),
        const CourseDto(
          id: 'physics-mastery',
          title: 'Physics Mastery 2025',
          colorIndex: 6,
          chapterCount: 20,
          totalDuration: '150 hrs',
          totalContents: 130,
          progress: 12,
          completedLessons: 10,
          totalLessons: 80,
        ),
      ];
    } else if (page == 3) {
      return [
        const CourseDto(
          id: 'chemistry-revision',
          title: 'Chemistry Quick Revision',
          colorIndex: 7,
          chapterCount: 5,
          totalDuration: '20 hrs',
          totalContents: 25,
          progress: 100,
          completedLessons: 20,
          totalLessons: 20,
        ),
      ];
    }
    return [];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Chapters
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<CourseDto> getCourseDetail(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = [..._getMockCourses(1), ..._getMockCourses(2), ..._getMockCourses(3)];
    return all.firstWhere(
      (c) => c.id == courseId,
      orElse: () => all.first,
    );
  }

  @override
  Future<List<ChapterDto>> getChapters(String courseId, {String? parentId}) async {
    switch (courseId) {
      case 'jee-main-2026':
        return _jeeMainChapters();
      case 'neet-2026':
        return _neetChapters();
      case 'jee-advanced-2026':
        return _jeeAdvancedChapters();
      case 'biology-neet-2026':
        return _biologyChapters();
      case 'english-core-2026':
        return _englishChapters();
      default:
        return [];
    }
  }

  @override
  Stream<CourseCurriculumDto> getCourseContents(String courseId, {String? chapterId, String? type}) async* {
    // Collect chapters in the course/chapter branch.
    // In mock, we simulate recursion starting from the parentId if provided.
    final allChapters = await _getAllChaptersRecursively(courseId, parentId: chapterId);

    final lessons = <LessonDto>[];
    for (var ch in allChapters) {
      lessons.addAll(await getLessons(ch.id));
    }
    yield CourseCurriculumDto(chapters: allChapters, lessons: lessons);
  }

  Future<List<ChapterDto>> _getAllChaptersRecursively(String courseId, {String? parentId}) async {
    final List<ChapterDto> result = [];
    final chapters = await getChapters(courseId, parentId: parentId);
    
    for (final chapter in chapters) {
      result.add(chapter);
      if (!chapter.isLeaf) {
        result.addAll(await _getAllChaptersRecursively(courseId, parentId: chapter.id));
      }
    }
    return result;
  }

  @override
  Future<CourseCurriculumDto> getRunningContents(String courseId, {String? chapterId}) async {
    final all = await getCourseContents(courseId).first;
    return all.copyWith(
      lessons: all.lessons.where((l) => l.progressStatus == LessonProgressStatus.inProgress).toList(),
    );
  }

  @override
  Future<CourseCurriculumDto> getUpcomingContents(String courseId, {String? chapterId}) async {
    final all = await getCourseContents(courseId).first;
    return all.copyWith(
      lessons: all.lessons.where((l) => l.progressStatus == LessonProgressStatus.notStarted).toList(),
    );
  }

  @override
  Future<CourseCurriculumDto> getContentAttempts(String courseId, {String? chapterId}) async {
    final all = await getCourseContents(courseId).first;
    return all.copyWith(
      lessons: all.lessons.where((l) => l.progressStatus == LessonProgressStatus.completed).toList(),
    );
  }

  List<ChapterDto> _jeeMainChapters() => [
        const ChapterDto(
          id: 'jee-main-ch-1',
          courseId: 'jee-main-2026',
          title: 'Physics Foundations',
          isLeaf: false,
          lessonCount: 0,
          assessmentCount: 0,
          orderIndex: 0,
        ),
        const ChapterDto(
          id: 'jee-main-ch-1-sub-1',
          parentId: 'jee-main-ch-1',
          courseId: 'jee-main-2026',
          title: 'Thermodynamics & Heat',
          lessonCount: 6,
          assessmentCount: 1,
          orderIndex: 0,
        ),
        const ChapterDto(
          id: 'jee-main-ch-2',
          courseId: 'jee-main-2026',
          title: 'Mechanics — Laws of Motion',
          lessonCount: 5,
          assessmentCount: 1,
          orderIndex: 1,
        ),
        const ChapterDto(
          id: 'jee-main-ch-3',
          courseId: 'jee-main-2026',
          title: 'Electrostatics',
          lessonCount: 7,
          assessmentCount: 1,
          orderIndex: 2,
        ),
      ];

  List<ChapterDto> _neetChapters() => [
        const ChapterDto(
          id: 'neet-ch-1',
          courseId: 'neet-2026',
          title: 'Cell Biology & Genetics',
          lessonCount: 7,
          assessmentCount: 1,
          orderIndex: 0,
        ),
        const ChapterDto(
          id: 'neet-ch-2',
          courseId: 'neet-2026',
          title: 'Human Physiology',
          lessonCount: 9,
          assessmentCount: 2,
          orderIndex: 1,
        ),
        const ChapterDto(
          id: 'neet-ch-3',
          courseId: 'neet-2026',
          title: 'Organic Chemistry for NEET',
          lessonCount: 6,
          assessmentCount: 1,
          orderIndex: 2,
        ),
        const ChapterDto(
          id: 'neet-ch-4',
          courseId: 'neet-2026',
          title: 'Modern Physics',
          lessonCount: 5,
          assessmentCount: 1,
          orderIndex: 3,
        ),
        const ChapterDto(
          id: 'neet-ch-5',
          courseId: 'neet-2026',
          title: 'Ecology & Biodiversity',
          lessonCount: 4,
          assessmentCount: 1,
          orderIndex: 4,
        ),
      ];

  List<ChapterDto> _jeeAdvancedChapters() => [
        const ChapterDto(
          id: 'jee-adv-ch-1',
          courseId: 'jee-advanced-2026',
          title: 'Waves & Oscillations',
          lessonCount: 5,
          assessmentCount: 1,
          orderIndex: 0,
        ),
        const ChapterDto(
          id: 'jee-adv-ch-2',
          courseId: 'jee-advanced-2026',
          title: 'Coordinate Geometry',
          lessonCount: 6,
          assessmentCount: 1,
          orderIndex: 1,
        ),
        const ChapterDto(
          id: 'jee-adv-ch-3',
          courseId: 'jee-advanced-2026',
          title: 'Chemical Bonding',
          lessonCount: 4,
          assessmentCount: 1,
          orderIndex: 2,
        ),
        const ChapterDto(
          id: 'jee-adv-ch-4',
          courseId: 'jee-advanced-2026',
          title: 'Vectors & 3D Geometry',
          lessonCount: 5,
          assessmentCount: 1,
          orderIndex: 3,
        ),
        const ChapterDto(
          id: 'jee-adv-ch-5',
          courseId: 'jee-advanced-2026',
          title: 'Rotational Mechanics',
          lessonCount: 5,
          assessmentCount: 1,
          orderIndex: 4,
        ),
      ];

  List<ChapterDto> _biologyChapters() => [
        const ChapterDto(
          id: 'bio-ch-1',
          courseId: 'biology-neet-2026',
          title: 'Plant Kingdom',
          lessonCount: 8,
          assessmentCount: 2,
          orderIndex: 0,
        ),
        const ChapterDto(
          id: 'bio-ch-2',
          courseId: 'biology-neet-2026',
          title: 'Animal Kingdom',
          lessonCount: 10,
          assessmentCount: 2,
          orderIndex: 1,
        ),
      ];

  List<ChapterDto> _englishChapters() => [
        const ChapterDto(
          id: 'eng-ch-1',
          courseId: 'english-core-2026',
          title: 'Reading Comprehension',
          lessonCount: 5,
          assessmentCount: 1,
          orderIndex: 0,
        ),
        const ChapterDto(
          id: 'eng-ch-2',
          courseId: 'english-core-2026',
          title: 'Creative Writing Skills',
          lessonCount: 7,
          assessmentCount: 2,
          orderIndex: 1,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // Lessons
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<LessonDto>> getLessons(String chapterId) async {
    switch (chapterId) {
      case 'jee-main-ch-1-sub-1':
        return _thermodynamicsLessons();
      case 'jee-main-ch-2':
        return _mechanicsLessons();
      case 'jee-main-ch-3':
        return _electrostaticsLessons();
      case 'jee-main-ch-5':
        return _calculusLessons();
      default:
        return _genericLessons(chapterId);
    }
  }

  @override
  Future<LessonDto> getLessonDetail(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _thermodynamicsLessons().firstWhere(
      (l) => l.id == lessonId,
      orElse: () => _thermodynamicsLessons().first.copyWith(id: lessonId),
    );
  }

  List<LessonDto> _thermodynamicsLessons() => [
        const LessonDto(
          id: 'thermo-1',
          chapterId: 'jee-main-ch-1',
          title: 'Introduction to Thermodynamics',
          subtitle:
              'Understanding the fundamental principles that govern energy transfer and conservation in physical systems',
          type: LessonType.pdf,
          duration: '30 min read',
          progressStatus: LessonProgressStatus.completed,
          isLocked: false,
          orderIndex: 0,
          subjectName: 'Physics',
          subjectIndex: 3, // violet
          lessonNumber: 1,
          totalLessons: 8,
          contentUrl: 'https://drive.google.com/uc?export=download&id=1QxJ4yF2LdlCVSll4NkTXj5bO-nL6Xzol',
        ),
        const LessonDto(
          id: 'thermo-2',
          chapterId: 'jee-main-ch-1',
          title: 'First Law of Thermodynamics',
          subtitle:
              'Understanding the fundamental principles of the first law of thermodynamics, internal energy, and their applications in various systems.',
          type: LessonType.video,
          duration: '38 min',
          progressStatus: LessonProgressStatus.inProgress,
          isLocked: false,
          orderIndex: 1,
          subjectName: 'Physics',
          subjectIndex: 3,
          lessonNumber: 2,
          totalLessons: 8,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        const LessonDto(
          id: 'thermo-3',
          chapterId: 'jee-main-ch-1',
          title: 'Practice Problems — First Law',
          subtitle:
              'Test your understanding of the First Law of Thermodynamics with these curated practice problems',
          type: LessonType.pdf,
          duration: '20 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 2,
          subjectName: 'Physics',
          subjectIndex: 3,
          lessonNumber: 3,
          totalLessons: 8,
        ),
        const LessonDto(
          id: 'thermo-4',
          chapterId: 'jee-main-ch-1',
          title: 'Second Law & Entropy',
          type: LessonType.video,
          duration: '42 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 3,
        ),
        const LessonDto(
          id: 'thermo-5',
          chapterId: 'jee-main-ch-1',
          title: 'Heat Engines & Efficiency',
          type: LessonType.assessment,
          duration: '30 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 4,
        ),
        const LessonDto(
          id: 'thermo-6',
          chapterId: 'jee-main-ch-1',
          title: 'Thermodynamics Chapter Test',
          type: LessonType.test,
          duration: '60 min',
          progressStatus: LessonProgressStatus.notStarted,
          attemptsUrl: 'https://demo.testpress.in/api/v3/exams/thermodynamics-chapter-test/attempts/',
          isLocked: true,
          orderIndex: 5,
        ),
      ];

  List<LessonDto> _mechanicsLessons() => [
        const LessonDto(
          id: 'mech-1',
          chapterId: 'jee-main-ch-2',
          title: "Newton's Laws Overview",
          type: LessonType.video,
          duration: '40 min',
          progressStatus: LessonProgressStatus.completed,
          isLocked: false,
          orderIndex: 0,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        const LessonDto(
          id: 'mech-2',
          chapterId: 'jee-main-ch-2',
          title: 'Free Body Diagrams',
          type: LessonType.pdf,
          duration: '25 min',
          progressStatus: LessonProgressStatus.completed,
          isLocked: false,
          orderIndex: 1,
          contentUrl: 'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
        ),
        const LessonDto(
          id: 'mech-3',
          chapterId: 'jee-main-ch-2',
          title: 'Friction & Normal Force',
          type: LessonType.video,
          duration: '35 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 2,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        const LessonDto(
          id: 'mech-4',
          chapterId: 'jee-main-ch-2',
          title: 'Practice: Laws of Motion',
          type: LessonType.assessment,
          duration: '25 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 3,
        ),
        const LessonDto(
          id: 'mech-5',
          chapterId: 'jee-main-ch-2',
          title: 'Mechanics Chapter Test',
          type: LessonType.test,
          duration: '45 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 4,
        ),
      ];

  List<LessonDto> _electrostaticsLessons() => [
        const LessonDto(
          id: 'elec-1',
          chapterId: 'jee-main-ch-3',
          title: "Coulomb's Law",
          type: LessonType.video,
          duration: '38 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 0,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        const LessonDto(
          id: 'elec-2',
          chapterId: 'jee-main-ch-3',
          title: 'Electric Field & Potential',
          type: LessonType.video,
          duration: '44 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 1,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        const LessonDto(
          id: 'elec-3',
          chapterId: 'jee-main-ch-3',
          title: 'Gauss Law',
          type: LessonType.video,
          duration: '42 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 2,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        const LessonDto(
          id: 'elec-4',
          chapterId: 'jee-main-ch-3',
          title: 'Electrostatics Notes PDF',
          type: LessonType.pdf,
          duration: '15 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 3,
          contentUrl: 'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
        ),
        const LessonDto(
          id: 'elec-5',
          chapterId: 'jee-main-ch-3',
          title: 'Electrostatics Practice Test',
          type: LessonType.test,
          duration: '60 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 4,
        ),
      ];


  List<LessonDto> _calculusLessons() => [
        const LessonDto(
          id: 'calc-1',
          chapterId: 'jee-main-ch-5',
          title: 'Integration by Substitution',
          type: LessonType.video,
          duration: '40 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 0,
        ),
        const LessonDto(
          id: 'calc-2',
          chapterId: 'jee-main-ch-5',
          title: 'Integration by Parts',
          type: LessonType.video,
          duration: '42 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 1,
        ),
        const LessonDto(
          id: 'calc-3',
          chapterId: 'jee-main-ch-5',
          title: 'Definite Integrals',
          type: LessonType.video,
          duration: '35 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 2,
        ),
        const LessonDto(
          id: 'calc-4',
          chapterId: 'jee-main-ch-5',
          title: 'Practice Problems PDF',
          type: LessonType.pdf,
          duration: '20 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 3,
        ),
        const LessonDto(
          id: 'calc-5',
          chapterId: 'jee-main-ch-5',
          title: 'Calculus Integration Test',
          type: LessonType.test,
          duration: '60 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 4,
        ),
      ];

  /// Generic lessons for other chapters not explicitly mapped.
  List<LessonDto> _genericLessons(String chapterId) => [
        LessonDto(
          id: '$chapterId-l1',
          chapterId: chapterId,
          title: 'Introduction',
          subtitle:
              'An introductory overview of the core concepts in this lesson.',
          type: LessonType.video,
          duration: '40 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 0,
          lessonNumber: 1,
          totalLessons: 5,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        LessonDto(
          id: '$chapterId-l2',
          chapterId: chapterId,
          title: 'Core Concepts',
          subtitle:
              'Deep dive into the fundamental theories and practical applications.',
          type: LessonType.video,
          duration: '45 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 1,
          lessonNumber: 2,
          totalLessons: 5,
          contentUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        LessonDto(
          id: '$chapterId-l3',
          chapterId: chapterId,
          title: 'Notes PDF',
          type: LessonType.pdf,
          duration: '15 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 2,
          contentUrl: 'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
        ),
        LessonDto(
          id: '$chapterId-l4',
          chapterId: chapterId,
          title: 'Chapter Assessment',
          type: LessonType.assessment,
          duration: '30 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 3,
        ),
        LessonDto(
          id: '$chapterId-l5',
          chapterId: chapterId,
          title: 'Chapter Test',
          type: LessonType.test,
          duration: '60 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 4,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // Live Classes
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<LiveClassDto>> getLiveClasses() async => const [
        LiveClassDto(
          id: 'lc-1',
          subject: 'Physics — Thermodynamics',
          topic: 'Laws of Thermodynamics & Heat Engines',
          time: '10:00 AM – 12:00 PM',
          faculty: 'Prof. Anita Sharma',
          status: LiveClassStatus.completed,
        ),
        LiveClassDto(
          id: 'lc-2',
          subject: 'Chemistry — Organic Chemistry',
          topic: 'Reaction Mechanisms',
          time: '3:00 PM – 5:00 PM',
          faculty: 'Dr. Rajesh Kumar',
          status: LiveClassStatus.live,
        ),
        LiveClassDto(
          id: 'lc-3',
          subject: 'Mathematics — Calculus II',
          topic: 'Integration Techniques',
          time: '5:30 PM – 7:30 PM',
          faculty: 'Dr. Vikram Singh',
          status: LiveClassStatus.upcoming,
        ),
        LiveClassDto(
          id: 'lc-4',
          subject: 'English — Communication Skills',
          topic: 'Essay Writing & Comprehension',
          time: '8:00 PM – 9:00 PM',
          faculty: 'Ms. Priya Verma',
          status: LiveClassStatus.upcoming,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // Forum Threads
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<ForumThreadDto>> getForumThreads(String courseId) async =>
      mockForumThreads(courseId);

  @override
  Future<List<ForumCategoryDto>> getForumCategories(String courseId) async =>
      mockForumCategories;

  @override
  Future<List<ForumCommentDto>> getForumComments(String threadId) async =>
      mockForumComments(threadId);

  // ─────────────────────────────────────────────────────────────────────────
  // User Progress
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) async => [
        UserProgressDto(
          userId: userId,
          lessonId: 'thermo-1',
          courseId: 'jee-main-2026',
          percentComplete: 100,
          lastAccessedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        UserProgressDto(
          userId: userId,
          lessonId: 'thermo-2',
          courseId: 'jee-main-2026',
          percentComplete: 67,
          lastAccessedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        UserProgressDto(
          userId: userId,
          lessonId: 'mech-1',
          courseId: 'jee-main-2026',
          percentComplete: 100,
          lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        UserProgressDto(
          userId: userId,
          lessonId: 'mech-2',
          courseId: 'jee-main-2026',
          percentComplete: 100,
          lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // Explore
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<ExploreBannerDto>> getExploreBanners() async =>
      mockExploreBanners;

  @override
  Future<List<StudyTipDto>> getStudyTips() async => mockStudyTips;

  @override
  Future<List<ShortLessonDto>> getShortLessons() async => mockShortLessons;

  @override
  Future<List<DiscoveryCourseDto>> getDiscoveryCourses() async =>
      mockDiscoveryCourses;

  @override
  Future<List<PopularTestDto>> getPopularTests() async => mockPopularTests;

  @override
  Future<List<DashboardBannerDto>> getDashboardBanners() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      const DashboardBannerDto(
        id: "1",
        imageUrl:
            "https://images.unsplash.com/photo-1762438135827-428acc0e8941?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwYWNoaWV2ZW1lbnQlMjBzdWNjZXNzJTIwY2VsZWJyYXRpb258ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
        title: "JEE 2025 Results: 95% Selection Rate",
      ),
      const DashboardBannerDto(
        id: "2",
        imageUrl:
            "https://images.unsplash.com/photo-1584792264192-dd873d389386?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxlZHVjYXRpb24lMjBhbm5vdW5jZW1lbnQlMjBiYW5uZXJ8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
        title: "New Batch Starting: JEE 2027 Foundation",
      ),
      const DashboardBannerDto(
        id: "3",
        imageUrl:
            "https://images.unsplash.com/photo-1660795864432-6e63a88bfb40?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxleGFtJTIwcmVzdWx0cyUyMGNlbGVicmF0aW9uJTIwc3R1ZGVudHN8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
        title: "Special Merit Scholarship Program",
      ),
    ];
  }

  @override
  Future<List<LearnerDto>> fetchLeaderboard({
    required LeaderboardTimeline timeline,
    int limit = 10,
    int page = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockLearners;
  }

  @override
  Future<DashboardContentsDto> getWhatsNewFeed(DashboardSectionType sectionType) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockWhatsNewFeed;
  }

  @override
  Future<DashboardContentsDto> getResumeLearningFeed(DashboardSectionType sectionType) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockResumeLearningFeed;
  }

  @override
  Future<DashboardContentsDto> getRecentlyCompletedFeed(DashboardSectionType sectionType) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockRecentlyCompletedFeed;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // User Profile
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<UserDto> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockCurrentUser;
  }

  @override
  Future<UserDto> updateProfile(
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = mockCurrentUser.copyWith(
      name: data['display_name'] as String? ?? mockCurrentUser.name,
      firstName: data['first_name'] as String? ?? mockCurrentUser.firstName,
      lastName: data['last_name'] as String? ?? mockCurrentUser.lastName,
      phone: data['phone'] as String? ?? mockCurrentUser.phone,
    );
    mockCurrentUser = updated;
    return updated;
  }

  @override
  Future<void> markLessonCompleted(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // --- Exam Attendance ---

  @override
  Future<ExamDto> getExam(String slug) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const ExamDto(
      id: 'mock-exam-1',
      slug: 'mock-exam-slug',
      title: 'JEE Main Physics Mock Test',
      duration: '01:00:00',
      questionCount: 30,
      hasInstructions: true,
      attemptsUrl: 'https://api.testpress.in/api/v2.2.1/exams/mock-exam-slug/attempts/',
      state: 'Available',
    );
  }

  @override
  Future<List<AttemptDto>> getAttempts(String attemptsUrl) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AttemptDto(
        id: 'mock-attempt-1',
        questionsUrl: 'https://api.testpress.in/api/v2.2.1/attempts/mock-attempt-1/questions/',
        heartbeatUrl: 'https://api.testpress.in/api/v2.2.1/attempts/mock-attempt-1/heartbeat/',
        endUrl: 'https://api.testpress.in/api/v2.2.1/attempts/mock-attempt-1/end/',
        date: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        score: '45.0',
        correctCount: 15,
        incorrectCount: 5,
        totalQuestions: 30,
      )
    ];
  }

  @override
  Future<AttemptDto> createAttempt(String attemptsUrl) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const AttemptDto(
      id: 'mock-attempt-1',
      questionsUrl: 'https://api.testpress.in/api/v2.2.1/attempts/mock-attempt-1/questions/',
      heartbeatUrl: 'https://api.testpress.in/api/v2.2.1/attempts/mock-attempt-1/heartbeat/',
      endUrl: 'https://api.testpress.in/api/v2.2.1/attempts/mock-attempt-1/end/',
    );
  }

  @override
  Future<AttemptDto> createContentAttempt(String contentAttemptsUrl) async {
    return createAttempt(contentAttemptsUrl);
  }

  @override
  Future<AttemptDto> startAttempt(String startUrl) async {
    return createAttempt(startUrl);
  }

  @override
  Future<List<QuestionDto>> getQuestions(String questionsUrl) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return const [
      QuestionDto(
        id: 'q1',
        text: 'What is the SI unit of force?',
        type: 'singleSelect',
        answerUrl: 'https://api.testpress.in/api/v2.2.1/questions/q1/answer/',
        options: [
          QuestionOptionDto(id: 'o1', text: 'Newton'),
          QuestionOptionDto(id: 'o2', text: 'Joule'),
          QuestionOptionDto(id: 'o3', text: 'Watt'),
          QuestionOptionDto(id: 'o4', text: 'Pascal'),
        ],
      ),
      QuestionDto(
        id: 'q2',
        text: 'Which of the following are vector quantities?',
        type: 'multipleSelect',
        answerUrl: 'https://api.testpress.in/api/v2.2.1/questions/q2/answer/',
        options: [
          QuestionOptionDto(id: 'o21', text: 'Velocity'),
          QuestionOptionDto(id: 'o22', text: 'Speed'),
          QuestionOptionDto(id: 'o23', text: 'Acceleration'),
          QuestionOptionDto(id: 'o24', text: 'Mass'),
        ],
      ),
    ];
  }

  @override
  Future<void> submitAnswer(String answerUrl, AnswerDto answer) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<AttemptDto> sendHeartbeat(String heartbeatUrl) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const AttemptDto(
      id: 'mock-attempt-1',
      questionsUrl: '',
      heartbeatUrl: '',
      endUrl: '',
      remainingTime: '00:59:30',
    );
  }

  @override
  Future<AttemptDto> endExam(String endUrl) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const AttemptDto(
      id: 'mock-attempt-1',
      questionsUrl: '',
      heartbeatUrl: '',
      endUrl: '',
      score: '45/100',
    );
  }

  @override
  Future<SectionDto> startSection(String startUrl) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const SectionDto(
      id: 'mock-section-1',
      name: 'Physics',
      state: 'Running',
      questionsUrl: '',
      order: 0,
    );
  }

  @override
  Future<SectionDto> endSection(String endUrl) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const SectionDto(
      id: 'mock-section-1',
      name: 'Physics',
      state: 'Completed',
      questionsUrl: '',
      order: 0,
    );
  }

  @override
  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const ReviewItemDto(
        id: 'ri1',
        index: 1,
        selectedAnswers: [1],
        result: 'Correct',
        marks: '4',
        duration: '00:00:45',
        correctPercentage: 72,
        question: ReviewQuestionDto(
          id: 1,
          questionHtml: '<p>What is the SI unit of Force?</p>',
          explanationHtml: '<p>The SI unit of Force is the Newton (N), named after Sir Isaac Newton.</p>',
          type: 'R',
          answers: [
            ReviewAnswerDto(id: 1, textHtml: 'Newton', isCorrect: true),
            ReviewAnswerDto(id: 2, textHtml: 'Joule', isCorrect: false),
            ReviewAnswerDto(id: 3, textHtml: 'Watt', isCorrect: false),
            ReviewAnswerDto(id: 4, textHtml: 'Pascal', isCorrect: false),
          ],
        ),
      ),
      const ReviewItemDto(
        id: 'ri2',
        index: 2,
        selectedAnswers: [21, 23],
        result: 'Correct',
        marks: '4',
        duration: '00:01:10',
        correctPercentage: 48,
        question: ReviewQuestionDto(
          id: 2,
          questionHtml: '<p>Which of the following are vector quantities?</p>',
          explanationHtml: '<p>Velocity and Acceleration have both magnitude and direction, making them vectors.</p>',
          type: 'C',
          answers: [
            ReviewAnswerDto(id: 21, textHtml: 'Velocity', isCorrect: true),
            ReviewAnswerDto(id: 22, textHtml: 'Speed', isCorrect: false),
            ReviewAnswerDto(id: 23, textHtml: 'Acceleration', isCorrect: true),
            ReviewAnswerDto(id: 24, textHtml: 'Mass', isCorrect: false),
          ],
        ),
      ),
    ];
  }

  @override
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(String analyticsUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      SubjectAnalyticsDto(
        id: 101,
        name: 'Physics',
        total: 10,
        correct: 6,
        incorrect: 3,
        unanswered: 1,
        correctPercentage: 60.0,
      ),
      SubjectAnalyticsDto(
        id: 102,
        name: 'Chemistry',
        total: 10,
        correct: 8,
        incorrect: 1,
        unanswered: 1,
        correctPercentage: 80.0,
      ),
    ];
  }

  @override
  Future<void> downloadFile({
    required String url,
    required String savePath,
    void Function(int count, int total)? onReceiveProgress,
    dynamic cancelToken,
    bool requireAuth = true,
  }) async {
    // Mock implementation for testing
    await Future.delayed(const Duration(seconds: 1));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Doubts
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<DoubtDto>> getDoubts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockDoubts;
  }

  @override
  Future<List<DoubtReplyDto>> getDoubtReplies(String doubtId) async {

    return getMockDoubtReplies(doubtId);
  }

  @override
  Future<List<BookmarkFolderDto>> getBookmarkFolders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockFolders;
  }

  @override
  Future<BookmarkFolderDto> createBookmarkFolder(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newFolder = BookmarkFolderDto(
      id: _mockFolders.length + 1,
      name: name,
      bookmarksCount: 0,
    );
    _mockFolders.add(newFolder);
    return newFolder;
  }

  @override
  Future<BookmarkDto> createBookmark({
    required String category,
    required int lessonId,
    String? folder,
    String? bookmarkType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    int? folderId;
    String? folderName;
    if (folder != null && folder.isNotEmpty) {
      final match = _mockFolders.firstWhere(
        (f) => f.name == folder,
        orElse: () {
          final newFolder = BookmarkFolderDto(
            id: _mockFolders.length + 1,
            name: folder,
            bookmarksCount: 0,
          );
          _mockFolders.add(newFolder);
          return newFolder;
        },
      );
      folderId = match.id;
      folderName = match.name;
    }

    final newBookmark = BookmarkDto(
      id: _mockBookmarks.length + 101,
      folderId: folderId,
      folderName: folderName,
      lessonId: lessonId,
      bookmarkType: bookmarkType,
    );
    
    final existingIndex = _mockBookmarks.indexWhere(
      (b) => b.lessonId == lessonId && b.folderId == folderId,
    );
    if (existingIndex != -1) {
      return _mockBookmarks[existingIndex];
    }
    
    _mockBookmarks.add(newBookmark);
    
    if (folderId != null) {
      final index = _mockFolders.indexWhere((f) => f.id == folderId);
      if (index != -1) {
        _mockFolders[index] = _mockFolders[index].copyWith(
          bookmarksCount: _mockFolders[index].bookmarksCount + 1,
        );
      }
    }
    
    return newBookmark;
  }

  @override
  Future<void> deleteBookmark(String bookmarkId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idInt = int.tryParse(bookmarkId);
    if (idInt == null) return;
    
    final index = _mockBookmarks.indexWhere((b) => b.id == idInt);
    if (index != -1) {
      final bookmark = _mockBookmarks[index];
      _mockBookmarks.removeAt(index);
      
      if (bookmark.folderId != null) {
        final fIndex = _mockFolders.indexWhere((f) => f.id == bookmark.folderId);
        if (fIndex != -1) {
          _mockFolders[fIndex] = _mockFolders[fIndex].copyWith(
            bookmarksCount: (_mockFolders[fIndex].bookmarksCount - 1).clamp(0, 999999),
          );
        }
      }
    }
  }
}
