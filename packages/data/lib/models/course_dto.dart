/// Course DTO — plain Dart object transferred from DataSource to Drift and back to UI.
class CourseDto {
  final String id;
  final String title;
  final String
  subjectColor; // e.g. 'physics', 'chemistry', 'math', 'biology', 'english', 'exam'
  final int chapterCount;
  final String totalDuration;
  final int progress; // 0–100
  final int completedLessons;
  final int totalLessons;

  const CourseDto({
    required this.id,
    required this.title,
    required this.subjectColor,
    required this.chapterCount,
    required this.totalDuration,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
  });

  CourseDto copyWith({
    String? id,
    String? title,
    String? subjectColor,
    int? chapterCount,
    String? totalDuration,
    int? progress,
    int? completedLessons,
    int? totalLessons,
  }) {
    return CourseDto(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectColor: subjectColor ?? this.subjectColor,
      chapterCount: chapterCount ?? this.chapterCount,
      totalDuration: totalDuration ?? this.totalDuration,
      progress: progress ?? this.progress,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
    );
  }
}
