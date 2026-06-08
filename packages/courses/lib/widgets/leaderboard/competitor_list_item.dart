import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'leaderboard_list_item.dart';

class CompetitorListItem extends StatelessWidget {
  const CompetitorListItem({super.key, required this.learner});
  final LearnerDto learner;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isCurrentUser = learner.isCurrentUser;

    return Container(
      color:
          isCurrentUser ? design.colors.accent2.withValues(alpha: 0.05) : null,
      padding: const EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: AppText.labelBold(
                learner.rank.toString(),
                style: TextStyle(
                  color: isCurrentUser
                      ? design.colors.accent2
                      : design.colors.textSecondary,
                ),
              ),
            ),
          ),
          LearnerAvatar(
            avatar: learner.avatar,
            name: learner.name,
            size: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AppText.labelBold(
              learner.name + (isCurrentUser ? l10n.leaderboardYouSuffix : ""),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: isCurrentUser
                  ? design.colors.accent2
                  : design.colors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          PointsDisplay(points: learner.points, iconSize: 14),
        ],
      ),
    );
  }
}
