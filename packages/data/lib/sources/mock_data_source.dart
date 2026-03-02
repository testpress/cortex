import '../models/course_dto.dart';
import '../models/chapter_dto.dart';
import '../models/lesson_dto.dart';
import '../models/live_class_dto.dart';
import '../models/forum_thread_dto.dart';
import '../models/user_progress_dto.dart';
import 'data_source.dart';

/// In-process mock data source with hardcoded JEE/NEET coaching institute data.
/// Implements [DataSource]; no network calls are made.
/// Data is derived from the React reference design.
class MockDataSource implements DataSource {
  const MockDataSource();

  // ─────────────────────────────────────────────────────────────────────────
  // Courses
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<CourseDto>> getCourses() async => [
        const CourseDto(
          id: 'jee-main-2026',
          title: 'JEE Main 2026',
          colorIndex: 0, // indigo
          chapterCount: 12,
          totalDuration: '180 hrs',
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
          progress: 10,
          completedLessons: 2,
          totalLessons: 20,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // Chapters
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<List<ChapterDto>> getChapters(String courseId) async {
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

  List<ChapterDto> _jeeMainChapters() => [
        const ChapterDto(
          id: 'jee-main-ch-1',
          courseId: 'jee-main-2026',
          title: 'Thermodynamics',
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
        const ChapterDto(
          id: 'jee-main-ch-4',
          courseId: 'jee-main-2026',
          title: 'Organic Reactions — Mechanisms',
          lessonCount: 8,
          assessmentCount: 2,
          orderIndex: 3,
        ),
        const ChapterDto(
          id: 'jee-main-ch-5',
          courseId: 'jee-main-2026',
          title: 'Calculus II — Integration Techniques',
          lessonCount: 6,
          assessmentCount: 1,
          orderIndex: 4,
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
      case 'jee-main-ch-1':
        return _thermodynamicsLessons();
      case 'jee-main-ch-2':
        return _mechanicsLessons();
      case 'jee-main-ch-3':
        return _electrostaticsLessons();
      case 'jee-main-ch-4':
        return _organicChemLessons();
      case 'jee-main-ch-5':
        return _calculusLessons();
      default:
        return _genericLessons(chapterId);
    }
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
          content: [
            LessonContentItemDto(
              type: 'heading',
              content: 'What is Thermodynamics?',
              level: 1,
            ),
            LessonContentItemDto(
              type: 'paragraph',
              content:
                  'Thermodynamics is the branch of physics that deals with the relationships between heat, work, temperature, and energy. The behavior of these quantities is governed by the four laws of thermodynamics, which apply to all systems regardless of their specific properties.',
            ),
            LessonContentItemDto(
              type: 'paragraph',
              content:
                  'In this introductory lesson, we will explore what thermodynamics is, why it\'s important, and how it applies to everyday phenomena around us.',
            ),
            LessonContentItemDto(
              type: 'callout',
              content:
                  'Thermodynamics is one of the most fundamental subjects in physics, with applications in engines, refrigerators, power plants, and even biological systems!',
              calloutType: 'note',
            ),
            LessonContentItemDto(
              type: 'heading',
              content: 'Key Concepts in Thermodynamics',
              level: 2,
            ),
            LessonContentItemDto(
              type: 'list',
              content: [
                'System and Surroundings - Defining the boundaries of what we\'re studying',
                'State Variables - Properties like temperature, pressure, volume that describe a system',
                'Processes - How a system changes from one state to another',
                'Equilibrium - When a system\'s properties remain constant over time',
              ],
            ),
            LessonContentItemDto(
              type: 'image',
              content:
                  'https://images.unsplash.com/photo-1675627452903-082d0a77bc6f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwaHlzaWNzJTIwdGhlcm1vZHluYW1pY3MlMjBkaWFncmFtfGVufDF8fHx8MTc2Nzk1MzQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080',
              alt: 'Thermodynamic system diagram',
            ),
            LessonContentItemDto(
              type: 'heading',
              content: 'Why Study Thermodynamics?',
              level: 2,
            ),
            LessonContentItemDto(
              type: 'paragraph',
              content:
                  'Thermodynamics helps us understand how energy flows and transforms in the universe. From the engines in cars to the metabolism in our bodies, thermodynamic principles govern countless processes.',
            ),
            LessonContentItemDto(
              type: 'callout',
              content:
                  'For JEE preparation, thermodynamics is a high-weightage topic that appears in both Physics and Chemistry sections. Mastering it early gives you a strong foundation!',
              calloutType: 'tip',
            ),
          ],
        ),
        const LessonDto(
          id: 'thermo-2',
          chapterId: 'jee-main-ch-1',
          title: 'First Law of Thermodynamics',
          type: LessonType.video,
          duration: '38 min',
          progressStatus: LessonProgressStatus.inProgress,
          isLocked: false,
          orderIndex: 1,
        ),
        const LessonDto(
          id: 'thermo-3',
          chapterId: 'jee-main-ch-1',
          title: 'Practice Problems — First Law',
          type: LessonType.pdf,
          duration: '20 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 2,
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

  List<LessonDto> _organicChemLessons() => [
        const LessonDto(
          id: 'org-1',
          chapterId: 'jee-main-ch-4',
          title: 'Introduction to Reaction Mechanisms',
          type: LessonType.video,
          duration: '50 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 0,
        ),
        const LessonDto(
          id: 'org-2',
          chapterId: 'jee-main-ch-4',
          title: 'SN1 & SN2 Reactions',
          type: LessonType.video,
          duration: '45 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 1,
        ),
        const LessonDto(
          id: 'org-3',
          chapterId: 'jee-main-ch-4',
          title: 'Elimination Reactions',
          type: LessonType.video,
          duration: '38 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 2,
        ),
        const LessonDto(
          id: 'org-4',
          chapterId: 'jee-main-ch-4',
          title: 'Organic Reactions Worksheet',
          type: LessonType.pdf,
          duration: '20 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 3,
        ),
        const LessonDto(
          id: 'org-5',
          chapterId: 'jee-main-ch-4',
          title: 'Organic Chemistry Assessment',
          type: LessonType.assessment,
          duration: '30 min',
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
          type: LessonType.video,
          duration: '40 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 0,
        ),
        LessonDto(
          id: '$chapterId-l2',
          chapterId: chapterId,
          title: 'Core Concepts',
          type: LessonType.video,
          duration: '45 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 1,
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
  Future<List<ForumThreadDto>> getForumThreads(String courseId) async => [
        ForumThreadDto(
          id: 'ft-1',
          courseId: courseId,
          title: 'How to solve integration using substitution method?',
          description:
              "I'm having trouble understanding when to use substitution method in integration. Can someone explain with an example? Specifically for problems involving trigonometric functions.",
          studentName: 'Priya Sharma',
          timeAgo: '2 hours ago',
          replyCount: 3,
          status: ForumThreadStatus.answered,
        ),
        ForumThreadDto(
          id: 'ft-2',
          courseId: courseId,
          title: "Understanding Newton's Third Law with examples",
          description:
              "Can someone help me understand the practical applications of Newton's Third Law? I'm confused about action-reaction pairs in different scenarios.",
          studentName: 'Amit Patel',
          timeAgo: '5 hours ago',
          replyCount: 5,
          status: ForumThreadStatus.answered,
        ),
        ForumThreadDto(
          id: 'ft-3',
          courseId: courseId,
          title: 'Organic Chemistry — SN1 vs SN2 reactions',
          description:
              'What are the key differences between SN1 and SN2 reactions? How do I identify which mechanism will occur in a given reaction?',
          studentName: 'Sneha Gupta',
          timeAgo: '1 day ago',
          replyCount: 0,
          status: ForumThreadStatus.unanswered,
        ),
        ForumThreadDto(
          id: 'ft-4',
          courseId: courseId,
          title: 'Complex numbers — geometric interpretation doubt',
          description:
              'I need help understanding the geometric interpretation of complex number multiplication. Can someone explain with diagrams?',
          studentName: 'Rahul Singh',
          timeAgo: '1 day ago',
          replyCount: 4,
          status: ForumThreadStatus.answered,
        ),
        ForumThreadDto(
          id: 'ft-5',
          courseId: courseId,
          title: 'Thermodynamics — Entropy concept clarification',
          description:
              'Why does entropy always increase in an isolated system? Can someone provide a simple explanation without too much math?',
          studentName: 'Kavya Reddy',
          timeAgo: '2 days ago',
          replyCount: 0,
          status: ForumThreadStatus.unanswered,
        ),
      ];

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
}
