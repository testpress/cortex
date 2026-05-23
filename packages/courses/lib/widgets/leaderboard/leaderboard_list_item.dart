import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Item Layouts
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardListItem extends StatelessWidget {
  const LeaderboardListItem({super.key, required this.learner});
  final LearnerDto learner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 12),
      child: Row(
        children: [
          RankText(rank: learner.rank),
          LearnerAvatar(
            avatar: learner.avatar,
            name: learner.name,
            size: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AppText.labelBold(
              learner.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          PointsDisplay(points: learner.points, iconSize: 14),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Atomic UI Components
// ─────────────────────────────────────────────────────────────────────────────

class LearnerAvatar extends StatelessWidget {
  const LearnerAvatar({
    super.key,
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
            child: RankBadge(rank: rank!),
          ),
      ],
    );
  }
}

class RankBadge extends StatelessWidget {
  const RankBadge({super.key, required this.rank});
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

class RankText extends StatelessWidget {
  const RankText({super.key, required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36, // Increased width to handle 3-digit ranks like 200
      child: AppText(
        rank.toString(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class PointsDisplay extends StatelessWidget {
  const PointsDisplay({super.key, required this.points, this.iconSize = 16});
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

class LearnerStats extends StatelessWidget {
  const LearnerStats({
    super.key,
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

class RowDivider extends StatelessWidget {
  const RowDivider({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color);
  }
}
