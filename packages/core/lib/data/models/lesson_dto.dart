import '../../utils/time_formatter.dart';

/// Lesson content type.
enum LessonType { video, pdf, notes, embedContent, liveStream, attachment, test, assessment, unknown }

/// Lesson progress status.
enum LessonProgressStatus { notStarted, inProgress, completed }

/// Lesson DTO — one content item within a chapter.
class LessonDto {
  final String id;
  final String chapterId;
  final String? courseId;
  final String? ancestorChapterIds;
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
  final int? bookmarkId;
  final bool isRunning;
  final bool isUpcoming;
  final bool hasAttempts;
  final int pausedAttemptsCount;
  final bool disableAttemptResume;
  final bool allowRetake;
  final int maxRetakes;
  final String? image;

  // New fields for sequential navigation and rich content (v2.4+)
  final String? nextContentId;
  final String? previousContentId;
  final String? htmlContent;
  final bool isDetailFetched;

  // Live Stream specific fields
  final String? chatEmbedUrl;
  final String? streamStatus;
  final bool showRecordedVideo;

  final bool isScheduled;
  final String? scheduledMessage;

  final String? attemptsUrl;
  final String? slug;
  final String? description;

  final bool enableTranscript;
  final String? videoSubtitleUrl;
  final bool isAiEnabled;
  final String? aiNotesUrl;

  /// Checks if the lesson has enough metadata to be rendered without a specialized loader.
  bool get isComplete {
    if (isDetailFetched) return true;
    if (isScheduled) return true; // Scheduled lessons have their message ready

    switch (type) {
      case LessonType.video:
      case LessonType.liveStream:
        return contentUrl != null && contentUrl!.isNotEmpty;
      case LessonType.notes:
      case LessonType.embedContent:
        return htmlContent != null && htmlContent!.isNotEmpty;
      case LessonType.pdf:
      case LessonType.attachment:
        return contentUrl != null && contentUrl!.isNotEmpty;
      default:
        return true;
    }
  }

  const LessonDto({
    required this.id,
    required this.chapterId,
    this.courseId,
    this.ancestorChapterIds,
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
    this.bookmarkId,
    this.isRunning = false,
    this.isUpcoming = false,
    this.hasAttempts = false,
    this.pausedAttemptsCount = 0,
    this.disableAttemptResume = false,
    this.allowRetake = true,
    this.maxRetakes = -1,
    this.image,
    this.nextContentId,
    this.previousContentId,
    this.htmlContent,
    this.isDetailFetched = false,
    this.chatEmbedUrl,
    this.streamStatus,
    this.showRecordedVideo = false,
    this.isScheduled = false,
    this.scheduledMessage,
    this.attemptsUrl,
    this.slug,
    this.description,
    this.enableTranscript = false,
    this.videoSubtitleUrl,
    this.isAiEnabled = false,
    this.aiNotesUrl,
  });

  LessonDto copyWith({
    bool? isScheduled,
    String? scheduledMessage,
    String? id,
    String? chapterId,
    String? courseId,
    String? ancestorChapterIds,
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
    int? bookmarkId,
    bool? isRunning,
    bool? isUpcoming,
    bool? hasAttempts,
    int? pausedAttemptsCount,
    bool? disableAttemptResume,
    bool? allowRetake,
    int? maxRetakes,
    String? image,
    String? description,
    String? nextContentId,
    String? previousContentId,
    String? htmlContent,
    bool? isDetailFetched,
    String? chatEmbedUrl,
    String? streamStatus,
    bool? showRecordedVideo,
    String? attemptsUrl,
    String? slug,
    bool? enableTranscript,
    String? videoSubtitleUrl,
    bool? isAiEnabled,
    String? aiNotesUrl,
  }) {
    return LessonDto(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      courseId: courseId ?? this.courseId,
      ancestorChapterIds: ancestorChapterIds ?? this.ancestorChapterIds,
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
      bookmarkId: bookmarkId ?? this.bookmarkId,
      isRunning: isRunning ?? this.isRunning,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      hasAttempts: hasAttempts ?? this.hasAttempts,
      pausedAttemptsCount: pausedAttemptsCount ?? this.pausedAttemptsCount,
      disableAttemptResume: disableAttemptResume ?? this.disableAttemptResume,
      allowRetake: allowRetake ?? this.allowRetake,
      maxRetakes: maxRetakes ?? this.maxRetakes,
      image: image ?? this.image,
      description: description ?? this.description,
      nextContentId: nextContentId ?? this.nextContentId,
      previousContentId: previousContentId ?? this.previousContentId,
      htmlContent: htmlContent ?? this.htmlContent,
      isDetailFetched: isDetailFetched ?? this.isDetailFetched,
      chatEmbedUrl: chatEmbedUrl ?? this.chatEmbedUrl,
      streamStatus: streamStatus ?? this.streamStatus,
      showRecordedVideo: showRecordedVideo ?? this.showRecordedVideo,
      isScheduled: isScheduled ?? this.isScheduled,
      scheduledMessage: scheduledMessage ?? this.scheduledMessage,
      attemptsUrl: attemptsUrl ?? this.attemptsUrl,
      slug: slug ?? this.slug,
      enableTranscript: enableTranscript ?? this.enableTranscript,
      videoSubtitleUrl: videoSubtitleUrl ?? this.videoSubtitleUrl,
      isAiEnabled: isAiEnabled ?? this.isAiEnabled,
      aiNotesUrl: aiNotesUrl ?? this.aiNotesUrl,
    );
  }

