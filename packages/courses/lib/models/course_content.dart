import 'package:core/data/data.dart' show LessonType, LessonProgressStatus, LessonDto;

export 'package:core/data/data.dart' show LessonType, LessonProgressStatus, LessonDto;

/// Domain model for a specific content item within a chapter.
class Lesson {
  const Lesson({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.type,
    required this.progressStatus,
    required this.orderIndex,
    this.duration,
    this.isLocked = false,
    this.subtitle,
    this.subjectName,
    this.subjectIndex,
    this.lessonNumber,
    this.totalLessons,
    this.isBookmarked = false,
    this.isRunning = false,
    this.isUpcoming = false,
    this.hasAttempts = false,
    this.contentUrl,
    this.image,
    this.attemptsUrl,
    this.slug,
    this.nextContentId,
    this.previousContentId,
    this.htmlContent,
    this.isDetailFetched = false,
    this.chatEmbedUrl,
    this.streamStatus,
    this.showRecordedVideo = false,
    this.isScheduled = false,
    this.scheduledMessage,
  });

  final String id;
  final String chapterId;
  final String title;
  final LessonType type;
  final LessonProgressStatus progressStatus;
  final int orderIndex;
  final String? duration;
  final bool isLocked;
  final bool isBookmarked;
  final bool isDetailFetched;

  // New fields for LessonDetailScreen (Phase-2)
  final String? subtitle;
  final String? subjectName;
  final int? subjectIndex;
  final int? lessonNumber;
  final int? totalLessons;
  final String? contentUrl;
  final bool isRunning;
  final bool isUpcoming;
  final bool hasAttempts;
  final String? image;
  final String? attemptsUrl;
  final String? slug;

  // New fields for LessonDetailShell (v2.4+)
  final String? nextContentId;
  final String? previousContentId;
  final String? htmlContent;

  // Live Stream specific fields
  final String? chatEmbedUrl;
  final String? streamStatus;
  final bool showRecordedVideo;
  final bool isScheduled;
  final String? scheduledMessage;
 
  /// Checks if the lesson has enough metadata to be rendered without a specialized loader.
  bool get isComplete {
    if (isDetailFetched) return true;
    if (isScheduled) return true;
 
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

  /// Converts this domain model to a [LessonDto] for cross-package use.
  LessonDto toDto() {
    return LessonDto(
      id: id,
      chapterId: chapterId,
      title: title,
      type: type,
      progressStatus: progressStatus,
      duration: duration ?? '',
      isLocked: isLocked,
      orderIndex: orderIndex,
      subtitle: subtitle,
      subjectName: subjectName,
      subjectIndex: subjectIndex,
      lessonNumber: lessonNumber,
      totalLessons: totalLessons,
      contentUrl: contentUrl,
      isBookmarked: isBookmarked,
      isRunning: isRunning,
      isUpcoming: isUpcoming,
      hasAttempts: hasAttempts,
      image: image,
      attemptsUrl: attemptsUrl,
      slug: slug,
      nextContentId: nextContentId,
      previousContentId: previousContentId,
      htmlContent: htmlContent,
      isDetailFetched: isDetailFetched,
      chatEmbedUrl: chatEmbedUrl,
      streamStatus: streamStatus,
      showRecordedVideo: showRecordedVideo,
      isScheduled: isScheduled,
      scheduledMessage: scheduledMessage,
    );
  }
}

/// Domain model for a chapter within a course.
class Chapter {
  const Chapter({
    required this.id,
    required this.title,
    required this.lessonCount,
    required this.assessmentCount,
    this.courseTitle,
    this.image,
    this.lessons = const [],
  });

  final String id;
  final String title;
  final int lessonCount;
  final int assessmentCount;
  final String? courseTitle;
  final String? image;
  final List<Lesson> lessons;
}
