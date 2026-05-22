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
      bookmarksCount: (json['bookmarks_count'] as num?)?.toInt() ??
          (json['bookmarksCount'] as num?)?.toInt() ??
          0,
      parentId: (json['parent'] as num?)?.toInt() ??
          (json['parentId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt() ??
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

  const BookmarkDto({
    required this.id,
    this.folderId,
    this.folderName,
    required this.lessonId,
    this.bookmarkType,
  });

  BookmarkDto copyWith({
    int? id,
    int? folderId,
    String? folderName,
    int? lessonId,
    String? bookmarkType,
  }) {
    return BookmarkDto(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      lessonId: lessonId ?? this.lessonId,
      bookmarkType: bookmarkType ?? this.bookmarkType,
    );
  }

  factory BookmarkDto.fromJson(Map<String, dynamic> json) {
    return BookmarkDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      folderId: (json['folder_id'] as num?)?.toInt() ??
          (json['folderId'] as num?)?.toInt(),
      folderName: json['folder'] as String? ?? json['folderName'] as String?,
      lessonId: (json['object_id'] as num?)?.toInt() ??
          (json['lessonId'] as num?)?.toInt() ??
          0,
      bookmarkType: json['bookmark_type'] as String? ?? json['bookmarkType'] as String?,
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
}
