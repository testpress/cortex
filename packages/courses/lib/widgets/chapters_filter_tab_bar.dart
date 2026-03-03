import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

/// Filter options for the curriculum view.
enum CurriculumFilter { all, video, pdf, assessment, test }

/// A horizontal scrollable tab bar for filtering content in the Chapters list.
///
/// Matches the reference implementation's pill-style tabs.
class ChaptersFilterTabBar extends StatelessWidget {
  const ChaptersFilterTabBar({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final CurriculumFilter activeFilter;
  final ValueChanged<CurriculumFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final tabs = [
      (filter: CurriculumFilter.all, label: l10n.filterAll, icon: null),
      (
        filter: CurriculumFilter.pdf,
        label: l10n.filterLesson,
        icon: LucideIcons.fileText,
      ),
      (
        filter: CurriculumFilter.video,
        label: l10n.filterVideo,
        icon: LucideIcons.playCircle,
      ),
      (
        filter: CurriculumFilter.assessment,
        label: l10n.filterAssessment,
        icon: LucideIcons.clipboardCheck,
      ),
      (
        filter: CurriculumFilter.test,
        label: l10n.filterTest,
        icon: LucideIcons.award,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            children: tabs.map((tab) {
              final isSelected = activeFilter == tab.filter;
              return Padding(
                padding: EdgeInsets.only(right: design.spacing.sm),
                child: _FilterTab(
                  label: tab.label,
                  icon: tab.icon,
                  isSelected: isSelected,
                  onTap: () => onFilterChanged(tab.filter),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Use design tokens for tab backgrounds/foregrounds
    final bgColor = isSelected
        ? design.colors.textPrimary
        : design.colors.surfaceVariant;
    final fgColor = isSelected ? design.colors.card : design.colors.textPrimary;

    return AppSemantics.button(
      label: 'Filter by $label',
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: design.radius.pill,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: design.motion.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: design.radius.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fgColor),
                SizedBox(width: design.spacing.xs),
              ],
              Text(
                label,
                style: design.typography.label.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