  /// Merges this DTO with another (typically local cached) DTO to preserve 
  /// rich metadata that might be missing in basic list API responses.
  LessonDto mergeWith(LessonDto? other) {
    if (other == null) return this;
    
    // Treat '0', '00:00', or '00:00:00' as effectively empty for duration merging
    bool isDurationEmpty(String? d) => d == null || d.isEmpty || d == '0' || d == '00:00' || d == '00:00:00' || d == '0:00:00';

    return copyWith(
      duration: (isDurationEmpty(duration) && !isDurationEmpty(other.duration)) ? other.duration : duration,
      contentUrl: (contentUrl?.isEmpty ?? true) ? other.contentUrl : contentUrl,
      htmlContent: (htmlContent?.isEmpty ?? true) ? other.htmlContent : htmlContent,
      subtitle: (subtitle?.isEmpty ?? true) ? other.subtitle : subtitle,
      subjectName: (subjectName?.isEmpty ?? true) ? other.subjectName : subjectName,
      subjectIndex: subjectIndex ?? other.subjectIndex,
      lessonNumber: lessonNumber ?? other.lessonNumber,
      totalLessons: totalLessons ?? other.totalLessons,
      nextContentId: (nextContentId?.isEmpty ?? true) ? other.nextContentId : nextContentId,
      previousContentId: (previousContentId?.isEmpty ?? true) ? other.previousContentId : previousContentId,
      chapterTitle: (chapterTitle?.isEmpty ?? true) ? other.chapterTitle : chapterTitle,
      courseId: (courseId?.isEmpty ?? true) ? other.courseId : courseId,
      ancestorChapterIds: (ancestorChapterIds?.isEmpty ?? true)
          ? other.ancestorChapterIds
          : ancestorChapterIds,
      image: (image?.isEmpty ?? true) ? other.image : image,
      description: (description?.isEmpty ?? true) ? other.description : description,
      attemptsUrl: (attemptsUrl?.isEmpty ?? true) ? other.attemptsUrl : attemptsUrl,
      slug: (slug?.isEmpty ?? true) ? other.slug : slug,
      enableTranscript: enableTranscript || other.enableTranscript,
      videoSubtitleUrl: (videoSubtitleUrl?.isEmpty ?? true) ? other.videoSubtitleUrl : videoSubtitleUrl,
      isAiEnabled: isAiEnabled || other.isAiEnabled,
      aiNotesUrl: (aiNotesUrl?.isEmpty ?? true) ? other.aiNotesUrl : aiNotesUrl,
      isDetailFetched: isDetailFetched || other.isDetailFetched,
      bookmarkId: bookmarkId ?? other.bookmarkId,
      // Status flags: Prefer 'true' or more advanced progress
      isRunning: isRunning || other.isRunning,
      isUpcoming: isUpcoming || other.isUpcoming,
      hasAttempts: hasAttempts || other.hasAttempts,
      pausedAttemptsCount: pausedAttemptsCount > 0
          ? pausedAttemptsCount
          : other.pausedAttemptsCount,
      disableAttemptResume: disableAttemptResume || other.disableAttemptResume,
      allowRetake: allowRetake && other.allowRetake,
      maxRetakes: maxRetakes != -1 ? maxRetakes : other.maxRetakes,
      isLocked:
          isLocked && other.isLocked, // Only locked if both say so (safer)
      progressStatus: progressStatus != LessonProgressStatus.notStarted
          ? progressStatus
          : other.progressStatus,
      chatEmbedUrl: (chatEmbedUrl?.isEmpty ?? true) ? other.chatEmbedUrl : chatEmbedUrl,
      streamStatus: (streamStatus?.isEmpty ?? true) ? other.streamStatus : streamStatus,
      showRecordedVideo: showRecordedVideo || other.showRecordedVideo,
      isScheduled: isScheduled || other.isScheduled,
      scheduledMessage: (scheduledMessage?.isEmpty ?? true) ? other.scheduledMessage : scheduledMessage,
      // Preserve specialized types (e.g. Attachment promoted to PDF, or Video promoted to Embed)
      type: (() {
        // If they are different, prefer the more specific one if one is 'attachment' or 'video'
        if (type == other.type) return type;
        
        // Promotion: Preference for PDF/Embed/Notes over generic Attachment/Video
        if (type == LessonType.attachment && other.type == LessonType.pdf) return LessonType.pdf;
        if (other.type == LessonType.attachment && type == LessonType.pdf) return LessonType.pdf;
        
        if (type == LessonType.video && other.type == LessonType.embedContent) return LessonType.embedContent;
        if (other.type == LessonType.video && type == LessonType.embedContent) return LessonType.embedContent;

        if (type == LessonType.video && other.type == LessonType.notes) return LessonType.notes;
        if (other.type == LessonType.video && type == LessonType.notes) return LessonType.notes;

        return type;
      })(),
    );
  }

