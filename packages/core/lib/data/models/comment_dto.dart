import 'package:flutter/foundation.dart';

/// DTO for the author of a comment.
@immutable
class CommentUserDto {
  final int id;
  final String username;
  final String displayName;
  final String? photo;
  final String? mediumImage;
  final String? smallImage;

  const CommentUserDto({
    required this.id,
    required this.username,
    required this.displayName,
    this.photo,
    this.mediumImage,
    this.smallImage,
  });

  factory CommentUserDto.fromJson(Map<String, dynamic> json) {
    return CommentUserDto(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username']?.toString() ?? '',
      displayName:
          json['display_name']?.toString() ??
          json['username']?.toString() ??
          '',
      photo: json['photo']?.toString(),
      mediumImage: json['medium_image']?.toString(),
      smallImage: json['small_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'photo': photo,
      'medium_image': mediumImage,
      'small_image': smallImage,
    };
  }

  CommentUserDto copyWith({
    int? id,
    String? username,
    String? displayName,
    String? photo,
    String? mediumImage,
    String? smallImage,
  }) {
    return CommentUserDto(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photo: photo ?? this.photo,
      mediumImage: mediumImage ?? this.mediumImage,
      smallImage: smallImage ?? this.smallImage,
    );
  }
}

/// DTO for a lesson/content comment item.
@immutable
class CommentDto {
  final int id;
  final String url;
  final CommentUserDto user;
  final int? parentId;
  final String comment;
  final int? contentObjectId;
  final String? contentObjectTitle;
  final DateTime? created;
  final DateTime? modified;
  final DateTime? submitDate;
  final bool acceptedAnswer;
  final bool isPublic;
  final bool isReportedByUser;
  final bool isReportedCommentApproved;
  final List<CommentDto>? children;

  const CommentDto({
    required this.id,
    required this.url,
    required this.user,
    this.parentId,
    required this.comment,
    this.contentObjectId,
    this.contentObjectTitle,
    this.created,
    this.modified,
    this.submitDate,
    this.acceptedAnswer = false,
    this.isPublic = true,
    this.isReportedByUser = false,
    this.isReportedCommentApproved = false,
    this.children = const [],
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    final rawUser = json['user'];
    final user = rawUser is Map<String, dynamic>
        ? CommentUserDto.fromJson(rawUser)
        : CommentUserDto(
            id: json['user_id'] is int ? json['user_id'] as int : 0,
            username: json['user_name']?.toString() ?? '',
            displayName: json['user_name']?.toString() ?? '',
          );

    final rawContentObject = json['content_object'];
    int? contentId;
    String? contentTitle;
    if (rawContentObject is Map<String, dynamic>) {
      contentId = rawContentObject['id'] is int
          ? rawContentObject['id'] as int
          : int.tryParse(rawContentObject['id']?.toString() ?? '');
      contentTitle = rawContentObject['title']?.toString();
    }

    return CommentDto(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      url: json['url']?.toString() ?? '',
      user: user,
      parentId: json['parent_id'] is int
          ? json['parent_id'] as int
          : int.tryParse(json['parent_id']?.toString() ?? ''),
      comment: json['comment']?.toString() ?? '',
      contentObjectId: contentId,
      contentObjectTitle: contentTitle,
      created: _parseDateTime(json['created']),
      modified: _parseDateTime(json['modified']),
      submitDate: _parseDateTime(json['submit_date']),
      acceptedAnswer: json['accepted_answer'] as bool? ?? false,
      isPublic: json['is_public'] as bool? ?? true,
      isReportedByUser: json['is_reported_by_user'] as bool? ?? false,
      isReportedCommentApproved:
          json['is_reported_comment_approved'] as bool? ?? false,
      children: const [],
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'user': user.toJson(),
      'parent_id': parentId,
      'comment': comment,
      'content_object': {
        if (contentObjectId != null) 'id': contentObjectId,
        if (contentObjectTitle != null) 'title': contentObjectTitle,
      },
      'created': created?.toIso8601String(),
      'modified': modified?.toIso8601String(),
      'submit_date': submitDate?.toIso8601String(),
      'accepted_answer': acceptedAnswer,
      'is_public': isPublic,
      'is_reported_by_user': isReportedByUser,
      'is_reported_comment_approved': isReportedCommentApproved,
    };
  }

  CommentDto copyWith({
    int? id,
    String? url,
    CommentUserDto? user,
    int? parentId,
    String? comment,
    int? contentObjectId,
    String? contentObjectTitle,
    DateTime? created,
    DateTime? modified,
    DateTime? submitDate,
    bool? acceptedAnswer,
    bool? isPublic,
    bool? isReportedByUser,
    bool? isReportedCommentApproved,
    List<CommentDto>? children,
  }) {
    return CommentDto(
      id: id ?? this.id,
      url: url ?? this.url,
      user: user ?? this.user,
      parentId: parentId ?? this.parentId,
      comment: comment ?? this.comment,
      contentObjectId: contentObjectId ?? this.contentObjectId,
      contentObjectTitle: contentObjectTitle ?? this.contentObjectTitle,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      submitDate: submitDate ?? this.submitDate,
      acceptedAnswer: acceptedAnswer ?? this.acceptedAnswer,
      isPublic: isPublic ?? this.isPublic,
      isReportedByUser: isReportedByUser ?? this.isReportedByUser,
      isReportedCommentApproved:
          isReportedCommentApproved ?? this.isReportedCommentApproved,
      children: children ?? this.children,
    );
  }
}

/// Builds a hierarchical comment tree from a flat list of comments by grouping
/// children under their respective `parent_id`.
List<CommentDto> buildCommentTree(List<CommentDto> flatComments) {
  final commentMap = <int, CommentDto>{};
  final rootComments = <CommentDto>[];

  // 1. Index every comment with an empty mutable children list
  for (final comment in flatComments) {
    commentMap[comment.id] = comment.copyWith(children: []);
  }

  // 2. Attach children to parents or place into roots
  for (final comment in flatComments) {
    final current = commentMap[comment.id]!;
    final parentId = comment.parentId;
    if (parentId != null && commentMap.containsKey(parentId)) {
      final parent = commentMap[parentId]!;
      final updatedChildren = List<CommentDto>.from(parent.children ?? [])
        ..add(current);
      commentMap[parentId] = parent.copyWith(children: updatedChildren);
    } else {
      rootComments.add(current);
    }
  }

  // Return roots with their resolved children
  return rootComments.map((root) => _resolveNode(root, commentMap)).toList();
}

CommentDto _resolveNode(CommentDto node, Map<int, CommentDto> map) {
  final latestFromMap = map[node.id] ?? node;
  final resolvedChildren = (latestFromMap.children ?? [])
      .map((child) => _resolveNode(child, map))
      .toList();
  return latestFromMap.copyWith(children: resolvedChildren);
}
