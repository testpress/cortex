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

/// A section for updates and announcements on the dashboard.
class UpdatesAnnouncementsSection extends StatelessWidget {
  const UpdatesAnnouncementsSection({
    super.key,
    required this.banners,
    this.onViewAll,
  });

  final List<AnnouncementBanner> banners;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

    final l10n = L10n.of(context);

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
                AppText.title(
                  l10n.updatesAnnouncementsTitle,
                  color: design.colors.textPrimary,
                ),
                GestureDetector(
                  onTap: onViewAll,
                  child: AppText.labelSmall(
                    l10n.viewAllAction,
                    color: design.colors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PromotionalBanners(banners: banners),
        ],
      ),
    );
  }
}

/// A generic horizontal list/carousel of announcement banners.
class PromotionalBanners extends StatelessWidget {
  const PromotionalBanners({super.key, required this.banners});

  final List<AnnouncementBanner> banners;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

    if (banners.length > 1) {
      return _buildCarousel(context);
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
        child: _BannerCard(banner: banners.first),
      );
    }
  }

  Widget _buildCarousel(BuildContext context) {
    final design = Design.of(context);
    return AppCarousel(
      height: 110,
      showDots: false,
      viewportFraction: 0.88,
      padEnds: false,
      itemCount: banners.length,
      itemPadding: EdgeInsets.only(left: design.spacing.md),
      itemBuilder: (context, index) {
        return _BannerCard(banner: banners[index]);
      },
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
        boxShadow: [
          BoxShadow(
            color: design.colors.border.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                AppText.body(
                  banner.title,
                  color: banner.textColor,
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
