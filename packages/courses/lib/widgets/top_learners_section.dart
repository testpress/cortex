import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../screens/leaderboard/top_learners_screen.dart';
import 'leaderboard/leaderboard_list_item.dart';

/// A section showing top-performing students on the dashboard.
const _dummyLearner = LearnerDto(
  id: 'skeleton',
  rank: 1,
  name: 'Student Name',
  avatar: '',
  points: 1200,
);

const double _kCarouselHeight = 200;
const double _kCurveHeight = 114;
// Chosen so name text falls just below the curved background section.
const double _kAvatarTextSpacing = 39;
const double _kSmallBadgeSize = 24;
const double _kLargeBadgeSize = 28;

class TopLearnersSection extends StatelessWidget {
  const TopLearnersSection({
    super.key,
    required this.topLearners,
    required this.otherLearners,
    this.isLoading = false,
  });

  final List<LearnerDto> topLearners;
  final List<LearnerDto> otherLearners;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isSkeleton =
        isLoading && topLearners.isEmpty && otherLearners.isEmpty;
    if (!isSkeleton && topLearners.isEmpty && otherLearners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: isSkeleton,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(),
            const SizedBox(height: 12),
            _LearnersCarousel(
              learners:
                  isSkeleton ? List.filled(3, _dummyLearner) : topLearners,
            ),
            if (otherLearners.isNotEmpty || isSkeleton) ...[
              const SizedBox(height: 16),
              _LeaderboardCard(
                learners:
                    isSkeleton ? List.filled(5, _dummyLearner) : otherLearners,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Components
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.title(l10n.topLearnersTitle),
          AppSemantics.button(
            label: l10n.viewAllAction,
            child: GestureDetector(
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                AppRoute(page: const TopLearnersScreen()),
              ),
              child: AppText.labelSmall(
                l10n.viewAllAction,
                color: design.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnersCarousel extends StatelessWidget {
  const _LearnersCarousel({required this.learners});
  final List<LearnerDto> learners;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = design.spacing.md * 2;
        final totalGap = 12.0 * math.max(0, learners.length - 1);
        final availableWidthForCards =
            constraints.maxWidth - horizontalPadding - totalGap;

        final cardWidth = math.max(
          160.0,
          availableWidthForCards / math.max(1, learners.length),
        );

        return SizedBox(
          height: _kCarouselHeight,
          child: AppSemantics.scrollableList(
            itemCount: learners.length,
            label: L10n.of(context).topLearnersTitle,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              itemCount: learners.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: cardWidth,
                  child: _LearnerCard(learner: learners[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({required this.learners});
  final List<LearnerDto> learners;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: design.shadows.surfaceSoft,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: learners.length,
          separatorBuilder: (_, __) => RowDivider(color: design.colors.divider),
          itemBuilder: (context, index) => LeaderboardListItem(
            learner: learners[index],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Item Layouts
// ─────────────────────────────────────────────────────────────────────────────

class _LearnerCard extends StatelessWidget {
  const _LearnerCard({required this.learner});
  final LearnerDto learner;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    Color badgeBgColor;
    Color badgeTextColor;
    Color cardTopBgColor;
    IconData rankIcon;
    switch (learner.rank) {
      case 1:
        badgeBgColor = design.colors.rank1.withValues(alpha: 0.18);
        badgeTextColor = design.colors.rank1;
        cardTopBgColor = design.colors.rank1.withValues(alpha: 0.12);
        rankIcon = LucideIcons.crown;
        break;
      case 2:
        badgeBgColor = design.colors.rank2.withValues(alpha: 0.25);
        badgeTextColor = design.colors.textSecondary;
        cardTopBgColor = design.colors.rank2.withValues(alpha: 0.25);
        rankIcon = LucideIcons.crown;
        break;
      case 3:
        badgeBgColor = design.colors.rank3.withValues(alpha: 0.25);
        badgeTextColor = design.colors.rank3;
        cardTopBgColor = design.colors.rank3.withValues(alpha: 0.12);
        rankIcon = LucideIcons.crown;
        break;
      default:
        badgeBgColor = design.colors.surfaceVariant;
        badgeTextColor = design.colors.textPrimary;
        cardTopBgColor = design.colors.surfaceVariant.withValues(alpha: 0.5);
        rankIcon = LucideIcons.star;
    }

    return AppSemantics.container(
      label: '${learner.name}, ${learner.points} points',
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: design.shadows.surfaceSoft,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: _kCurveHeight,
                decoration: BoxDecoration(
                  color: cardTopBgColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.elliptical(150, 60),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: cardTopBgColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (learner.rank == 1) ...[
                        Positioned(
                          top: 25,
                          left: -25,
                          child: Icon(LucideIcons.sparkles,
                              size: 16,
                              color:
                                  design.colors.rank2.withValues(alpha: 0.6)),
                        ),
                        Positioned(
                          top: 5,
                          right: -20,
                          child: Icon(LucideIcons.sparkle,
                              size: 14,
                              color:
                                  design.colors.rank1.withValues(alpha: 0.8)),
                        ),
                        Positioned(
                          bottom: 2,
                          left: -20,
                          child: Icon(LucideIcons.sparkle,
                              size: 12,
                              color:
                                  design.colors.rank3.withValues(alpha: 0.7)),
                        ),
                        Positioned(
                          top: -15,
                          right: 5,
                          child: Icon(LucideIcons.sparkles,
                              size: 10,
                              color:
                                  design.colors.rank1.withValues(alpha: 0.5)),
                        ),
                      ],
                      LearnerAvatar(
                        avatar: learner.avatar,
                        name: learner.name,
                        size: 56,
                      ),
                      if (learner.rank <= 3)
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Container(
                            width: _kSmallBadgeSize,
                            height: _kSmallBadgeSize,
                            decoration: BoxDecoration(
                              color: badgeTextColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: design.colors.card, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              rankIcon,
                              size: 12,
                              color: design.colors.textInverse,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: _kAvatarTextSpacing),
                  AppText.subtitle(
                    learner.name,
                    color: design.colors.textPrimary,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.trophy,
                          size: 14, color: design.colors.rank3),
                      const SizedBox(width: 4),
                      Flexible(
                        child: AppText.labelBold(
                          learner.points.toInt().toString(),
                          color: design.colors.textPrimary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: design.spacing.md,
              left: design.spacing.md,
              child: Container(
                width: _kLargeBadgeSize,
                height: _kLargeBadgeSize,
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AppText.labelBold(
                  learner.rank.toString(),
                  color: badgeTextColor,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
