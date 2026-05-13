import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _skeletonBanner = ExploreBannerDto(
  id: 'skeleton',
  title: 'Loading Banner Headline',
  subtitle: 'Sub-headline for placeholder loading state',
  thumbnail: '',
  ctaText: 'Action',
);

class FeaturedCarousel extends StatelessWidget {
  const FeaturedCarousel({
    super.key,
    required this.banners,
    this.isLoading = false,
  });

  final List<ExploreBannerDto> banners;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isSkeleton = isLoading && banners.isEmpty;
    if (banners.isEmpty && !isSkeleton) return const SizedBox.shrink();

    return Skeletonizer(
      enabled: isSkeleton,
      child: AppCarousel(
        height: 160, // Reduced height
        itemCount: isSkeleton ? 3 : banners.length,
        viewportFraction: 0.92, // Increased width
        itemBuilder: (context, index) {
          final banner = isSkeleton ? _skeletonBanner : banners[index];
          return BannerCard(banner: banner);
        },
      ),
    );
  }
}

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, required this.banner});

  final ExploreBannerDto banner;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: design.radius.card,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CachedNetworkImage(
              imageUrl: banner.thumbnail,
              fit: BoxFit.cover,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholder: (context, url) => Container(
                color: design.colors.skeleton,
              ),
              errorWidget: (context, url, error) => Container(
                color: design.colors.surfaceVariant,
                child: const Center(child: Icon(LucideIcons.image)),
              ),
            ),

            // Gradient Overlay - Stronger on the left for text legibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    design.colors.shadow.withValues(alpha: 0.8),
                    design.colors.shadow.withValues(alpha: 0.4),
                    design.colors.shadow.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                children: [
                  AppText.xl(
                    banner.title,
                    color: design.colors.textInverse,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AppText.bodySmall(
                    banner.subtitle,
                    color: design.colors.textInverse.withValues(alpha: 0.9),
                  ),
                  SizedBox(height: design.spacing.sm),

                  // Compact button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        label: banner.ctaText,
                        height: 34,
                        backgroundColor: design.colors.card,
                        foregroundColor: design.colors.textPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.md,
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        onPressed: () {
                          // Action for banner
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: design.spacing.xs), // Tweak bottom gap
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
