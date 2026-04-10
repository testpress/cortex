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
  final bool isRunning;
  final bool isUpcoming;
  final bool hasAttempts;
  final String? image;

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
    this.isRunning = false,
    this.isUpcoming = false,
    this.hasAttempts = false,
    this.image,
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
    bool? isRunning,
    bool? isUpcoming,
    bool? hasAttempts,
    String? image,
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
      isRunning: isRunning ?? this.isRunning,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      hasAttempts: hasAttempts ?? this.hasAttempts,
      image: image ?? this.image,
    );
  }

  factory LessonDto.fromJson(Map<String, dynamic> json) {
    // Utility for safely getting string from dynamic (handles int IDs from API)
    String? getString(String key) => json[key]?.toString();

    return LessonDto(
      id: getString('id') ?? '',
      chapterId: () {
        final val = json['chapter_id'] ?? json['chapter'] ?? json['chapterId'];
        if (val is Map) return val['id']?.toString() ?? '';
        return val?.toString() ?? '';
      }(),
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      type: _parseType(json['content_type'] ?? json['type'] ?? json['kind']),
      duration: json['duration'] as String? ?? '',
      progressStatus: _parseStatus(json['state'] ?? json['progressStatus']),
      isLocked: !(json['active'] as bool? ?? json['isLocked'] == false),
      orderIndex: (json['order'] as num?)?.toInt() ?? (json['orderIndex'] as num?)?.toInt() ?? 0,
      chapterTitle: json['chapter_title'] as String? ?? json['chapterTitle'] as String?,
      contentUrl: json['content_url'] as String? ?? json['url'] as String? ?? json['contentUrl'] as String?,
      subtitle: json['subtitle'] as String?,
      subjectName: json['subject_name'] as String? ?? json['subjectName'] as String?,
      subjectIndex: (json['subject_index'] as num?)?.toInt() ?? (json['subjectIndex'] as num?)?.toInt(),
      lessonNumber: (json['lesson_number'] as num?)?.toInt() ?? (json['lessonNumber'] as num?)?.toInt(),
      totalLessons: (json['total_lessons'] as num?)?.toInt() ?? (json['totalLessons'] as num?)?.toInt(),
      isBookmarked: json['is_bookmarked'] as bool? ?? json['isBookmarked'] as bool? ?? false,
      image: json['icon'] as String? ?? json['image'] as String?,
    );
  }

  static LessonType _parseType(dynamic value) {
    final s = value?.toString().toLowerCase() ?? '';
    if (s.contains('video') || s.contains('live') || s.contains('conference')) return LessonType.video;
    if (s.contains('pdf') || s.contains('notes') || s.contains('attachment')) return LessonType.pdf;
    
    // Grouping: Exam and Test are same (Mapped to Test - Orange)
    if (s.contains('exam') || s.contains('test')) return LessonType.test;
    
    // Grouping: Quiz and Assessment are same (Mapped to Assessment - Green)
    if (s.contains('quiz') || s.contains('assessment')) return LessonType.assessment;
    
    return LessonType.video;
  }

  static LessonProgressStatus _parseStatus(dynamic value) {
    final s = value?.toString().toLowerCase();
    if (s == 'completed' || s == '1') return LessonProgressStatus.completed;
    if (s == 'in_progress' || s == 'started' || s == '0') return LessonProgressStatus.inProgress;
    return LessonProgressStatus.notStarted;
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
      'isRunning': isRunning,
      'isUpcoming': isUpcoming,
      'hasAttempts': hasAttempts,
    };
  }
}
