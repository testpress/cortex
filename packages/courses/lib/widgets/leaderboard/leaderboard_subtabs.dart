import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../screens/leaderboard/top_learners_screen.dart';

class LeaderboardSubtabs extends StatelessWidget {
  const LeaderboardSubtabs(
      {super.key, required this.activeTab, required this.onChanged});

  final LeaderboardTab activeTab;
  final ValueChanged<LeaderboardTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Row(
      children: [
        Expanded(
          child: _SubtabItem(
            label: l10n.leaderboardRankListTab,
            icon: LucideIcons.circleStar,
            isActive: activeTab == LeaderboardTab.rankList,
            onTap: () => onChanged(LeaderboardTab.rankList),
          ),
        ),
        SizedBox(width: design.spacing.sm),
        Expanded(
          child: _SubtabItem(
            label: l10n.leaderboardCompetitorsTab,
            icon: LucideIcons.users,
            isActive: activeTab == LeaderboardTab.competitors,
            onTap: () => onChanged(LeaderboardTab.competitors),
          ),
        ),
      ],
    );
  }
}

class _SubtabItem extends StatelessWidget {
  const _SubtabItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final bgColor =
        isActive ? design.colors.accent2 : design.colors.surfaceVariant;
    final fgColor =
        isActive ? design.colors.textInverse : design.colors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: fgColor),
            const SizedBox(width: 8),
            AppText.labelBold(label, color: fgColor),
          ],
        ),
      ),
    );
  }
}
