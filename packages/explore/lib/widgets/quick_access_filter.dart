import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class QuickAccessFilter extends StatelessWidget {
  const QuickAccessFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final filters = [
      l10n.exploreFilterTrending,
      l10n.exploreFilterRecommended,
      l10n.exploreFilterShortLessons,
      l10n.exploreFilterPopular,
      l10n.exploreFilterStudyTips,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Row(
        children: [
          for (final filter in filters)
            Padding(
              padding: EdgeInsets.only(right: design.spacing.sm),
              child: _ExploreFilterChip(
                label: filter,
                isActive: selectedFilter == filter,
                onTap: () => onFilterSelected(filter),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExploreFilterChip extends StatelessWidget {
  const _ExploreFilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final bgColor = isActive ? design.colors.textPrimary : design.colors.surfaceVariant;

    final textColor = isActive ? design.colors.textInverse : design.colors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: design.radius.pill,
          border: isActive ? null : Border.all(color: design.colors.border),
        ),
        child: Text(
          label,
          style: design.typography.label.copyWith(
            color: textColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
