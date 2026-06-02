import 'paginated_response_dto.dart';

/// DTO for a single post category, side-loaded from /api/v3/posts/ response.
class PostCategoryDto {
  final int id;
  final String name;
  final int order;
  final String color;
  final String slug;
  final bool isStarred;

  const PostCategoryDto({
    required this.id,
    required this.name,
    required this.order,
    required this.color,
    required this.slug,
    required this.isStarred,
  });

  factory PostCategoryDto.fromJson(Map<String, dynamic> json) {
    return PostCategoryDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      color: json['color'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      isStarred: json['is_starred'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'order': order,
        'color': color,
        'slug': slug,
        'is_starred': isStarred,
      };
}

/// DTO for a single post/announcement from /api/v3/posts/.
class PostDto {
  final int id;
  final String slug;
  final String title;
  final int? categoryId;
  final String? categoryName;
  final String shortLink;
  final String summary;
  final String contentHtml;
  final String? coverImage;
  final String publishedDate;
  final String? webUrl;
  final bool allowComments;

  const PostDto({
    required this.id,
    required this.slug,
    required this.title,
    this.categoryId,
    this.categoryName,
    required this.shortLink,
    required this.summary,
    required this.contentHtml,
    this.coverImage,
    required this.publishedDate,
    this.webUrl,
    required this.allowComments,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      categoryId: (json['category_id'] as num?)?.toInt() ?? (json['category'] is Map ? (json['category']['id'] as num?)?.toInt() : null),
      categoryName: json['category_name'] as String?,
      shortLink: json['short_link'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      contentHtml: json['content_html'] as String? ?? '',
      coverImage: json['cover_image'] as String?,
      publishedDate: json['published_date'] as String? ?? '',
      webUrl: json['web_url'] as String?,
      allowComments: json['allow_comments'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'title': title,
        'category_id': categoryId,
        'category_name': categoryName,
        'short_link': shortLink,
        'summary': summary,
        'content_html': contentHtml,
        'cover_image': coverImage,
        'published_date': publishedDate,
        'web_url': webUrl,
        'allow_comments': allowComments,
      };

  /// Parses the full list API response.
  ///
  /// The `/api/v3/posts/` endpoint returns a nested `results` object containing
  /// both `posts` and `categories`. This method extracts the posts array and maps
  /// it to a standard `PaginatedResponseDto`.
  static PaginatedResponseDto<PostDto> fromListResponse(Map<String, dynamic> response) {
    final count = response['count'] as int? ?? 0;
    final next = response['next'] as String?;
    final previous = response['previous'] as String?;

    final resultsMap = response['results'] as Map<String, dynamic>?;
    final postsJson = resultsMap?['posts'] as List? ?? [];
    
    // Extract side-loaded categories to map category names
    final categoriesJson = resultsMap?['categories'] as List? ?? [];
    final categoryMap = <int, String>{};
    for (final c in categoriesJson) {
      if (c is Map<String, dynamic> && c['id'] != null && c['name'] != null) {
        categoryMap[(c['id'] as num).toInt()] = c['name'] as String;
      }
    }

    final results = postsJson
        .whereType<Map<String, dynamic>>()
        .map((item) {
          // Inject category name before parsing
          final catId = (item['category_id'] as num?)?.toInt();
          if (catId != null && categoryMap.containsKey(catId)) {
            item['category_name'] = categoryMap[catId];
          }
          return PostDto.fromJson(item);
        })
        .toList();

    return PaginatedResponseDto<PostDto>(
      count: count,
      next: next,
      previous: previous,
      results: results,
    );
  }
}

