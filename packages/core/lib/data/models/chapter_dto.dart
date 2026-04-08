import 'lesson_dto.dart';

/// Chapter DTO — one chapter within a course.
class ChapterDto {
  final String id;
  final String courseId;
  final String title;
  final int lessonCount;
  final int assessmentCount;
  final int orderIndex;
  final String? image;
  final String? parentId;
  final bool isLeaf;
  final List<LessonDto> lessons;

  const ChapterDto({
    required this.id,
    required this.courseId,
    required this.title,
    required this.lessonCount,
    required this.assessmentCount,
    required this.orderIndex,
    this.parentId,
    this.isLeaf = true,
    this.image,
    this.lessons = const [],
  });

  ChapterDto copyWith({
    String? id,
    String? courseId,
    String? title,
    int? lessonCount,
    int? assessmentCount,
    int? orderIndex,
    String? parentId,
    bool? isLeaf,
    String? image,
    List<LessonDto>? lessons,
  }) {
    return ChapterDto(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      lessonCount: lessonCount ?? this.lessonCount,
      assessmentCount: assessmentCount ?? this.assessmentCount,
      orderIndex: orderIndex ?? this.orderIndex,
      parentId: parentId ?? this.parentId,
      isLeaf: isLeaf ?? this.isLeaf,
      image: image ?? this.image,
      lessons: lessons ?? this.lessons,
    );
  }

  /// Maps from the `/api/v3/courses/{id}/chapters/` response.
  /// The API uses `name` (not `title`), numeric `id`/`course_id`, and
  /// `contents_count` / `exams_count` + `quizzes_count` for counts.
  factory ChapterDto.fromJson(Map<String, dynamic> json) {
    return ChapterDto(
      id: (json['id'] ?? '').toString(),
      courseId: (json['course_id'] ?? json['courseId'] ?? '').toString(),
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      lessonCount: (json['contents_count'] as num?)?.toInt() ?? (json['lessonCount'] as num?)?.toInt() ?? 0,
      assessmentCount:
          ((json['exams_count'] as num?)?.toInt() ?? 0) +
          ((json['quizzes_count'] as num?)?.toInt() ?? 0) +
          ((json['assessmentCount'] as num?)?.toInt() ?? 0),
      orderIndex: (json['order'] as num?)?.toInt() ?? (json['orderIndex'] as num?)?.toInt() ?? 0,
      parentId: (json['parent_id'] ?? json['parentId'])?.toString(),
      isLeaf: json['leaf'] as bool? ?? json['isLeaf'] as bool? ?? true,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'lessonCount': lessonCount,
      'assessmentCount': assessmentCount,
      'orderIndex': orderIndex,
      'parentId': parentId,
      'isLeaf': isLeaf,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}
