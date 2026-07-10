/// DTO for bookmark folders.
class BookmarkFolderDto {
  final int id;
  final String name;
  final int bookmarksCount;
  final int? parentId;
  final int? userId;

  const BookmarkFolderDto({
    required this.id,
    required this.name,
    this.bookmarksCount = 0,
    this.parentId,
    this.userId,
  });

  BookmarkFolderDto copyWith({
    int? id,
    String? name,
    int? bookmarksCount,
    int? parentId,
    int? userId,
  }) {
    return BookmarkFolderDto(
      id: id ?? this.id,
      name: name ?? this.name,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      parentId: parentId ?? this.parentId,
      userId: userId ?? this.userId,
    );
  }

  factory BookmarkFolderDto.fromJson(Map<String, dynamic> json) {
    return BookmarkFolderDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      bookmarksCount:
          (json['bookmarks_count'] as num?)?.toInt() ??
          (json['bookmarksCount'] as num?)?.toInt() ??
          0,
      parentId:
          (json['parent'] as num?)?.toInt() ??
          (json['parentId'] as num?)?.toInt(),
      userId:
          (json['userId'] as num?)?.toInt() ??
          (json['user_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bookmarksCount': bookmarksCount,
      'parentId': parentId,
      'userId': userId,
    };
  }
}

/// DTO for individual bookmarks.
class BookmarkDto {
  final int id;
  final int? folderId;
  final String? folderName;
  final int lessonId;
  final String? bookmarkType;

  // Transient UI fields from side-loaded JSON
  final String title;
  final String chapterName;
  final String type;
  final String? slug; // populated for post-type bookmarks
  final bool isForumPost; // true when post.forum == true
  final DateTime? created;

  final int? attemptId;

  const BookmarkDto({
    required this.id,
    this.folderId,
    this.folderName,
    required this.lessonId,
    this.bookmarkType,
    this.title = '',
    this.chapterName = '',
    this.type = '',
    this.slug,
    this.isForumPost = false,
    this.created,
    this.attemptId,
  });

  BookmarkDto copyWith({
    int? id,
    int? folderId,
    String? folderName,
    int? lessonId,
    String? bookmarkType,
    String? title,
    String? chapterName,
    String? type,
    String? slug,
    bool? isForumPost,
    DateTime? created,
    int? attemptId,
  }) {
    return BookmarkDto(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      lessonId: lessonId ?? this.lessonId,
      bookmarkType: bookmarkType ?? this.bookmarkType,
      title: title ?? this.title,
      chapterName: chapterName ?? this.chapterName,
      type: type ?? this.type,
      slug: slug ?? this.slug,
      isForumPost: isForumPost ?? this.isForumPost,
      created: created ?? this.created,
      attemptId: attemptId ?? this.attemptId,
    );
  }

