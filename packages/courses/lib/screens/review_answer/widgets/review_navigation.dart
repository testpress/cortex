import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ReviewNavigation extends StatelessWidget {
  final AppLocalizations l10n;
  final int currentIndex;
  final int totalCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ReviewNavigation({
    super.key,
    required this.l10n,
    required this.currentIndex,
    required this.totalCount,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final canGoPrevious = currentIndex > 0;
    final canGoNext = currentIndex < totalCount - 1;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      padding: EdgeInsets.symmetric(vertical: design.spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          _NavButton(
            onTap: canGoPrevious ? onPrevious : null,
            isEnabled: canGoPrevious,
            label: l10n.testPrevious,
            icon: LucideIcons.chevronLeft,
            isLeadingIcon: true,
          ),

          // Question Counter (Bold)
          AppText.body(
            l10n.reviewQuestionCount(currentIndex + 1, totalCount),
            color: design.colors.textPrimary,
          ),

          // Next Button
          _NavButton(
            onTap: canGoNext ? onNext : null,
            isEnabled: canGoNext,
            label: l10n.testNext,
            icon: LucideIcons.chevronRight,
            isLeadingIcon: false,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isEnabled;
  final String label;
  final IconData icon;
  final bool isLeadingIcon;

  const _NavButton({
    required this.onTap,
    required this.isEnabled,
    required this.label,
    required this.icon,
    required this.isLeadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Using design tokens for proper dark mode support
    final bgColor = isEnabled
        ? (design.isDark ? design.colors.card : design.colors.textPrimary)
        : (design.colors.surfaceVariant);

    final textColor = isEnabled
        ? (design.colors.onPrimary)
        : (design.colors.textTertiary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: isEnabled && design.isDark
              ? Border.all(color: design.colors.border)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLeadingIcon) ...[
              Icon(icon, color: textColor, size: 16),
              const SizedBox(width: 8),
            ],
            AppText.caption(label, color: textColor),
            if (!isLeadingIcon) ...[
              const SizedBox(width: 8),
              Icon(icon, color: textColor, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
