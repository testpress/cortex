import 'lesson_dto.dart';

/// Chapter DTO — one chapter within a course.
class ChapterDto {
  final String id;
  final String courseId;
  final String title;
  final int lessonCount;
  final int assessmentCount;
  final int orderIndex;
  final List<LessonDto> lessons;

  const ChapterDto({
    required this.id,
    required this.courseId,
    required this.title,
    required this.lessonCount,
    required this.assessmentCount,
    required this.orderIndex,
    this.lessons = const [],
  });

  ChapterDto copyWith({
    String? id,
    String? courseId,
    String? title,
    int? lessonCount,
    int? assessmentCount,
    int? orderIndex,
    List<LessonDto>? lessons,
  }) {
    return ChapterDto(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      lessonCount: lessonCount ?? this.lessonCount,
      assessmentCount: assessmentCount ?? this.assessmentCount,
      orderIndex: orderIndex ?? this.orderIndex,
      lessons: lessons ?? this.lessons,
    );
  }

  factory ChapterDto.fromJson(Map<String, dynamic> json) {
    return ChapterDto(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      lessonCount: json['lessonCount'] as int,
      assessmentCount: json['assessmentCount'] as int,
      orderIndex: json['orderIndex'] as int,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}