  factory LessonDto.fromJson(Map<String, dynamic> json) {
    final type = _identifyLessonType(json);

    switch (type) {
      case LessonType.video:
        return _parseVideoLesson(json);
      case LessonType.embedContent:
        return _parseEmbedLesson(json);
      case LessonType.pdf:
        return _parsePdfLesson(json);
      case LessonType.notes:
        return _parseNotesLesson(json);
      case LessonType.attachment:
        return _parseAttachmentLesson(json);
      case LessonType.liveStream:
        return _parseLiveStreamLesson(json);
      case LessonType.test:
      case LessonType.assessment:
        return _parseExamLesson(json, type);
      case LessonType.unknown:
        return _parseBase(json, type);
    }
  }

  static LessonType _identifyLessonType(Map<String, dynamic> json) {
    if (json['live_stream'] != null || json['live_stream_url'] != null) {
      return LessonType.liveStream;
    }

    if (json['exam'] != null) {
      return LessonType.test;
    }

    final String contentType = (json['content_type'] ?? json['type'] ?? json['kind'])
            ?.toString()
            .toLowerCase() ??
        '';

    if (contentType.contains('live')) {
      return LessonType.liveStream;
    }

    // Video vs Embed
    if (contentType.contains('video')) {
      final video = json['video'] as Map<String, dynamic>?;
      final bool isEmbedded = json['is_embedded_content'] as bool? ??
          video?['is_embedded_content'] as bool? ??
          false;
      return isEmbedded ? LessonType.embedContent : LessonType.video;
    }

    // Notes / Html
    if (contentType.contains('html') || contentType.contains('notes')) {
      return LessonType.notes;
    }

    // PDF vs Attachment
    if (contentType.contains('pdf')) return LessonType.pdf;
    if (contentType.contains('attachment')) {
      final attachment = json['attachment'] as Map<String, dynamic>?;
      final isRenderable = attachment?['is_renderable'] as bool? ?? false;
      return isRenderable ? LessonType.pdf : LessonType.attachment;
    }

    // Exams / Assessments
    if (contentType.contains('exam') || contentType.contains('test')) {
      return LessonType.test;
    }
    if (contentType.contains('quiz') || contentType.contains('assessment')) {
      return LessonType.assessment;
    }

    return LessonType.unknown; // Fallback
  }

