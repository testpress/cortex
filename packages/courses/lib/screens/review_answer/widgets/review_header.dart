import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ReviewHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final String assessmentTitle;
  final VoidCallback onBack;

  const ReviewHeader({
    super.key,
    required this.l10n,
    required this.assessmentTitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + design.spacing.sm,
        bottom: design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.isDark ? design.colors.surface : design.colors.card,
        border: Border(bottom: BorderSide(color: design.colors.border)),
        boxShadow: design.isDark
            ? []
            : [
                BoxShadow(
                  color: design.colors.shadow.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.chevronLeft,
                    size: 20,
                    color: design.colors.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  AppText.label(
                    l10n.curriculumBackButton,
                    color: design.colors.textPrimary,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: design.spacing.md),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: AppText.headline(
              l10n.reviewAnswersTitle(assessmentTitle),
              color: design.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
