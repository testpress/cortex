import 'paginated_response_dto.dart';

/// Doubt status for private mentoring threads.
enum DoubtStatus { active, pending, resolved, closed }

/// Target destination for a doubt query.
enum DoubtQueryType { mentor, ai }

/// DTO for a personal doubt asked by a student.
class DoubtDto {
  final String id;
  final int? topicId;
  final String? topicName;
  final String? lessonId;
  final String title;
  final String content; // Quill Delta JSON
  final String studentName;
  final String? studentAvatar;
  final DoubtStatus status;
  final List<String> attachmentUrls;
  final DateTime createdAt;
  /// Human-readable relative time from the API (e.g. "4 days, 1 hour ago").
  /// Null when loaded from local cache — use [DateFormatter.formatTimeAgo] as fallback.
  final String? createdHumanized;
  /// Kept for local tracking (e.g. incremented on reply). Not returned by the list API.
  final int? replyCount;

  const DoubtDto({
    required this.id,
    this.topicId,
    this.topicName,
    this.lessonId,
    required this.title,
    required this.content,
    required this.studentName,
    this.studentAvatar,
    required this.status,
    this.attachmentUrls = const [],
    required this.createdAt,
    this.createdHumanized,
    this.replyCount,
  });

  factory DoubtDto.fromJson(Map<String, dynamic> json, {List<dynamic>? topicsList}) {
    // Parse reporter info — already a full user object at this point.
    String studentName = 'Student';
    String? studentAvatar;
    final reportedByVal = json['reported_by'];
    if (reportedByVal is Map<String, dynamic>) {
      studentName = reportedByVal['display_name'] as String? ?? 'Student';
      studentAvatar = reportedByVal['photo'] as String? ?? reportedByVal['medium_image'] as String?;
    }

    // Parse topic (course/category).
    int? topicId;
    String? topicName;
    final topicVal = json['topic'];
    if (topicVal is Map<String, dynamic>) {
      topicId = topicVal['id'] as int?;
      topicName = topicVal['title'] as String?;
    } else if (topicVal is int) {
      topicId = topicVal;
      // Look up topic name from the provided list if available
      if (topicsList != null) {
        final found = topicsList.whereType<Map<String, dynamic>>().where((t) => t['id'] == topicId).firstOrNull;
        if (found != null) {
          topicName = found['title'] as String?;
        }
      }
    }

    const statusMap = {
      'active': DoubtStatus.active,
      'pending': DoubtStatus.pending,
      'resolved': DoubtStatus.resolved,
      'closed': DoubtStatus.closed,
    };
    final status = statusMap[(json['status'] as String? ?? '').toLowerCase()] ?? DoubtStatus.active;

    return DoubtDto(
      id: json['id'].toString(),
      topicId: topicId,
      topicName: topicName,
      lessonId: json['chapter_content']?.toString(),
      title: json['title'] as String? ?? '',
      content: json['description'] as String? ?? '',
      studentName: studentName,
      studentAvatar: studentAvatar,
      status: status,
      createdAt: json['created'] != null
          ? DateTime.tryParse(json['created'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdHumanized: json['created_humanize'] as String?,
    );
  }

  /// Parses a [DoubtDto] from the single-ticket detail API response.
  ///
  /// The detail endpoint returns the ticket as the root JSON object — this is
  /// a convenience alias since the field shapes match [fromJson].
  factory DoubtDto.fromDetailJson(Map<String, dynamic> json) => DoubtDto.fromJson(json);

  /// Parses the full list API response.
  ///
  /// The list endpoint returns tickets with [reported_by] as a bare int ID,
  /// and a separate [reportees] array of full user objects. This method
  /// joins them before delegating to [fromJson].
  static PaginatedResponseDto<DoubtDto> fromListResponse(Map<String, dynamic> response) {
    final count = response['count'] as int? ?? 0;
    final next = response['next'] as String?;
    final previous = response['previous'] as String?;

    final resultsMap = response['results'] as Map<String, dynamic>?;
    final ticketsJson = resultsMap?['tickets'] as List? ?? [];
    final reporteesJson = resultsMap?['reportees'] as List? ?? [];

    // Build a lookup: reportee id → full user object.
    final reportees = <int, Map<String, dynamic>>{};
    for (final item in reporteesJson) {
      if (item is Map<String, dynamic> && item['id'] is int) {
        reportees[item['id'] as int] = item;
      }
    }

    final topicsJson = resultsMap?['topics'] as List<dynamic>?;

    final results = ticketsJson.whereType<Map<String, dynamic>>().map((ticket) {
      final reportedBy = ticket['reported_by'];
      if (reportedBy is int && reportees.containsKey(reportedBy)) {
        return DoubtDto.fromJson({...ticket, 'reported_by': reportees[reportedBy]}, topicsList: topicsJson);
      }
      return DoubtDto.fromJson(ticket, topicsList: topicsJson);
    }).toList();

    return PaginatedResponseDto<DoubtDto>(
      count: count,
      next: next,
      previous: previous,
      results: results,
    );
  }
}


/// DTO for a reply in a doubt thread.
class DoubtReplyDto {
  final String id;
  final String doubtId;
  final String content; // Quill Delta JSON or HTML comment
  final String authorName;
  final String? authorAvatar;
  final bool isMentor;
  final DateTime createdAt;
  final String? createdHumanized;
  final List<String> attachmentUrls;

  const DoubtReplyDto({
    required this.id,
    required this.doubtId,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.isMentor,
    required this.createdAt,
    this.createdHumanized,
    this.attachmentUrls = const [],
  });

  factory DoubtReplyDto.fromJson(
    Map<String, dynamic> json,
    String doubtId, {
    String? reportedById,
  }) {
    final userMap = json['user'] as Map<String, dynamic>?;
    final authorName = userMap?['display_name'] as String? ?? 'User';
    final authorAvatar = userMap?['photo'] as String? ?? userMap?['medium_image'] as String?;
    // A follow-up is a mentor reply if the author differs from the student who raised the doubt.
    final authorId = userMap?['id']?.toString();
    final isMentor = reportedById != null ? authorId != reportedById : false;

    return DoubtReplyDto(
      id: json['id'].toString(),
      doubtId: doubtId,
      content: json['comment'] as String? ?? '',
      authorName: authorName,
      authorAvatar: authorAvatar,
      isMentor: isMentor,
      createdAt: json['created'] != null
          ? DateTime.tryParse(json['created'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdHumanized: json['created_humanize'] as String?,
      attachmentUrls: const [],
    );
  }

  /// Parses the full detail API response into a list of replies.
  ///
  /// The detail endpoint returns [reported_by] (the student) and [follow_ups]
  /// (the replies). [reported_by] is used to determine [isMentor] per reply.
  static List<DoubtReplyDto> fromDetailResponse(
    Map<String, dynamic> response,
    String doubtId,
  ) {
    final reportedBy = response['reported_by'];
    final reportedById = reportedBy is Map<String, dynamic>
        ? reportedBy['id']?.toString()
        : reportedBy?.toString();

    final followUpsJson = response['follow_ups'] as List<dynamic>? ?? [];
    return followUpsJson
        .whereType<Map<String, dynamic>>()
        .map((item) => DoubtReplyDto.fromJson(item, doubtId, reportedById: reportedById))
        .toList();
  }
}


/// DTO for a hierarchical doubt topic (category).
class DoubtTopicDto {
  final int id;
  final String title;
  final int? parentId;
  final bool hasChildren;

  const DoubtTopicDto({
    required this.id,
    required this.title,
    this.parentId,
    required this.hasChildren,
  });

  factory DoubtTopicDto.fromJson(Map<String, dynamic> json) {
    return DoubtTopicDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      parentId: json['parent'] as int? ?? json['parent_id'] as int?,
      hasChildren: json['has_children'] as bool? ?? false,
    );
  }

  /// Parses either a plain list or a paginated [results] response.
  static List<DoubtTopicDto> fromListResponse(dynamic data) {
    final list = data is List ? data : (data['results'] as List? ?? []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(DoubtTopicDto.fromJson)
        .toList();
  }
}