  static LessonDto _parseVideoLesson(Map<String, dynamic> json) {
    final base = _parseBase(json, LessonType.video);

    return base.copyWith(
      contentUrl: json['uuid']?.toString(),
    );
  }

  static LessonDto _parseEmbedLesson(Map<String, dynamic> json) {
    final base = _parseBase(json, LessonType.embedContent);
    final video = json['video'] as Map<String, dynamic>?;
    
    return base.copyWith(
      contentUrl: json['uuid']?.toString() ?? video?['url']?.toString() ?? json['url']?.toString(),
      htmlContent: video?['embed_code']?.toString() ?? json['embed_code']?.toString() ?? '',
      description: json['description']?.toString() ?? video?['description']?.toString() ?? base.description,
    );
  }

  static LessonDto _parsePdfLesson(Map<String, dynamic> json) {
    final base = _parseBase(json, LessonType.pdf);
    final attachment = json['attachment'] as Map<String, dynamic>?;

    return base.copyWith(
      contentUrl: json['content_url'] as String? ??
          attachment?['attachment_url'] as String? ??
          json['url'] as String?,
    );
  }

  static LessonDto _parseNotesLesson(Map<String, dynamic> json) {
    final base = _parseBase(json, LessonType.notes);
    final htmlContentData = json['html_content'] as Map<String, dynamic>?;

    return base.copyWith(
      contentUrl: json['html_content_url'] as String? ?? json['url'] as String?,
      htmlContent: htmlContentData?['text_html'] as String?,
    );
  }

  static LessonDto _parseAttachmentLesson(Map<String, dynamic> json) {
    final base = _parseBase(json, LessonType.attachment);
    final attachment = json['attachment'] as Map<String, dynamic>?;

    return base.copyWith(
      contentUrl: attachment?['attachment_url'] as String? ?? json['url'] as String?,
    );
  }

  static LessonDto _parseLiveStreamLesson(Map<String, dynamic> json) {
    final base = _parseBase(json, LessonType.liveStream);
    final liveStream = json['live_stream'] as Map<String, dynamic>?;

    return base.copyWith(
      contentUrl: json['uuid']?.toString() ??
          liveStream?['stream_url']?.toString() ??
          json['live_stream_url']?.toString() ??
          json['url']?.toString(),
      chatEmbedUrl: liveStream?['chat_embed_url']?.toString(),
      streamStatus: liveStream?['status']?.toString(),
      showRecordedVideo: liveStream?['show_recorded_video'] as bool? ?? false,
    );
  }

  static LessonDto _parseExamLesson(Map<String, dynamic> json, LessonType type) {
    final base = _parseBase(json, type);
    final exam = json['exam'] as Map<String, dynamic>?;

    return base.copyWith(
      attemptsUrl: json['attempts_url'] as String? ?? 
                   exam?['attempts_url'] as String? ??
                   json['start_url'] as String? ??
                   exam?['start_url'] as String?,
      slug: json['slug'] as String? ?? 
            exam?['slug'] as String? ??
            json['exam_slug'] as String?,
    );
  }

