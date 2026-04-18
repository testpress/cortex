import 'package:core/data/data.dart' show LessonType, LessonProgressStatus;

export 'package:core/data/data.dart' show LessonType, LessonProgressStatus;

/// Domain model for a specific content item within a chapter.
class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.progressStatus,
    this.duration,
    this.isLocked = false,
    this.subtitle,
    this.subjectName,
    this.subjectIndex,
    this.lessonNumber,
    this.totalLessons,
    this.isBookmarked = false,
    this.contentUrl,
  });

  final String id;
  final String title;
  final LessonType type;
  final LessonProgressStatus progressStatus;
  final String? duration;
  final bool isLocked;
  final bool isBookmarked;

  // New fields for LessonDetailScreen (Phase-2)
  final String? subtitle;
  final String? subjectName;
  final int? subjectIndex;
  final int? lessonNumber;
  final int? totalLessons;
  final String? contentUrl;
}

/// Domain model for a chapter within a course.
class Chapter {
  const Chapter({
    required this.id,
    required this.title,
    required this.lessonCount,
    required this.assessmentCount,
    this.courseTitle,
    this.image,
    this.lessons = const [],
  });

  final String id;
  final String title;
  final int lessonCount;
  final int assessmentCount;
  final String? courseTitle;
  final String? image;
  final List<Lesson> lessons;
}
