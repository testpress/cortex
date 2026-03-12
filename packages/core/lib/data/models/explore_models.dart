/// DTO for featured banners on the Explore page.
class ExploreBannerDto {
  final String id;
  final String title;
  final String subtitle;
  final String thumbnail;
  final String ctaText;

  const ExploreBannerDto({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.ctaText,
  });

  factory ExploreBannerDto.fromJson(Map<String, dynamic> json) {
    return ExploreBannerDto(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      thumbnail: json['thumbnail'] as String,
      ctaText: json['ctaText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'thumbnail': thumbnail,
      'ctaText': ctaText,
    };
  }
}

/// DTO for study tips / blog posts.
class StudyTipDto {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String? tag;
  final int? colorIndex; // Maps to design palette

  const StudyTipDto({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    this.tag,
    this.colorIndex,
  });

  factory StudyTipDto.fromJson(Map<String, dynamic> json) {
    return StudyTipDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      tag: json['tag'] as String?,
      colorIndex: json['colorIndex'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'tag': tag,
      'colorIndex': colorIndex,
    };
  }
}

/// DTO for short lessons (micro-learning).
class ShortLessonDto {
  final String id;
  final String title;
  final String duration;
  final String thumbnail;
  final String author;
  final String viewCount;
  final bool isNew;

  const ShortLessonDto({
    required this.id,
    required this.title,
    required this.duration,
    required this.thumbnail,
    required this.author,
    required this.viewCount,
    this.isNew = false,
  });

  factory ShortLessonDto.fromJson(Map<String, dynamic> json) {
    return ShortLessonDto(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      thumbnail: json['thumbnail'] as String,
      author: json['author'] as String? ?? 'Expert Faculty',
      viewCount: json['viewCount'] as String? ?? '0 views',
      isNew: json['isNew'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'thumbnail': thumbnail,
      'author': author,
      'viewCount': viewCount,
      'isNew': isNew,
    };
  }
}

/// DTO for courses listed on the Explore page.
class DiscoveryCourseDto {
  final String id;
  final String title;
  final String thumbnail;
  final String duration;
  final String learnerCount;
  final String price;
  final String? badge;

  const DiscoveryCourseDto({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.learnerCount,
    required this.price,
    this.badge,
  });

  factory DiscoveryCourseDto.fromJson(Map<String, dynamic> json) {
    return DiscoveryCourseDto(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      duration: json['duration'] as String,
      learnerCount: json['learnerCount'] as String,
      price: json['price'] as String,
      badge: json['badge'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'duration': duration,
      'learnerCount': learnerCount,
      'price': price,
      'badge': badge,
    };
  }
}
