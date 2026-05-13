import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../explore_constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _skeletonPopularTest = PopularTestDto(
  id: 'skeleton',
  title: 'Sample Popular Test Title',
  time: '10:00 AM',
  duration: '45 mins',
  type: PopularTestType.practice,
);

class PopularTestsSection extends StatelessWidget {
  const PopularTestsSection({
    super.key,
    required this.tests,
    this.isLoading = false,
  });

  final List<PopularTestDto> tests;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final isSkeleton = isLoading && tests.isEmpty;
    if (tests.isEmpty && !isSkeleton) return const SizedBox.shrink();

    final displayItems = isSkeleton
        ? List.generate(3, (_) => _skeletonPopularTest)
        : tests;

    return Skeletonizer(
      enabled: isSkeleton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.labelBold(
                  l10n.explorePopularTestsTitle.toUpperCase(),
                  style: const TextStyle(
                    letterSpacing: ExploreConstants.sectionHeaderLetterSpacing,
                  ),
                ),
                if (!isSkeleton)
                  GestureDetector(
                    onTap: () => context.go('/study'),
                    child: AppText.labelBold(
                      l10n.viewAllAction,
                      color: design.colors.textPrimary,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: design.spacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: Row(
              children: [
                for (final test in displayItems)
                  Padding(
                    padding: EdgeInsets.only(right: design.spacing.md),
                    child: _TestCard(test: test),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({required this.test});

  final PopularTestDto test;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return SizedBox(
      width: ExploreConstants.cardWidth,
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: ExploreConstants.cardAspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: design.radius.card.topLeft,
                  topRight: design.radius.card.topRight,
                ),
                child: Container(
                  color: design.colors.surfaceVariant,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (test.thumbnail != null)
                        CachedNetworkImage(
                          imageUrl: test.thumbnail!,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholder: (context, url) => Container(
                            color: design.colors.skeleton,
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              LucideIcons.fileQuestion,
                              size: 32,
                              color: design.colors.textSecondary,
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Icon(
                            LucideIcons.fileQuestion,
                            size: 32,
                            color: design.colors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.cardTitle(
                    test.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: design.spacing.sm),
                  Row(
                    children: [
                      AppBadge(
                        label: test.type == PopularTestType.mock
                            ? l10n.labelMock
                            : l10n.labelPractice,
                        backgroundColor:
                            (test.type == PopularTestType.mock
                                    ? design.colors.primary
                                    : design.colors.success)
                                .withValues(alpha: 0.08),
                        foregroundColor: test.type == PopularTestType.mock
                            ? design.colors.primary
                            : design.colors.success,
                      ),

                      const Spacer(),
                      AppText.bodySmall(
                        test.duration,
                        color: design.colors.textTertiary,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