  factory BookmarkDto.fromJson(Map<String, dynamic> json) {
    return BookmarkDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      folderId:
          (json['folder_id'] as num?)?.toInt() ??
          (json['folderId'] as num?)?.toInt(),
      folderName: json['folder'] as String? ?? json['folderName'] as String?,
      lessonId:
          (json['object_id'] as num?)?.toInt() ??
          (json['lessonId'] as num?)?.toInt() ??
          0,
      bookmarkType:
          json['bookmark_type'] as String? ?? json['bookmarkType'] as String?,
      created: json['created'] != null
          ? DateTime.tryParse(json['created'].toString())
          : null,
      attemptId:
          (json['attempt_id'] as num?)?.toInt() ??
          (json['attemptId'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'folderId': folderId,
      'folderName': folderName,
      'lessonId': lessonId,
      'bookmarkType': bookmarkType,
    };
  }

  /// Parses the v2.4 normalized (side-loaded) JSON response into a list of BookmarkDto.
  static List<BookmarkDto> fromListResponse(Map<String, dynamic> responseJson) {
    final results = responseJson['results'];
    if (results == null || results is! Map<String, dynamic>) {
      return [];
    }

    final bookmarks = results['bookmarks'] as List<dynamic>? ?? [];
    final contentTypesList = results['content_types'] as List<dynamic>? ?? [];
    final chapterContentsList =
        results['chapter_contents'] as List<dynamic>? ?? [];
    final chaptersList = results['chapters'] as List<dynamic>? ?? [];
    final postsList = results['posts'] as List<dynamic>? ?? [];
    final questionsList = results['questions'] as List<dynamic>? ?? [];
    final userSelectedAnswersList =
        results['user_selected_answers'] as List<dynamic>? ?? [];

    // Map content_type_id -> model string (e.g., 57 -> 'chaptercontent', 110 -> 'post')
    final contentTypeMap = <int, String>{};
    for (final ct in contentTypesList) {
      if (ct is Map<String, dynamic>) {
        contentTypeMap[ct['id'] as int] = ct['model'] as String;
      }
    }

    final items = <BookmarkDto>[];

    for (final bookmark in bookmarks) {
      if (bookmark is! Map<String, dynamic>) continue;

      final createdStr = bookmark['created'] as String?;
      final created = createdStr != null ? DateTime.tryParse(createdStr) : null;

      final objectId = (bookmark['object_id'] as num?)?.toInt() ?? 0;
      final contentTypeId = (bookmark['content_type_id'] as num?)?.toInt() ?? 0;
      final modelName = contentTypeMap[contentTypeId];

      String title = 'Unknown';
      String chapterName = '';
      String type = 'Unknown';
      int? lessonIdOverride;

      if (modelName == 'chaptercontent') {
        final content = chapterContentsList.firstWhere(
          (c) => c is Map<String, dynamic> && c['id'] == objectId,
          orElse: () => null,
        );
        if (content != null && content is Map<String, dynamic>) {
          title = content['name'] as String? ?? 'Untitled Lesson';
          type = content['content_type'] as String? ?? 'Lesson';

          final chapterId = content['chapter_id'] as int?;
          if (chapterId != null) {
            final chapter = chaptersList.firstWhere(
              (c) => c is Map<String, dynamic> && c['id'] == chapterId,
              orElse: () => null,
            );
            if (chapter != null && chapter is Map<String, dynamic>) {
              chapterName = chapter['name'] as String? ?? '';
            }
          }
        }
      } else if (modelName == 'post') {
        final post = postsList.firstWhere(
          (p) => p is Map<String, dynamic> && p['id'] == objectId,
          orElse: () => null,
        );
        if (post != null && post is Map<String, dynamic>) {
          title = post['title'] as String? ?? 'Untitled Post';
          final isForum = post['forum'] as bool? ?? false;
          type = isForum ? 'ForumPost' : 'Post';

          items.add(
            BookmarkDto.fromJson(bookmark).copyWith(
              title: title,
              chapterName: '',
              type: type,
              slug: post['slug'] as String?,
              isForumPost: isForum,
              created: created,
            ),
          );
          continue;
        }
      } else if (modelName == 'question') {
        final question = questionsList.firstWhere(
          (q) => q is Map<String, dynamic> && q['id'] == objectId,
          orElse: () => null,
        );
        if (question != null && question is Map<String, dynamic>) {
          title = question['question_html'] as String? ?? 'Question';
          type = 'Question';
        }
      } else if (modelName == 'userselectedanswer') {
        final userAnswer = userSelectedAnswersList.firstWhere(
          (ua) => ua is Map<String, dynamic> && ua['id'] == objectId,
          orElse: () => null,
        );
        if (userAnswer != null && userAnswer is Map<String, dynamic>) {
          final questionId = userAnswer['question_id'] as int?;
          lessonIdOverride = questionId;
          final apiAttemptId = (userAnswer['attempt_id'] as num?)?.toInt();
          if (questionId != null) {
            final question = questionsList.firstWhere(
              (q) => q is Map<String, dynamic> && q['id'] == questionId,
              orElse: () => null,
            );
            if (question != null && question is Map<String, dynamic>) {
              title = question['question_html'] as String? ?? 'Question';
            }
          }
          type = 'Question';
          items.add(
            BookmarkDto.fromJson(bookmark).copyWith(
              title: title,
              chapterName: chapterName,
              type: type,
              lessonId: lessonIdOverride,
              created: created,
              attemptId: apiAttemptId,
            ),
          );
          continue;
        }
      }

      items.add(
        BookmarkDto.fromJson(bookmark).copyWith(
          title: title,
          chapterName: chapterName,
          type: type,
          lessonId: lessonIdOverride,
          created: created,
        ),
      );
    }

    return items;
  }
}
