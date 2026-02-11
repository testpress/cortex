/// Course data model.
///
/// Represents a course with metadata for display in the course library.
class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
  });

  final String id;
  final String title;
  final String description;
  final double progress; // 0.0 to 1.0

  bool get isStarted => progress > 0;
  bool get isCompleted => progress >= 1.0;
}
