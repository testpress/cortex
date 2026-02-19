/// Chapter DTO — one chapter within a course.
class ChapterDto {
  final String id;
  final String courseId;
  final String title;
  final int lessonCount;
  final int assessmentCount;
  final int orderIndex;

  const ChapterDto({
    required this.id,
    required this.courseId,
    required this.title,
    required this.lessonCount,
    required this.assessmentCount,
    required this.orderIndex,
  });
}
