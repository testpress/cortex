import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'nav_button.dart';

class TestNavigationActions extends StatelessWidget {
  final bool isMarked;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool isLastQuestion;
  final String? finishLabel;
  final VoidCallback onToggleMark;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isQuizMode;
  final bool isQuizChecked;
  final bool isChecking;
  final VoidCallback? onCheck;
  final bool hasAnswer;
  final VoidCallback? onClearResponse;

  const TestNavigationActions({
    super.key,
    required this.isMarked,
    required this.canGoPrevious,
    this.canGoNext = true,
    required this.isLastQuestion,
    this.finishLabel,
    required this.onToggleMark,
    required this.onPrevious,
    required this.onNext,
    this.isQuizMode = false,
    this.isQuizChecked = false,
    this.isChecking = false,
    this.onCheck,
    this.hasAnswer = false,
    this.onClearResponse,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMarkButton(context),
            if (hasAnswer &&
                onClearResponse != null &&
                (!isQuizMode || !isQuizChecked))
              _buildClearButton(context),
          ],
        ),
        SizedBox(height: design.spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavButton(
              label: l10n.testPrevious,
              icon: LucideIcons.chevronLeft,
              onTap: canGoPrevious ? onPrevious : null,
              isBack: true,
            ),
            if (isQuizMode && !isQuizChecked && onCheck != null)
              NavButton(
                label: l10n.actionCheck,
                icon: LucideIcons.checkCircle2,
                onTap: onCheck,
                loading: isChecking,
              )
            else if (isQuizMode && isQuizChecked)
              NavButton(
                label: isLastQuestion ? l10n.testFinish : l10n.labelContinue,
                icon: LucideIcons.chevronRight,
                onTap: onNext,
              )
            else
              NavButton(
                label:
                    finishLabel ??
                    (isLastQuestion ? l10n.testFinish : l10n.testNext),
                icon: LucideIcons.chevronRight,
                onTap: canGoNext ? onNext : null,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarkButton(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final markColor = design.colors.accent1;
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

  Widget _buildClearButton(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return AppSemantics.button(
      label: l10n.testClearResponse,
      onTap: onClearResponse,
      child: AppFocusable(
        onTap: onClearResponse,
        borderRadius: BorderRadius.circular(design.radius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: BorderRadius.circular(design.radius.md),
                border: Border.all(color: design.colors.border, width: 1.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.x,
                    color: design.colors.textPrimary,
                    size: 18,
                  ),
                  SizedBox(width: design.spacing.sm),
                  AppText.body(
                    l10n.testClearResponse,
                    color: design.colors.textPrimary,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
