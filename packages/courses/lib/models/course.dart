import 'course_content.dart';

/// Course data model.
///
/// Represents a course with metadata for display in the course library.
class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    this.chapters = const [],
  });

  final String id;
  final String title;
  final String description;
  final double progress; // 0.0 to 1.0
  final List<Chapter> chapters;

  bool get isStarted => progress > 0;
  bool get isCompleted => progress >= 1.0;

  int get totalLessons => chapters.fold(0, (sum, c) => sum + c.lessonCount);
  int get assessmentCount =>
      chapters.fold(0, (sum, c) => sum + c.assessmentCount);
}
