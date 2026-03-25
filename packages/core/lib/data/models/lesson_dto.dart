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

  // Flattened media URL for LessonDetailScreen (PDF or Video)
  final String? contentUrl;
  final String? subtitle;
  final String? subjectName;
  final int? subjectIndex;
  final int? lessonNumber;
  final int? totalLessons;
  final bool isBookmarked;
  final DateTime? lastAccessedAt;

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
    this.contentUrl,
    this.subtitle,
    this.subjectName,
    this.subjectIndex,
    this.lessonNumber,
    this.totalLessons,
    this.isBookmarked = false,
    this.lastAccessedAt,
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
    String? contentUrl,
    String? subtitle,
    String? subjectName,
    int? subjectIndex,
    int? lessonNumber,
    int? totalLessons,
    bool? isBookmarked,
    DateTime? lastAccessedAt,
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
      contentUrl: contentUrl ?? this.contentUrl,
      subtitle: subtitle ?? this.subtitle,
      subjectName: subjectName ?? this.subjectName,
      subjectIndex: subjectIndex ?? this.subjectIndex,
      lessonNumber: lessonNumber ?? this.lessonNumber,
      totalLessons: totalLessons ?? this.totalLessons,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
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
      contentUrl: json['contentUrl'] as String?,
      subtitle: json['subtitle'] as String?,
      subjectName: json['subjectName'] as String?,
      subjectIndex: json['subjectIndex'] as int?,
      lessonNumber: json['lessonNumber'] as int?,
      totalLessons: json['totalLessons'] as int?,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'] as String)
          : null,
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
      'contentUrl': contentUrl,
      'subtitle': subtitle,
      'subjectName': subjectName,
      'subjectIndex': subjectIndex,
      'lessonNumber': lessonNumber,
      'totalLessons': totalLessons,
      'isBookmarked': isBookmarked,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    };
  }
}
