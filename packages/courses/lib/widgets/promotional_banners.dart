import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AnnouncementBanner {
  final String id;
  final String title;
  final String description;
  final String? tag;
  final Color bgColor;
  final Color textColor;

  const AnnouncementBanner({
    required this.id,
    required this.title,
    required this.description,
    this.tag,
    required this.bgColor,
    required this.textColor,
  });
}

/// A section for updates and announcements banners.
class PromotionalBanners extends StatelessWidget {
  const PromotionalBanners({super.key, required this.banners});

  final List<AnnouncementBanner> banners;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'UPDATES & ANNOUNCEMENTS',
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ),
                  color: design.colors.textPrimary.withValues(alpha: 0.7),
                ),
                AppText.bodySmall(
                  'View all',
                  color: design.colors.primary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (banners.length > 1)
            _buildCarousel(context)
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              child: _BannerCard(banner: banners.first),
            ),
        ],
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    final design = Design.of(context);
    return SizedBox(
      height: 110,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.88),
        itemCount: banners.length,
        padEnds: false,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: design.spacing.md,
              right: index == banners.length - 1 ? design.spacing.md : 0,
            ),
            child: _BannerCard(banner: banners[index]),
          );
        },
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});
  final AnnouncementBanner banner;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: banner.bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  banner.title,
                  color: banner.textColor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                AppText.bodySmall(
                  banner.description,
                  color: banner.textColor.withValues(alpha: 0.8),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: banner.textColor.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}
