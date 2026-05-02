import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// A section showing top-performing students on the dashboard.
class TopLearnersSection extends StatelessWidget {
  const TopLearnersSection({
    super.key,
    required this.topLearners,
    required this.otherLearners,
  });

  final List<LearnerDto> topLearners;
  final List<LearnerDto> otherLearners;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(),
          const SizedBox(height: 12),
          _LearnersCarousel(learners: topLearners),
          if (otherLearners.isNotEmpty) ...[
            const SizedBox(height: 16),
            _LeaderboardCard(learners: otherLearners),
          ],
        ],
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
          AppText.labelSmall(
            l10n.viewAllAction,
            color: design.colors.primary,
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
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 260,
            child: _LearnerCard(learner: learners[index]),
          ),
        ),
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
          separatorBuilder: (_, __) => _RowDivider(color: design.colors.divider),
          itemBuilder: (context, index) => _LeaderboardItem(
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
              _LearnerAvatar(
                avatar: learner.avatar,
                name: learner.name,
                rank: learner.rank,
                size: 56,
              ),
              _PointsDisplay(points: learner.points),
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
          _LearnerStats(
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

class _LeaderboardItem extends StatelessWidget {
  const _LeaderboardItem({required this.learner});
  final LearnerDto learner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _RankText(rank: learner.rank),
          _LearnerAvatar(
            avatar: learner.avatar,
            name: learner.name,
            size: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelBold(
                  learner.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                _LearnerStats(
                  courses: learner.coursesCompleted,
                  streak: learner.streakDays,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _PointsDisplay(points: learner.points, iconSize: 14),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Atomic UI Components
// ─────────────────────────────────────────────────────────────────────────────

class _LearnerAvatar extends StatelessWidget {
  const _LearnerAvatar({
    required this.avatar,
    required this.name,
    this.rank,
    required this.size,
  });

  final String avatar;
  final String name;
  final int? rank;
  final double size;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: design.colors.surfaceVariant,
            shape: BoxShape.circle,
            image: avatar.isNotEmpty
                ? DecorationImage(image: NetworkImage(avatar), fit: BoxFit.cover)
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: avatar.isEmpty && name.isNotEmpty
              ? Center(
                  child: AppText.label(
                    name[0],
                    color: design.colors.textSecondary,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : null,
        ),
        if (rank != null)
          Positioned(
            bottom: -2,
            right: -2,
            child: _RankBadge(rank: rank!),
          ),
      ],
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _getRankColor(context, rank),
        shape: BoxShape.circle,
        border: Border.all(color: design.colors.card, width: 2),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Center(
        child: AppText.labelSmall(
          rank.toString(),
          color: design.colors.textInverse,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ),
    );
  }

  Color _getRankColor(BuildContext context, int rank) {
    final design = Design.of(context);
    return switch (rank) {
      1 => design.colors.rank1,
      2 => design.colors.rank2,
      3 => design.colors.rank3,
      _ => design.colors.rankDefault,
    };
  }
}

class _RankText extends StatelessWidget {
  const _RankText({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      child: AppText(
        rank.toString(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PointsDisplay extends StatelessWidget {
  const _PointsDisplay({required this.points, this.iconSize = 16});
  final double points;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.trophy, size: iconSize, color: design.colors.rank3),
        const SizedBox(width: 4),
        AppText.labelBold(points.toInt().toString()),
      ],
    );
  }
}

class _LearnerStats extends StatelessWidget {
  const _LearnerStats({
    required this.courses,
    required this.streak,
    this.iconSize = 12,
    this.fontSize = 12,
  });

  final int courses;
  final int streak;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Row(
      children: [
        if (courses > 0) ...[
          Icon(LucideIcons.checkCircle2, size: iconSize, color: design.colors.success),
          const SizedBox(width: 4),
          AppText.caption(
            l10n.coursesCompletedLabel(courses),
            color: design.colors.textSecondary,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
        ],
        if (streak > 0) ...[
          Icon(LucideIcons.flame, size: iconSize, color: design.colors.warning),
          const SizedBox(width: 4),
          AppText.caption(
            l10n.streakDaysLabel(streak),
            color: design.colors.textSecondary,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}
