import 'package:data/data.dart' show LessonType, LessonProgressStatus;

export 'package:data/data.dart' show LessonType, LessonProgressStatus;

/// Domain model for a specific content item within a chapter.
class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.progressStatus,
    this.duration,
    this.isLocked = false,
  });

  final String id;
  final String title;
  final LessonType type;
  final LessonProgressStatus progressStatus;
  final String? duration;
  final bool isLocked;
}

/// Domain model for a chapter within a course.
class Chapter {
  const Chapter({
    required this.id,
    required this.title,
    required this.lessonCount,
    required this.assessmentCount,
    this.courseTitle,
    this.lessons = const [],
  });

  final String id;
  final String title;
  final int lessonCount;
  final int assessmentCount;
  final String? courseTitle;
  final List<Lesson> lessons;
}
