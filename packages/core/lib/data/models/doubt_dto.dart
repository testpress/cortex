/// Doubt status for private mentoring threads.
enum DoubtStatus { pending, answered, resolved }

/// DTO for a personal doubt asked by a student.
class DoubtDto {
  final String id;
  final String? courseId;
  final String? courseName;
  final String? lessonId;
  final String title;
  final String content; // Quill Delta JSON
  final String studentName;
  final String? studentAvatar;
  final String timeAgo;
  final int replyCount;
  final DoubtStatus status;
  final List<String> attachmentUrls;
  final DateTime createdAt;

  const DoubtDto({
    required this.id,
    this.courseId,
    this.courseName,
    this.lessonId,
    required this.title,
    required this.content,
    required this.studentName,
    this.studentAvatar,
    required this.timeAgo,
    required this.replyCount,
    required this.status,
    this.attachmentUrls = const [],
    required this.createdAt,
  });
}

/// DTO for a reply in a doubt thread.
class DoubtReplyDto {
  final String id;
  final String doubtId;
  final String content; // Quill Delta JSON
  final String authorName;
  final String? authorAvatar;
  final bool isMentor;
  final String timeAgo;
  final DateTime createdAt;
  final List<String> attachmentUrls;

  const DoubtReplyDto({
    required this.id,
    required this.doubtId,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.isMentor,
    required this.timeAgo,
    required this.createdAt,
    this.attachmentUrls = const [],
  });
}
