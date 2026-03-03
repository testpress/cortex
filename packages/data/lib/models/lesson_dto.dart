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
  final String? chapterTitle;

  // Rich content for LessonDetailScreen
  final List<LessonContentItemDto> content;
  final String? subtitle;
  final String? subjectName;
  final int? subjectIndex;
  final int? lessonNumber;
  final int? totalLessons;
  final bool isBookmarked;

  const LessonDto({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.type,
    required this.duration,
    required this.progressStatus,
    required this.isLocked,
    required this.orderIndex,
    this.chapterTitle,
    this.content = const [],
    this.subtitle,
    this.subjectName,
    this.subjectIndex,
    this.lessonNumber,
    this.totalLessons,
    this.isBookmarked = false,
  });

  LessonDto copyWith({
    String? id,
    String? chapterId,
    String? title,
    LessonType? type,
    String? duration,
    LessonProgressStatus? progressStatus,
    bool? isLocked,
    int? orderIndex,
    String? chapterTitle,
    List<LessonContentItemDto>? content,
    String? subtitle,
    String? subjectName,
    int? subjectIndex,
    int? lessonNumber,
    int? totalLessons,
    bool? isBookmarked,
  }) {
    return LessonDto(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      progressStatus: progressStatus ?? this.progressStatus,
      isLocked: isLocked ?? this.isLocked,
      orderIndex: orderIndex ?? this.orderIndex,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      content: content ?? this.content,
      subtitle: subtitle ?? this.subtitle,
      subjectName: subjectName ?? this.subjectName,
      subjectIndex: subjectIndex ?? this.subjectIndex,
      lessonNumber: lessonNumber ?? this.lessonNumber,
      totalLessons: totalLessons ?? this.totalLessons,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

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
      chapterTitle: json['chapterTitle'] as String?,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) =>
                  LessonContentItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtitle: json['subtitle'] as String?,
      subjectName: json['subjectName'] as String?,
      subjectIndex: json['subjectIndex'] as int?,
      lessonNumber: json['lessonNumber'] as int?,
      totalLessons: json['totalLessons'] as int?,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
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
      'chapterTitle': chapterTitle,
      'content': content.map((e) => e.toJson()).toList(),
      'subtitle': subtitle,
      'subjectName': subjectName,
      'subjectIndex': subjectIndex,
      'lessonNumber': lessonNumber,
      'totalLessons': totalLessons,
      'isBookmarked': isBookmarked,
    };
  }
}

/// DTO for a single atom of content within a lesson.
class LessonContentItemDto {
  final String type;
  final dynamic content; // String or List<String>
  final int? level;
  final String? alt;
  final String? calloutType;

  const LessonContentItemDto({
    required this.type,
    required this.content,
    this.level,
    this.alt,
    this.calloutType,
  });

  factory LessonContentItemDto.fromJson(Map<String, dynamic> json) {
    return LessonContentItemDto(
      type: json['type'] as String,
      content: json['content'],
      level: json['level'] as int?,
      alt: json['alt'] as String?,
      calloutType: json['calloutType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      if (level != null) 'level': level,
      if (alt != null) 'alt': alt,
      if (calloutType != null) 'calloutType': calloutType,
    };
  }
}
