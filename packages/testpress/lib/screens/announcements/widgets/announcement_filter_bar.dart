import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Shows an active filter badge pill when a category is selected.
/// When no category is selected, renders [SizedBox.shrink].
class AnnouncementFilterBar extends StatelessWidget {
  const AnnouncementFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onClear,
    required this.onOpenFilterSheet,
  });

  final PostCategoryDto? selectedCategory;
  final VoidCallback onClear;
  final VoidCallback onOpenFilterSheet;

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final design = Design.of(context);
    final l10n = L10n.of(context);
    final category = selectedCategory!;
    final color = ColorUtils.parseHexColor(
      category.color,
      defaultColor: design.colors.primary,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.xs * 1.5,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: design.radius.pill,
              border: Border.all(color: design.colors.border, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category info and tap to open filter sheet
                AppSemantics.button(
                  label: l10n.announcementsSelectedFilter(category.name),
                  onTap: onOpenFilterSheet,
                  child: AppFocusable(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(design.radius.full),
                    ),
                    onTap: onOpenFilterSheet,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 38),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: design.spacing.md,
                        right: design.spacing.xs,
                        top: design.spacing.xs * 1.2,
                        bottom: design.spacing.xs * 1.2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: design.spacing.xs),
                          AppText.labelBold(
                            category.name,
                            color: design.colors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Clear filter button (flattened, not nested)
                AppSemantics.button(
                  label: l10n.announcementsClearCategoryFilter(category.name),
                  onTap: onClear,
                  child: AppFocusable(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(design.radius.full),
                    ),
                    onTap: onClear,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 38,
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: design.spacing.xs * 0.5,
                        right: design.spacing.sm,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: design.colors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.x,
                          size: 13,
                          color: design.colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
