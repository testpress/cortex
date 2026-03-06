import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../review_state_logic.dart';

class ReviewFilterBar extends StatelessWidget {
  final AppLocalizations l10n;
  final ReviewFilter activeFilter;
  final Function(ReviewFilter) onFilterChanged;
  final int countAll;
  final int countCorrect;
  final int countIncorrect;
  final int countUnanswered;

  const ReviewFilterBar({
    super.key,
    required this.l10n,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.countAll,
    required this.countCorrect,
    required this.countIncorrect,
    required this.countUnanswered,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: design.spacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
        child: Row(
          children: [
            ReviewFilterChip(
              filter: ReviewFilter.all,
              label: "${l10n.filterAll} ($countAll)",
              isSelected: activeFilter == ReviewFilter.all,
              onTap: () => onFilterChanged(ReviewFilter.all),
              activeColor: design.isDark
                  ? design.colors.primary
                  : design.colors.textPrimary,
            ),
            SizedBox(width: design.spacing.xs),
            ReviewFilterChip(
              filter: ReviewFilter.correct,
              label: "${l10n.examReviewFilterAnswered} ($countCorrect)",
              isSelected: activeFilter == ReviewFilter.correct,
              onTap: () => onFilterChanged(ReviewFilter.correct),
              activeColor: design.colors.accent4, // Emerald-600
            ),
            SizedBox(width: design.spacing.xs),
            ReviewFilterChip(
              filter: ReviewFilter.incorrect,
              label: "${l10n.examReviewFilterWrong} ($countIncorrect)",
              isSelected: activeFilter == ReviewFilter.incorrect,
              onTap: () => onFilterChanged(ReviewFilter.incorrect),
              activeColor: design.colors.accent5, // Red-600
            ),
            SizedBox(width: design.spacing.xs),
            ReviewFilterChip(
              filter: ReviewFilter.unanswered,
              label: "${l10n.examReviewFilterUnanswered} ($countUnanswered)",
              isSelected: activeFilter == ReviewFilter.unanswered,
              onTap: () => onFilterChanged(ReviewFilter.unanswered),
              activeColor: design.colors.accent3, // Orange-600
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewFilterChip extends StatelessWidget {
  final ReviewFilter filter;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const ReviewFilterChip({
    super.key,
    required this.filter,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final bgColor = isSelected ? activeColor : design.colors.card;
    final borderColor = isSelected ? activeColor : design.colors.border;
    final textColor = isSelected
        ? design.colors.onPrimary
        : design.colors.textSecondary;

    // Adaptive icon colors for dark mode
    Color iconColor;
    if (isSelected) {
      iconColor = design.colors.onPrimary;
    } else {
      switch (filter) {
        case ReviewFilter.correct:
          iconColor = design.colors.accent4;
          break;
        case ReviewFilter.incorrect:
          iconColor = design.colors.accent5;
          break;
        case ReviewFilter.unanswered:
          iconColor = design.colors.accent3;
          break;
        default:
          iconColor = design.colors.textSecondary;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        constraints: const BoxConstraints(minHeight: 36),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (filter == ReviewFilter.correct) ...[
              Icon(LucideIcons.checkCircle2, size: 14, color: iconColor),
              const SizedBox(width: 6),
            ],
            if (filter == ReviewFilter.incorrect) ...[
              Icon(LucideIcons.xCircle, size: 14, color: iconColor),
              const SizedBox(width: 6),
            ],
            if (filter == ReviewFilter.unanswered) ...[
              Icon(LucideIcons.alertCircle, size: 14, color: iconColor),
              const SizedBox(width: 6),
            ],
            AppText.caption(label, color: textColor),
          ],
        ),
      ),
    );
  }
}
