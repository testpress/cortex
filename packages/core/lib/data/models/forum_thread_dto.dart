/// Forum thread status.
enum ForumThreadStatus { answered, unanswered }

/// Forum thread DTO — a question posted in the discussion forum.
class ForumThreadDto {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String authorName;
  final String? authorAvatar;
  final String timeAgo;
  final int replyCount;
  final int upvotes;
  final int downvotes;
  final ForumThreadStatus status;
  final String? imageUrl;

  const ForumThreadDto({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.authorName,
    this.authorAvatar,
    required this.timeAgo,
    required this.replyCount,
    this.upvotes = 0,
    this.downvotes = 0,
    required this.status,
    this.imageUrl,
  });

  int get score => upvotes - downvotes;
}
