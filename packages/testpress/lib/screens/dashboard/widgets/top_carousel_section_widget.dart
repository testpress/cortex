import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courses/courses.dart';

class TopCarouselSectionWidget extends ConsumerWidget {
  const TopCarouselSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroBanners = ref.watch(heroBannersProvider);
    final bootstrapState = ref.watch(dashboardBootstrapProvider);

    final showHeroSkeleton =
        bootstrapState.isLoading &&
        (heroBanners.valueOrNull == null || heroBanners.valueOrNull!.isEmpty);

    return HeroBannerCarousel(
      banners: showHeroSkeleton
          ? []
          : (heroBanners.valueOrNull ?? [])
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
    );
  }
}
