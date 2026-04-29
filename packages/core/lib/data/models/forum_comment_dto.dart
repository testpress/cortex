
/// Forum comment DTO — a reply to a discussion thread.
class ForumCommentDto {
  final String id;
  final String threadId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String timeAgo;
  final int upvotes;
  final int downvotes;
  final bool isInstructor;

  const ForumCommentDto({
    required this.id,
    required this.threadId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.timeAgo,
    this.upvotes = 0,
    this.downvotes = 0,
    this.isInstructor = false,
  });

  int get score => upvotes - downvotes;
}
