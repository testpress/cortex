import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class SectionsTabBar extends StatelessWidget {
  final List<String> tabNames;
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const SectionsTabBar({
    super.key,
    required this.tabNames,
    required this.activeIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (tabNames.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
        child: Row(
          children: tabNames.asMap().entries.map((entry) {
            final index = entry.key;
            final tabName = entry.value;
            final isActive = index == activeIndex;

            final bgColor = isActive
                ? design.colors.textPrimary
                : design.colors.surfaceVariant;
            final fgColor = isActive
                ? design.colors.card
                : design.colors.textPrimary;

            final tabDisplayName = tabName.isEmpty
                ? l10n.labelGeneral
                : tabName;

            return Padding(
              padding: EdgeInsets.only(right: design.spacing.sm),
              child: AppSemantics.button(
                label: l10n.filterBy(tabDisplayName),
                onTap: () {
                  if (!isActive) {
                    onTabSelected(index);
                  }
                },
                child: AppFocusable(
                  onTap: () {
                    if (!isActive) {
                      onTabSelected(index);
                    }
                  },
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
                    child: AppText.label(
                      tabDisplayName,
                      color: fgColor,
                      style: TextStyle(
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
