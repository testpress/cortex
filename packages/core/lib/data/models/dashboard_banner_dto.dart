class DashboardBannerDto {
  final String id;
  final String imageUrl;
  final String? title;
  final String? link;
  final int? bgColor; // ARGB
  final int? textColor; // ARGB
  final String? description;
  final String? tag;

  const DashboardBannerDto({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
    this.bgColor,
    this.textColor,
    this.description,
    this.tag,
  });

  factory DashboardBannerDto.fromJson(Map<String, dynamic> json) {
    return DashboardBannerDto(
      id: json['id']?.toString() ?? '',
      imageUrl: json['image'] as String? ?? '',
      title: json['title'] as String?,
      link: json['url'] as String?,
      description: json['description'] as String?,
      bgColor: json['bgColor'] as int?,
      textColor: json['textColor'] as int?,
      tag: json['tag'] as String?,
    );
  }
}
