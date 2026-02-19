/// Forum thread status.
enum ForumThreadStatus { answered, unanswered }

/// Forum thread DTO — a question posted in the discussion forum.
class ForumThreadDto {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String studentName;
  final String timeAgo;
  final int replyCount;
  final ForumThreadStatus status;

  const ForumThreadDto({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.studentName,
    required this.timeAgo,
    required this.replyCount,
    required this.status,
  });
}
