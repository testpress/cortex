import 'dart:io';
import 'package:core/data/data.dart';

final List<BookmarkFolderDto> _mockFolders = [
  const BookmarkFolderDto(id: 1, name: 'Physics Notes', bookmarksCount: 2),
  const BookmarkFolderDto(
    id: 2,
    name: 'Important Derivations',
    bookmarksCount: 1,
  ),
  const BookmarkFolderDto(id: 3, name: 'NEET Prep', bookmarksCount: 0),
];

final List<BookmarkDto> _mockBookmarks = [
  const BookmarkDto(
    id: 101,
    folderId: 1,
    folderName: 'Physics Notes',
    lessonId: 1001,
  ),
  const BookmarkDto(
    id: 102,
    folderId: 1,
    folderName: 'Physics Notes',
    lessonId: 1002,
  ),
  const BookmarkDto(
    id: 103,
    folderId: 2,
    folderName: 'Important Derivations',
    lessonId: 1003,
  ),
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
    bool? allowCustomTest,
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

    return PaginatedResponseDto(results: results, next: next, count: 15);
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
          progress: 34.0,
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
          progress: 18.0,
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
          progress: 5.0,
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
          progress: 45.0,
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
          progress: 10.0,
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
          progress: 0.0,
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
          progress: 12.0,
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
          progress: 100.0,
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
    final all = [
      ..._getMockCourses(1),
      ..._getMockCourses(2),
      ..._getMockCourses(3),
    ];
    return all.firstWhere((c) => c.id == courseId, orElse: () => all.first);
  }

  @override
  Future<List<ChapterDto>> getChapters(
    String courseId, {
    String? parentId,
  }) async {
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
  Future<ChapterDto> getChapterDetail(String slug) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const ChapterDto(
      id: '999',
      title: 'Mock Chapter Detail',
      courseId: 'mock-course',
      orderIndex: 1,
      lessonCount: 0,
      assessmentCount: 0,
      isLeaf: true,
    );
  }

  @override
  Stream<CourseCurriculumDto> getCourseContents(
    String courseId, {
    String? chapterId,
    String? type,
  }) async* {
    // Collect chapters in the course/chapter branch.
    // In mock, we simulate recursion starting from the parentId if provided.
    final allChapters = await _getAllChaptersRecursively(
      courseId,
      parentId: chapterId,
    );

    final lessons = <LessonDto>[];
    for (var ch in allChapters) {
      lessons.addAll(await getLessons(ch.id));
    }
    yield CourseCurriculumDto(chapters: allChapters, lessons: lessons);
  }

  Future<List<ChapterDto>> _getAllChaptersRecursively(
    String courseId, {
    String? parentId,
  }) async {
    final List<ChapterDto> result = [];
    final chapters = await getChapters(courseId, parentId: parentId);

    for (final chapter in chapters) {
      result.add(chapter);
      if (!chapter.isLeaf) {
        result.addAll(
          await _getAllChaptersRecursively(courseId, parentId: chapter.id),
        );
      }
    }
    return result;
  }

  @override
  Future<CourseCurriculumDto> getRunningContents(
    String courseId, {
    String? chapterId,
  }) async {
    final all = await getCourseContents(courseId).first;
    return all.copyWith(
      lessons: all.lessons
          .where((l) => l.progressStatus == LessonProgressStatus.inProgress)
          .toList(),
    );
  }

  @override
  Future<CourseCurriculumDto> getUpcomingContents(
    String courseId, {
    String? chapterId,
  }) async {
    final all = await getCourseContents(courseId).first;
    return all.copyWith(
      lessons: all.lessons
          .where((l) => l.progressStatus == LessonProgressStatus.notStarted)
          .toList(),
    );
  }

  @override
  Future<CourseCurriculumDto> getContentAttempts(
    String courseId, {
    String? chapterId,
  }) async {
    final all = await getCourseContents(courseId).first;
    return all.copyWith(
      lessons: all.lessons
          .where((l) => l.progressStatus == LessonProgressStatus.completed)
          .toList(),
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
      contentUrl:
          'https://drive.google.com/uc?export=download&id=1QxJ4yF2LdlCVSll4NkTXj5bO-nL6Xzol',
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
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      attemptsUrl:
          'https://demo.testpress.in/api/v3/exams/thermodynamics-chapter-test/attempts/',
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
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      contentUrl:
          'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
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
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      contentUrl:
          'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
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
      subtitle: 'An introductory overview of the core concepts in this lesson.',
      type: LessonType.video,
      duration: '40 min',
      progressStatus: LessonProgressStatus.notStarted,
      isLocked: false,
      orderIndex: 0,
      lessonNumber: 1,
      totalLessons: 5,
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      contentUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
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
      contentUrl:
          'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
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
  Future<List<ForumCategoryDto>> getForumCategories() async =>
      mockForumCategories;

  @override
  Future<PaginatedResponseDto<ForumThreadDto>> getForumThreads({
    int page = 1,
    int? categoryId,
    String? searchQuery,
    String? sortString,
    bool? postedByMe,
    bool? commentedByMe,
    bool? likedByMe,
    bool? bookmarkedByMe,
  }) async {
    var results = mockForumThreads(page: page, categoryId: categoryId);

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      results = results
          .where(
            (t) =>
                t.title.toLowerCase().contains(query) ||
                t.summary.toLowerCase().contains(query),
          )
          .toList();
    }

    // Apply activity filter (simulated)
    if (postedByMe == true) {
      results = results.where((t) => t.threadId % 2 == 0).toList();
    } else if (commentedByMe == true) {
      results = results.where((t) => t.replyCount > 2).toList();
    } else if (likedByMe == true) {
      results = results.where((t) => t.upvotes > 10).toList();
    } else if (bookmarkedByMe == true) {
      results = results.where((t) => t.threadId % 3 == 0).toList();
    }

    // Apply sort
    if (sortString != null) {
      results = List.from(results);
      switch (sortString) {
        case '-created':
          results.sort((a, b) => b.threadId.compareTo(a.threadId));
          break;
        case '-upvotes':
          results.sort((a, b) => b.upvotes.compareTo(a.upvotes));
          break;
        case '-views_count':
          // Simulate most viewed by sorting by replies
          results.sort((a, b) => b.replyCount.compareTo(a.replyCount));
          break;
      }
    }

    return PaginatedResponseDto<ForumThreadDto>(
      results: results,
      count: results.length * 5,
      next: page < 3
          ? 'https://api.cortex.com/v2.5/discussions/?page=${page + 1}'
          : null,
    );
  }

  @override
  Future<ForumThreadDto> getForumThread(String slug) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final thread = mockForumThreads().firstWhere(
      (t) => t.slug == slug,
      orElse: () => mockForumThreads().first,
    );
    return thread;
  }

  @override
  Future<PaginatedResponseDto<ForumCommentDto>> getForumComments({
    required int threadId,
    int page = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = mockForumComments(threadId);
    return PaginatedResponseDto<ForumCommentDto>(
      results: results,
      count: results.length,
      next: null,
    );
  }

  @override
  Future<ForumCommentDto> postForumComment({
    required int threadId,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ForumCommentDto(
      id: '999', // Mock ID
      threadId: threadId,
      authorName: 'Mock User',
      authorAvatar: null,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<String> uploadImage(File file) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://mock.url/${file.path.split('/').last}';
  }

  @override
  Future<ForumThreadDto> postForumThread({
    required String title,
    required String contentHtml,
    required String categorySlug,
    String? courseId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ForumThreadDto(
      threadId: 999,
      slug: title.toLowerCase().replaceAll(' ', '-'),
      title: title,
      authorName: 'Mock User',
      authorAvatar: null,
      replyCount: 0,
      createdAt: DateTime.now().toIso8601String(),
      contentHtml: contentHtml,
      summary: 'Mock summary',
      status: ForumThreadStatus.unanswered,
      upvotes: 0,
      downvotes: 0,
    );
  }

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
  // Store
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<PaginatedResponseDto<ProductCategoryDto>> getProductCategories({
    int page = 1,
    String? search,
  }) async {
    return PaginatedResponseDto(
      count: 2,
      results: [
        ProductCategoryDto(id: 1, name: 'NEET Courses', slug: 'neet'),
        ProductCategoryDto(id: 2, name: 'Subscription Pass', slug: 'pass'),
      ],
    );
  }

  @override
  Future<PaginatedResponseDto<ProductDto>> getProducts({
    int page = 1,
    String? category,
    String? categoryName,
    String? tag,
    String? search,
  }) async {
    return PaginatedResponseDto(
      count: 2,
      results: [
        ProductDto(
          id: 524,
          title: 'Course C',
          slug: 'course-c',
          price: '300.00',
          courses: const [372],
        ),
        ProductDto(
          id: 326,
          title: 'Subscription Pass',
          slug: 'subscription-pass',
          price: '3000.00',
          strikeThroughPrice: '5000.00',
          courses: const [],
        ),
      ],
    );
  }

  @override
  Future<ProductDto> getProduct(String slug) async {
    return ProductDto(
      id: 524,
      title: 'Course C',
      slug: slug,
      price: '300.00',
      courses: const [372],
      hasCoupons: true,
    );
  }

  @override
  Future<OrderDto> createOrder(String productSlug) async {
    return const OrderDto(
      id: 101,
      status: 'Draft',
      total: '300.00',
      subtotal: '300.00',
    );
  }

  @override
  Future<OrderDto> confirmOrder(
    int orderId,
    Map<String, dynamic> billingDetails,
  ) async {
    return const OrderDto(
      id: 101,
      status: 'Confirmed',
      total: '300.00',
      subtotal: '300.00',
      orderId: 'mock_razorpay_order_123',
      apiKey: 'mock_api_key_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '9999999999',
      productInfo: 'Course Access',
      pgUrl: 'https://test.payu.in/_payment',
    );
  }

  @override
  Future<OrderDto> refreshOrderStatus(int orderId) async {
    return const OrderDto(
      id: 101,
      status: 'Completed',
      total: '300.00',
      subtotal: '300.00',
    );
  }

  @override
  Future<String> generatePayUHash(String hashString) async {
    return 'mock_generated_hash_string';
  }

  @override
  Future<OrderDto> applyCoupon(int orderId, String couponCode) async {
    if (couponCode == 'TEST50') {
      return const OrderDto(
        id: 101,
        status: 'Draft',
        total: '150.00',
        subtotal: '300.00',
      );
    }
    throw Exception('Invalid coupon code');
  }

  @override
  Future<InstallmentPlansResponseDto> getInstallmentPlans(String slug) async {
    return const InstallmentPlansResponseDto(
      installmentPlans: [],
      userInstallmentPlans: [],
    );
  }

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
  Future<LearnerDto> fetchMyRank() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const LearnerDto(
      id: 'me',
      rank: 150,
      name: 'Current User',
      avatar: '',
      points: 450,
    );
  }

  @override
  Future<List<LearnerDto>> fetchCompetitorTargets() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      LearnerDto(id: 'c1', rank: 0, name: 'Target 1', avatar: '', points: 500),
      LearnerDto(id: 'c2', rank: 0, name: 'Target 2', avatar: '', points: 480),
    ];
  }

  @override
  Future<List<LearnerDto>> fetchCompetitorThreats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      LearnerDto(id: 'c3', rank: 0, name: 'Threat 1', avatar: '', points: 420),
      LearnerDto(id: 'c4', rank: 0, name: 'Threat 2', avatar: '', points: 400),
    ];
  }

  @override
  Future<DashboardContentsDto> getWhatsNewFeed(
    DashboardSectionType sectionType,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockWhatsNewFeed;
  }

  @override
  Future<DashboardContentsDto> getResumeLearningFeed(
    DashboardSectionType sectionType,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockResumeLearningFeed;
  }

  @override
  Future<DashboardContentsDto> getRecentlyCompletedFeed(
    DashboardSectionType sectionType,
  ) async {
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
  Future<PaginatedLoginActivityDto> getLoginActivity({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PaginatedLoginActivityDto(
      count: 2,
      perPage: 20,
      results: [
        LoginActivityDto(
          id: 11245579,
          userAgent:
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',
          ipAddress: '122.178.92.74',
          device: 'PC',
          deviceName: 'Chrome',
          browser: 'Chrome',
          os: 'Mac OS X',
          lastUsed: DateTime.parse('2026-05-23T08:58:46.800545Z'),
          location: 'India',
          currentDevice: true,
        ),
        LoginActivityDto(
          id: 11245566,
          userAgent: 'flutter-app/0.1.0 (I2126; Android 14)',
          ipAddress: '122.178.92.74',
          device: 'Android/iOS App',
          deviceName: 'Smartphone',
          browser: 'Other',
          os: 'Android',
          lastUsed: DateTime.parse('2026-05-23T09:24:18.602268Z'),
          location: 'India',
          currentDevice: false,
        ),
      ],
    );
  }

  @override
  Future<UserDto> updateProfile(Map<String, dynamic> data) async {
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
  Future<List<AttemptDto>> getAttempts(String attemptsUrl) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AttemptDto(
        id: 999,
        state: 'Completed',
        remainingTime: '0:00:00',
        date: DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
        score: '45.0',
        correctCount: 15,
        incorrectCount: 5,
        totalQuestions: 30,
      ),
    ];
  }

  @override
  Future<AttemptDto> createAttempt(
    String attemptsUrl, {
    Map<String, dynamic>? data,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final attemptType = data?['attempt_type'] as int?;
    return AttemptDto(
      id: 999,
      state: 'Running',
      remainingTime: '0:30:00',
      correctCount: 0,
      attemptType: attemptType,
    );
  }

  @override
  Future<AttemptDto> createContentAttempt(
    String contentAttemptsUrl, {
    Map<String, dynamic>? data,
  }) async {
    return createAttempt(contentAttemptsUrl, data: data);
  }

  @override
  Future<SectionDto> startSection(String attemptId, String sectionOrder) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SectionDto(
      id: 'mock-section-$sectionOrder',
      name: 'Section $sectionOrder',
      state: 'Running',
      order: int.tryParse(sectionOrder) ?? 0,
    );
  }

  @override
  Future<SectionDto> endSection(String attemptId, String sectionOrder) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SectionDto(
      id: 'mock-section-$sectionOrder',
      name: 'Section $sectionOrder',
      state: 'Completed',
      order: int.tryParse(sectionOrder) ?? 0,
    );
  }

  @override
  Future<AttemptDto> startAttempt(String attemptId) async {
    return createAttempt('dummy-url');
  }

  @override
  Future<List<QuestionDto>> getQuestions(String attemptId) async {
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
  Future<QuizReviewResultDto?> submitAnswer(
    String attemptId,
    String questionId,
    AnswerDto answer,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return QuizReviewResultDto(
      questionId: questionId,
      selectedAnswers: answer.selectedOptions,
      correctAnswers: const ['o1'],
      result: true,
      explanationHtml: 'This is a mock explanation.',
    );
  }

  @override
  Future<void> reportQuestion(
    String questionId,
    Map<String, dynamic> payload,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> submitOfflineExamAnswers(
    String examId,
    Map<String, dynamic> payload,
  ) async {
    return Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<AttemptDto> sendHeartbeat(String attemptId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const AttemptDto(id: 999, remainingTime: '00:59:30');
  }

  @override
  Future<String?> getLastWatchedPosition(String attemptsUrl) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return '45.0';
  }

  @override
  Future<void> updateVideoAttempt({
    required int chapterContentId,
    required String lastWatchPosition,
    required List<List<double>> watchedTimeRanges,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<AttemptDto> endExam(
    String attemptId, {
    bool isContentExam = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const AttemptDto(id: 999, score: '45/100');
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
          explanationHtml:
              '<p>The SI unit of Force is the Newton (N), named after Sir Isaac Newton.</p>',
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
          explanationHtml:
              '<p>Velocity and Acceleration have both magnitude and direction, making them vectors.</p>',
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
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(
    String analyticsUrl,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockSubjectAnalytics;
  }

  @override
  Future<PaginatedResponseDto<SubjectAnalyticsDto>> getAnalyticsData({
    int page = 1,
    int? parentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PaginatedResponseDto<SubjectAnalyticsDto>(
      count: mockSubjectAnalytics.length,
      next: null,
      previous: null,
      results: mockSubjectAnalytics,
    );
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
  Future<PaginatedResponseDto<DoubtDto>> getDoubts({
    int page = 1,
    String? searchQuery,
    int? chapterContentId,
    String? queryType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PaginatedResponseDto<DoubtDto>(
      results: mockDoubts,
      count: mockDoubts.length,
      next: null,
      previous: null,
    );
  }

  @override
  Future<({DoubtDto doubt, List<DoubtReplyDto> replies})> getDoubtReplies(
    String doubtId,
  ) async {
    final doubt = mockDoubts.firstWhere(
      (d) => d.id == doubtId,
      orElse: () => mockDoubts.first,
    );
    return (doubt: doubt, replies: getMockDoubtReplies(doubtId));
  }

  @override
  Future<List<DoubtTopicDto>> getDoubtTopics({int? parentId}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (parentId == null) {
      return const [
        DoubtTopicDto(
          id: 10,
          title: 'Mathematics',
          parentId: null,
          hasChildren: true,
        ),
        DoubtTopicDto(
          id: 11,
          title: 'Physics',
          parentId: null,
          hasChildren: true,
        ),
        DoubtTopicDto(
          id: 12,
          title: 'Chemistry',
          parentId: null,
          hasChildren: false,
        ),
      ];
    } else if (parentId == 10) {
      return const [
        DoubtTopicDto(
          id: 101,
          title: 'Calculus',
          parentId: 10,
          hasChildren: false,
        ),
        DoubtTopicDto(
          id: 102,
          title: 'Algebra',
          parentId: 10,
          hasChildren: false,
        ),
      ];
    } else if (parentId == 11) {
      return const [
        DoubtTopicDto(
          id: 111,
          title: 'Mechanics',
          parentId: 11,
          hasChildren: false,
        ),
        DoubtTopicDto(
          id: 112,
          title: 'Electromagnetism',
          parentId: 11,
          hasChildren: false,
        ),
      ];
    }

    return const [];
  }

  @override
  Future<DoubtDto> createDoubt({
    required String title,
    required String description,
    int? topicId,
    int? chapterContentId,
    int? questionId,
    int? queryType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newDoubt = DoubtDto(
      id: 'mock_doubt_${DateTime.now().millisecondsSinceEpoch}',
      topicId: topicId,
      topicName: 'Mock Topic',
      lessonId: chapterContentId?.toString(),
      title: title,
      content: description,
      studentName: 'Arjun Sharma',
      studentAvatar: null,
      replyCount: 0,
      status: DoubtStatus.active,
      createdAt: DateTime.now(),
      attachmentUrls: const [],
    );
    mockDoubts.insert(0, newDoubt);
    return newDoubt;
  }

  @override
  Future<DoubtReplyDto> postDoubtReply({
    required String doubtId,
    String? comment,
    bool? shouldResolve,
    bool? shouldClose,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = mockDoubts.indexWhere((d) => d.id == doubtId);
    if (index != -1) {
      var newStatus = mockDoubts[index].status;
      if (shouldResolve == true) {
        newStatus = DoubtStatus.resolved;
      } else if (shouldClose == true) {
        newStatus = DoubtStatus.closed;
      } else if (mockDoubts[index].status == DoubtStatus.resolved) {
        newStatus = DoubtStatus.active;
      }

      mockDoubts[index] = DoubtDto(
        id: mockDoubts[index].id,
        topicId: mockDoubts[index].topicId,
        topicName: mockDoubts[index].topicName,
        lessonId: mockDoubts[index].lessonId,
        title: mockDoubts[index].title,
        content: mockDoubts[index].content,
        studentName: mockDoubts[index].studentName,
        studentAvatar: mockDoubts[index].studentAvatar,
        replyCount:
            (mockDoubts[index].replyCount ?? 0) + (comment != null ? 1 : 0),
        status: newStatus,
        createdAt: mockDoubts[index].createdAt,
        attachmentUrls: mockDoubts[index].attachmentUrls,
      );
    }

    return DoubtReplyDto(
      id: 'mock_reply_${DateTime.now().millisecondsSinceEpoch}',
      doubtId: doubtId,
      content: comment ?? '',
      authorName: 'Arjun Sharma',
      authorAvatar: null,
      isMentor: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<String> uploadDoubtImage(File file, {int? ticketId}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return 'https://mock.url/uploads/${file.path.split('/').last}';
  }

  @override
  Future<List<BookmarkFolderDto>> getBookmarkFolders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockFolders;
  }

  @override
  Future<PaginatedResponseDto<BookmarkDto>> getBookmarks({
    int page = 1,
    String? folder,
    String? order,
    String? filter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PaginatedResponseDto(
      results: _mockBookmarks,
      count: _mockBookmarks.length,
      next: null,
      previous: null,
    );
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
  Future<BookmarkFolderDto> updateBookmarkFolder(int id, String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockFolders.indexWhere((f) => f.id == id);
    if (index == -1) throw Exception('Folder not found');
    final updatedFolder = BookmarkFolderDto(
      id: id,
      name: name,
      bookmarksCount: _mockFolders[index].bookmarksCount,
    );
    _mockFolders[index] = updatedFolder;
    return updatedFolder;
  }

  @override
  Future<void> deleteBookmarkFolder(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockFolders.removeWhere((f) => f.id == id);
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
        final fIndex = _mockFolders.indexWhere(
          (f) => f.id == bookmark.folderId,
        );
        if (fIndex != -1) {
          _mockFolders[fIndex] = _mockFolders[fIndex].copyWith(
            bookmarksCount: (_mockFolders[fIndex].bookmarksCount - 1).clamp(
              0,
              999999,
            ),
          );
        }
      }
    }
  }

  // ── Posts / Announcements ──────────────────────────────────────────────────

  @override
  Future<PaginatedResponseDto<PostDto>> getPosts({
    int page = 1,
    String? categorySlug,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PaginatedResponseDto(results: mockPosts, count: 3, next: null);
  }

  @override
  Future<List<PostCategoryDto>> getPostCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockPostCategories;
  }

  @override
  Future<List<QuestionDto>> getOfflineExamQuestions(String examId) async {
    return [];
  }

  // ── Custom Exams ────────────────────────────────────────────────────────

  @override
  Future<CustomTestConfigDto> getCustomTestConfig(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const CustomTestConfigDto(
      subjects: [
        CustomTestFilterOptionDto(value: 'Math', label: 'Math'),
        CustomTestFilterOptionDto(value: 'Science', label: 'Science'),
      ],
      difficultyLevels: [
        CustomTestFilterOptionDto(value: 'Easy', label: 'Easy'),
        CustomTestFilterOptionDto(value: 'Medium', label: 'Medium'),
        CustomTestFilterOptionDto(value: 'Hard', label: 'Hard'),
      ],
      questionTypes: [
        CustomTestFilterOptionDto(
          value: 'Multiple Choice',
          label: 'Multiple Choice',
        ),
      ],
      testModes: [
        CustomTestFilterOptionDto(value: 'Practice', label: 'Practice'),
        CustomTestFilterOptionDto(value: 'Exam', label: 'Exam'),
      ],
      limits: CustomTestLimitsDto(
        maxQuestionsPerTest: 50,
        dailyAttemptsAvailable: 10,
        monthlyAttemptsAvailable: 100,
      ),
    );
  }

  @override
  Future<AttemptDto> generateCustomExam(
    CustomExamGenerationRequestDto request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock response with a dummy attempt.
    return AttemptDto(
      id: 9999,
      date: '2023-01-01T00:00:00Z',
      totalQuestions: request.numberOfQuestions,
      score: '0',
      rank: 0,
      percentile: '0',
      percentage: '0',
      correctCount: 0,
      incorrectCount: 0,
      timeTaken: '00:00:00',
      state: 'Running',
    );
  }
}
