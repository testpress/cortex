/// Lesson content type.
enum LessonType { video, pdf, assessment, test }

/// Lesson progress status.
enum LessonProgressStatus { notStarted, inProgress, completed }

/// Lesson DTO — one content item within a chapter.
class LessonDto {
  final String id;
  final String chapterId;
  final String title;
  final LessonType type;
  final String duration; // e.g. "45 min"
  final LessonProgressStatus progressStatus;
  final bool isLocked;
  final int orderIndex;

  const LessonDto({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.type,
    required this.duration,
    required this.progressStatus,
    required this.isLocked,
    required this.orderIndex,
  });

  factory LessonDto.fromJson(Map<String, dynamic> json) {
    return LessonDto(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      title: json['title'] as String,
      type: LessonType.values.firstWhere((e) => e.name == json['type']),
      duration: json['duration'] as String,
      progressStatus: LessonProgressStatus.values
          .firstWhere((e) => e.name == json['progressStatus']),
      isLocked: json['isLocked'] as bool,
      orderIndex: json['orderIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'title': title,
      'type': type.name,
      'duration': duration,
      'progressStatus': progressStatus.name,
      'isLocked': isLocked,
      'orderIndex': orderIndex,
    };
  }
}
