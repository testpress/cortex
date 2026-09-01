import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Modal bottom sheet content for filtering announcements by category.
/// Tapping any category or "All Posts" immediately applies the filter and closes the sheet.
class AnnouncementFilterSheet extends StatelessWidget {
  const AnnouncementFilterSheet({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onApply,
    required this.onClose,
  });

  final List<PostCategoryDto> categories;
  final PostCategoryDto? selectedCategory;
  final ValueChanged<PostCategoryDto?> onApply;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        0,
        design.spacing.sm,
        design.spacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.65,
          ),
          decoration: BoxDecoration(
            color: design.colors.surface,
            borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
            boxShadow: design.shadows.floating,
          ),
          padding: EdgeInsets.fromLTRB(
            design.spacing.lg,
            design.spacing.md,
            design.spacing.lg,
            design.spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle Grabber
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: EdgeInsets.only(bottom: design.spacing.md),
                  decoration: BoxDecoration(
                    color: design.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.title(l10n.announcementsFilterByCategory),
                  AppIconButton(
                    icon: LucideIcons.x,
                    onTap: onClose,
                    accessibilityLabel: l10n.announcementsCloseFilter,
                    size: design.iconSize.sm,
                    color: design.colors.textSecondary,
                  ),
                ],
              ),
              SizedBox(height: design.spacing.md),

              // Categories list
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // "All Posts" option
                      _SheetCategoryRow(
                        label: l10n.announcementsAllPosts,
                        isSelected: selectedCategory == null,
                        onTap: () {
                          onApply(null);
                          onClose();
                        },
                      ),

                      // Individual categories
                      ...categories.map((cat) {
                        final color = ColorUtils.parseHexColor(
                          cat.color,
                          defaultColor: design.colors.primary,
                        );
                        final isSelected = selectedCategory?.id == cat.id;

                        return _SheetCategoryRow(
                          label: cat.name,
                          color: color,
                          isSelected: isSelected,
                          onTap: () {
                            onApply(cat);
                            onClose();
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetCategoryRow extends StatelessWidget {
  const _SheetCategoryRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: isSelected ? '$label, selected' : label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.sm),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.sm,
            vertical: design.spacing.xs,
          ),
          child: Row(
            children: [
              if (color != null) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: design.spacing.sm),
              ] else ...[
                SizedBox(width: design.spacing.sm),
              ],
              Expanded(
                child: AppText.body(
                  label,
                  color: isSelected
                      ? design.colors.primary
                      : design.colors.textPrimary,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  LucideIcons.check,
                  size: design.iconSize.sm,
                  color: design.colors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
