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
  coursesCompleted: 12,
  streakDays: 5,
);

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
          GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              AppRoute(page: const TopLearnersScreen()),
            ),
            child: AppText.labelSmall(
              l10n.viewAllAction,
              color: design.colors.primary,
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

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
        itemCount: learners.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 260,
              child: _LearnerCard(learner: learners[index]),
            ),
          );
        },
      ),
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

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LearnerAvatar(
                avatar: learner.avatar,
                name: learner.name,
                rank: learner.rank,
                size: 56,
              ),
              PointsDisplay(points: learner.points),
            ],
          ),
          const SizedBox(height: 12),
          AppText.subtitle(
            learner.name,
            color: design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          LearnerStats(
            courses: learner.coursesCompleted,
            streak: learner.streakDays,
            iconSize: 14,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
