class DashboardBannerDto {
  final String id;
  final String imageUrl;
  final String title;
  final String? link;
  final int? bgColor; // ARGB
  final int? textColor; // ARGB
  final String? description;
  final String? tag;

  const DashboardBannerDto({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.link,
    this.bgColor,
    this.textColor,
    this.description,
    this.tag,
  });
}
