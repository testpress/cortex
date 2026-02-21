import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class LearnerBadge {
  final String icon;
  final String label;
  final Color color;

  const LearnerBadge({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class Learner {
  final String id;
  final int rank;
  final String name;
  final String avatar;
  final int points;
  final int coursesCompleted;
  final int streakDays;
  final List<LearnerBadge> badges;

  const Learner({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    required this.coursesCompleted,
    required this.streakDays,
    required this.badges,
  });
}

/// A section showing top-performing students.
class TopLearnersSection extends StatelessWidget {
  const TopLearnersSection({
    super.key,
    required this.topLearners,
    required this.otherLearners,
  });

  final List<Learner> topLearners;
  final List<Learner> otherLearners;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'TOP LEARNERS THIS WEEK',
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ),
                  color: design.colors.textPrimary.withValues(alpha: 0.7),
                ),
                AppText.bodySmall(
                  'View all',
                  color: design.colors.primary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildCarousel(context),
          if (otherLearners.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildLeaderboardList(context),
          ],
        ],
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    final design = Design.of(context);
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
          left: design.spacing.md,
          right: design.spacing.md,
        ),
        itemCount: topLearners.length,
        itemBuilder: (context, index) {
          final learner = topLearners[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(width: 260, child: _LearnerCard(learner: learner)),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardList(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: design.colors.border.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: otherLearners.length,
          separatorBuilder: (context, index) =>
              Container(height: 1, color: design.colors.divider),
          itemBuilder: (context, index) =>
              _LeaderboardItem(learner: otherLearners[index]),
        ),
      ),
    );
  }
}

class _LearnerCard extends StatelessWidget {
  const _LearnerCard({required this.learner});
  final Learner learner;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: design.colors.border.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant,
                      shape: BoxShape.circle,
                      image: learner.avatar.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(learner.avatar),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: learner.avatar.isEmpty
                        ? Center(
                            child: AppText(
                              learner.name[0],
                              color: design.colors.textSecondary,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getRankColor(learner.rank),
                        shape: BoxShape.circle,
                        border: Border.all(color: design.colors.card, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: design.colors.border.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AppText.caption(
                          learner.rank.toString(),
                          color: const Color(0xFFFFFFFF),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    LucideIcons.award,
                    size: 16,
                    color: Color(0xFF4F46E5),
                  ),
                  const SizedBox(width: 4),
                  AppText(
                    learner.points.toString(),
                    color: design.colors.textPrimary,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppText(
            learner.name,
            color: design.colors.textPrimary,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.checkCircle2,
                    size: 14,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(width: 4),
                  AppText.caption(
                    '${learner.coursesCompleted} courses',
                    color: design.colors.textSecondary,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(
                    LucideIcons.flame,
                    size: 14,
                    color: Color(0xFFF97316),
                  ),
                  const SizedBox(width: 4),
                  AppText.caption(
                    '${learner.streakDays} days',
                    color: design.colors.textSecondary,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          AppText.caption(
            'Achievements',
            color: design.colors.textSecondary,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (learner.badges.isNotEmpty)
                _buildAchievement(context, learner.badges.first),
              if (learner.badges.length > 1) ...[
                const SizedBox(width: 8),
                AppText.caption(
                  '+${learner.badges.length - 1} more',
                  color: design.colors.textSecondary,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievement(BuildContext context, LearnerBadge badge) {
    final emoji = switch (badge.icon) {
      'crown' => '👑',
      'rocket' => '🚀',
      'brain' => '🧠',
      'fire' => '🔥',
      'target' => '🎯',
      'chart' => '📊',
      'lightning' => '⚡',
      _ => badge.icon,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badge.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.bodySmall(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          AppText.bodySmall(
            badge.label,
            color: badge.color,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    return switch (rank) {
      1 => const Color(0xFFFBBF24), // amber-400
      2 => const Color(0xFFCBD5E1), // slate-300
      3 => const Color(0xFFFB923C), // orange-400
      _ => const Color(0xFF94A3B8), // slate-400
    };
  }
}

class _LeaderboardItem extends StatelessWidget {
  const _LeaderboardItem({required this.learner});
  final Learner learner;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: AppText(
              learner.rank.toString(),
              color: design.colors.textPrimary,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: design.colors.surfaceVariant,
              shape: BoxShape.circle,
              image: learner.avatar.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(learner.avatar),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: learner.avatar.isEmpty
                ? Center(
                    child: AppText(
                      learner.name[0],
                      color: design.colors.textSecondary,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  learner.name,
                  color: design.colors.textPrimary,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.checkCircle2,
                          size: 12,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 4),
                        AppText.caption(
                          '${learner.coursesCompleted} courses',
                          color: design.colors.textSecondary,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.flame,
                          size: 12,
                          color: Color(0xFFF97316),
                        ),
                        const SizedBox(width: 4),
                        AppText.caption(
                          '${learner.streakDays} days',
                          color: design.colors.textSecondary,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              const Icon(LucideIcons.award, size: 14, color: Color(0xFF4F46E5)),
              const SizedBox(width: 6),
              AppText(
                learner.points.toString(),
                color: design.colors.textPrimary,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