  static LessonDto _parseBase(Map<String, dynamic> json, LessonType type) {
    String? getString(String key) => json[key]?.toString();
    final video = json['video'] as Map<String, dynamic>?;
    final liveStream = json['live_stream'] as Map<String, dynamic>?;
    final exam = json['exam'] as Map<String, dynamic>?;

    return LessonDto(
      id: getString('id') ?? getString('object_id') ?? '',
      chapterId: () {
        final val = json['chapter_id'] ?? json['chapter'] ?? json['chapterId'];
        if (val is Map) return val['id']?.toString() ?? '';
        return val?.toString() ?? '';
      }(),
      courseId: () {
        final val = json['course_id'] ?? json['course'] ?? json['courseId'];
        if (val is Map) return val['id']?.toString();
        return val?.toString();
      }(),
      ancestorChapterIds: json['ancestor_chapter_ids']?.toString() ??
          json['ancestorChapterIds']?.toString(),
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      type: type,
      duration: TimeFormatter.formatDuration(
            json['duration']?.toString() ?? 
            video?['duration']?.toString() ??
            liveStream?['duration']?.toString() ??
            exam?['duration']?.toString()) ??
        '',
      progressStatus: _parseStatus(json['state'] ?? json['progressStatus']),
      isLocked: !(json['active'] as bool? ?? json['isLocked'] == false),
      orderIndex: (json['order'] as num?)?.toInt() ?? (json['orderIndex'] as num?)?.toInt() ?? 0,
      chapterTitle: json['chapter_title'] as String? ?? json['chapterTitle'] as String?,
      subtitle: json['subtitle'] as String?,
      subjectName: json['subject_name'] as String? ?? json['subjectName'] as String?,
      subjectIndex: (json['subject_index'] as num?)?.toInt() ?? (json['subjectIndex'] as num?)?.toInt(),
      lessonNumber: (json['lesson_number'] as num?)?.toInt() ?? (json['lessonNumber'] as num?)?.toInt(),
      totalLessons: (json['total_lessons'] as num?)?.toInt() ?? (json['totalLessons'] as num?)?.toInt(),
      bookmarkId: () {
        final val = json['bookmark_id'] ?? json['bookmarkId'];
        if (val is num) return val.toInt();
        if (json['is_bookmarked'] == true || json['isBookmarked'] == true) {
          return 1;
        }
        return null;
      }(),
      image: json['icon'] as String? ?? json['image'] as String?,
      isRunning: json['is_running'] as bool? ?? 
          ['running', 'live'].contains(liveStream?['status']?.toString().toLowerCase()) ||
          (json['has_started'] as bool? ?? false),
      isUpcoming: json['is_upcoming'] as bool? ?? 
          ['upcoming', 'scheduled'].contains(liveStream?['status']?.toString().toLowerCase()),
      hasAttempts: json['has_attempts'] as bool? ?? false,
      pausedAttemptsCount:
          (json['paused_attempts_count'] as num?)?.toInt() ??
          (exam?['paused_attempts_count'] as num?)?.toInt() ??
          0,
      disableAttemptResume:
          json['disable_attempt_resume'] as bool? ??
          exam?['disable_attempt_resume'] as bool? ??
          false,
      allowRetake:
          json['allow_retake'] as bool? ??
          exam?['allow_retake'] as bool? ??
          true,
      maxRetakes:
          (json['max_retakes'] as num?)?.toInt() ??
          (exam?['max_retakes'] as num?)?.toInt() ??
          -1,
      nextContentId: getString('next_content_id'),
      previousContentId: getString('previous_content_id'),
      isDetailFetched: json['is_detail_fetched'] as bool? ?? false,
      isScheduled: json['error_code'] == 'scheduled',
      scheduledMessage: json['message'] as String?,
      description: getString('description'),
      enableTranscript: json['enable_transcript'] as bool? ?? json['enableTranscript'] as bool? ?? false,
      videoSubtitleUrl: () {
        final vs = json['video_subtitle'] ?? json['videoSubtitle'];
        if (vs is Map) {
          final jobStatus = vs['job_status']?.toString();
          if (jobStatus == 'COMPLETED') {
            return vs['url']?.toString();
          }
          return null;
        }
        return vs?.toString();
      }(),
      isAiEnabled: json['is_ai_enabled'] as bool? ?? json['isAiEnabled'] as bool? ?? false,
      aiNotesUrl: json['ai_notes_url']?.toString() ?? json['aiNotesUrl']?.toString(),
    );
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
      'courseId': courseId,
      'ancestorChapterIds': ancestorChapterIds,
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
      'bookmarkId': bookmarkId,
      'isRunning': isRunning,
      'isUpcoming': isUpcoming,
      'hasAttempts': hasAttempts,
      'disableAttemptResume': disableAttemptResume,
      'allowRetake': allowRetake,
      'maxRetakes': maxRetakes,
      'nextContentId': nextContentId,
      'previousContentId': previousContentId,
      'htmlContent': htmlContent,
      'chatEmbedUrl': chatEmbedUrl,
      'streamStatus': streamStatus,
      'showRecordedVideo': showRecordedVideo,
      'description': description,
      'enableTranscript': enableTranscript,
      'videoSubtitleUrl': videoSubtitleUrl,
      'isAiEnabled': isAiEnabled,
      'aiNotesUrl': aiNotesUrl,
    };
  }
}
