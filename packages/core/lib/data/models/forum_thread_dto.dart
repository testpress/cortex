/// Forum thread status.
enum ForumThreadStatus { answered, unanswered }

/// Forum category DTO — maps to `/api/v2.3/forum/categories/`.
class ForumCategoryDto {
  final int id;
  final String name;
  final String slug;
  final String? color;
  final int? order;

  const ForumCategoryDto({
    required this.id,
    required this.name,
    required this.slug,
    this.color,
    this.order,
  });

  factory ForumCategoryDto.fromJson(Map<String, dynamic> json) =>
      ForumCategoryDto(
        id: _asInt(json['id']) ?? 0,
        name: _asString(json['name']) ?? 'General',
        slug: _asString(json['slug']) ?? 'general',
        color: _asString(json['color']),
        order: _asInt(json['order']),
      );

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
}

/// Forum thread DTO — a question posted in the discussion forum.
class ForumThreadDto {
  final int threadId;
  final String slug;
  final String? courseId;
  final int? categoryId;
  final String? categorySlug;
  final ForumCategoryDto? category;
  final String title;
  final String summary;
  final String? contentHtml;
  final String authorName;
  final String? authorAvatar;
  final String createdAt;
  final int replyCount;
  final int upvotes;
  final int downvotes;
  final ForumThreadStatus status;
  final String? imageUrl;

  const ForumThreadDto({
    required this.threadId,
    required this.slug,
    this.courseId,
    this.categoryId,
    this.categorySlug,
    this.category,
    required this.title,
    required this.summary,
    this.contentHtml,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
    required this.replyCount,
    this.upvotes = 0,
    this.downvotes = 0,
    required this.status,
    this.imageUrl,
  });

  int get score => upvotes - downvotes;

  String get id => slug;

  factory ForumThreadDto.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['created_by'] is Map<String, dynamic>
              ? json['created_by'] as Map<String, dynamic>
              : null);
    final categoryJson = json['category'] is Map<String, dynamic>
        ? json['category'] as Map<String, dynamic>
        : null;
    final parsedCategory = categoryJson != null
        ? ForumCategoryDto.fromJson(categoryJson)
        : null;
    final hasAnswer = json['has_answer'] == true;

    return ForumThreadDto(
      threadId: _asInt(json['id']) ?? 0,
      slug: _asString(json['slug']) ?? _asString(json['id']) ?? '',
      courseId: json['course']?.toString(),
      categoryId: _asInt(json['category_id']) ?? _asInt(categoryJson?['id']),
      categorySlug: _asString(json['category_slug']) ?? _asString(categoryJson?['slug']),
      category: parsedCategory,
      title: _asString(json['title']) ?? 'Untitled',
      summary: _asString(json['summary']) ?? _asString(json['description']) ?? '',
      contentHtml: _asString(json['content_html']) ?? _asString(json['description_html']),
      authorName: _asString(json['author_name']) ?? _asString(user?['display_name']) ?? 'Anonymous',
      authorAvatar: _asString(json['author_avatar']) ?? _asString(user?['photo']),
      createdAt: _asString(json['time_ago']) ?? _asString(json['created']) ?? '',
      replyCount: _asInt(json['reply_count']) ?? _asInt(json['comments_count']) ?? 0,
      upvotes: _asInt(json['upvotes']) ?? 0,
      downvotes: _asInt(json['downvotes']) ?? 0,
      status: json['status'] == 'answered' || hasAnswer
          ? ForumThreadStatus.answered
          : ForumThreadStatus.unanswered,
      imageUrl: _asString(json['image_url']),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
}

/// Forum comment DTO — a reply to a discussion thread.
class ForumCommentDto {
  final String id;
  final int threadId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String createdAt;
  final int upvotes;
  final int downvotes;
  final bool isInstructor;

  const ForumCommentDto({
    required this.id,
    required this.threadId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
    this.isInstructor = false,
  });

  int get score => upvotes - downvotes;

  factory ForumCommentDto.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final contentObj = json['content_object'] as Map<String, dynamic>?;
    return ForumCommentDto(
      id: json['id']?.toString() ?? '',
      threadId: _asInt(json['thread']) ?? _asInt(contentObj?['id']) ?? 0,
      authorName: _asString(json['author_name']) ?? _asString(user?['display_name']) ?? 'Anonymous',
      authorAvatar: _asString(json['author_avatar']) ?? _asString(user?['photo']),
      content: _asString(json['content']) ?? _asString(json['comment']) ?? '',
      createdAt: _asString(json['time_ago']) ?? _asString(json['created']) ?? '',
      upvotes: _asInt(json['upvotes']) ?? 0,
      downvotes: _asInt(json['downvotes']) ?? 0,
      isInstructor: json['is_instructor'] == true,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
}
