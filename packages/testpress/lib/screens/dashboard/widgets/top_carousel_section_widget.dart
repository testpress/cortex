import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';

class TopCarouselSectionWidget extends ConsumerWidget {
  const TopCarouselSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final heroBanners = ref.watch(heroBannersProvider);
    final bootstrapState = ref.watch(dashboardBootstrapProvider);

    final showHeroSkeleton =
        bootstrapState.isLoading &&
        (heroBanners.valueOrNull == null || heroBanners.valueOrNull!.isEmpty);

    final banners = heroBanners.valueOrNull ?? [];

    if (banners.isEmpty && !showHeroSkeleton) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: HeroBannerCarousel(
        banners: showHeroSkeleton
            ? []
            : banners
                  .map(
                    (d) => HeroBanner(
                      id: d.id,
                      imageUrl: d.imageUrl,
                      title: d.title ?? '',
                      link: d.link ?? '#',
                    ),
                  )
                  .toList(),
        isLoading: showHeroSkeleton,
      ),
    );
  }
}
