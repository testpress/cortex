import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart' show FontWeight;

class TestNavigationActions extends StatelessWidget {
  final bool isMarked;
  final bool canGoPrevious;
  final bool isLastQuestion;
  final VoidCallback onToggleMark;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const TestNavigationActions({
    super.key,
    required this.isMarked,
    required this.canGoPrevious,
    required this.isLastQuestion,
    required this.onToggleMark,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMarkButton(design, l10n),
          SizedBox(height: design.spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavButton(
                design,
                l10n.testPrevious,
                LucideIcons.chevronLeft,
                canGoPrevious ? onPrevious : null,
                isBack: true,
              ),
              _buildNavButton(
                design,
                isLastQuestion ? l10n.testFinish : l10n.testNext,
                LucideIcons.chevronRight,
                onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarkButton(DesignConfig design, AppLocalizations l10n) {
    final markColor = design
        .colors
        .accent1; // Mark color is distinctive, typically stays purple
    return GestureDetector(
      onTap: onToggleMark,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isMarked
              ? (design.isDark
                    ? markColor.withValues(alpha: 0.15)
                    : markColor.withValues(alpha: 0.05))
              : design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(
            color: isMarked ? markColor : design.colors.border,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.flag,
              color: isMarked ? markColor : design.colors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            AppText.body(
              isMarked ? l10n.testMarked : l10n.testMarkForReview,
              color: isMarked ? markColor : design.colors.textPrimary,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    DesignConfig design,
    String label,
    IconData icon,
    VoidCallback? onTap, {
    bool isBack = false,
  }) {
    final bool isDisabled = onTap == null;
    final Color bgColor = isBack || isDisabled
        ? design.colors.card
        : design.colors.textPrimary;
    final Color textColor = isDisabled
        ? design.colors.border
        : (isBack ? design.colors.textPrimary : design.colors.textInverse);
    final Color borderColor = isDisabled
        ? design.colors.border.withValues(alpha: 0.5)
        : (isBack ? design.colors.textSecondary : design.colors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isBack) ...[
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 8),
            ],
            AppText.body(
              label,
              color: textColor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            if (!isBack) ...[
              const SizedBox(width: 8),
              Icon(icon, color: textColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
