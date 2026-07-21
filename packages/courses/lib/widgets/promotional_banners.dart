import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart'; // To access PostDto

/// A section for updates and announcements on the dashboard.
class UpdatesAnnouncementsSection extends StatelessWidget {
  const UpdatesAnnouncementsSection({
    super.key,
    required this.posts,
    this.title,
    this.onViewAll,
    this.onItemTap,
  });

  final List<PostDto> posts;
  final String? title;
  final VoidCallback? onViewAll;
  final void Function(PostDto)? onItemTap;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final l10n = L10n.of(context);
    final trimmedTitle = title?.trim();
    final displayTitle = (trimmedTitle != null && trimmedTitle.isNotEmpty)
        ? trimmedTitle
        : l10n.updatesAnnouncementsTitle;

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
                  displayTitle,
                  color: design.colors.textPrimary,
                ),
                AppSemantics.button(
                  label: l10n.viewAllAction,
                  onTap: onViewAll,
                  child: GestureDetector(
                    onTap: onViewAll,
                    child: AppText.labelSmall(
                      l10n.viewAllAction,
                      color: design.colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PromotionalBanners(posts: posts, onItemTap: onItemTap),
        ],
      ),
    );
  }
}

/// A generic horizontal list/carousel of announcement banners.
class PromotionalBanners extends StatelessWidget {
  const PromotionalBanners({super.key, required this.posts, this.onItemTap});

  final List<PostDto> posts;
  final void Function(PostDto)? onItemTap;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

    if (posts.length > 1) {
      return _buildCarousel(context);
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
        child: AnnouncementCard(
            post: posts.first,
            index: 0,
            onTap: () => onItemTap?.call(posts.first)),
      );
    }
  }

  Widget _buildCarousel(BuildContext context) {
    final design = Design.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final scale = textScaler.scale(1.0).clamp(1.0, double.infinity);

    return AppCarousel(
      height: 110 * scale,
      showDots: false,
      viewportFraction:
          (320.0 / MediaQuery.sizeOf(context).width).clamp(0.30, 0.85),
      padEnds: false,
      itemCount: posts.length,
      itemPadding: EdgeInsets.only(left: design.spacing.md),
      itemBuilder: (context, index) {
        return AnnouncementCard(
            post: posts[index],
            index: index,
            onTap: () => onItemTap?.call(posts[index]));
      },
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard(
      {super.key, required this.post, this.index = 0, this.onTap});
  final PostDto post;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Create a deterministic color palette based on item index using design tokens
    final colors = [
      (
        bg: design.colors.success.withValues(alpha: 0.1),
        text: design.colors.success
      ), // Green
      (
        bg: design.colors.primary.withValues(alpha: 0.1),
        text: design.colors.primary
      ), // Purple
      (
        bg: design.colors.warning.withValues(alpha: 0.1),
        text: design.colors.warning
      ), // Amber
    ];
    final colorScheme = colors[index % colors.length];

    return AppSemantics.button(
      label: post.title,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: colorScheme.bg,
            borderRadius: design.radius.card,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText.body(
                      post.title,
                      color: colorScheme.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    AppText.bodySmall(
                      post.summary.replaceAll(RegExp(r'[\r\n]+'), ' ').trim(),
                      color: colorScheme.text.withValues(alpha: 0.8),
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
                color: colorScheme.text.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
