import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart' show FontWeight;

class TestResultView extends StatelessWidget {
  final int correctCount;
  final int totalCount;
  final VoidCallback onRetake;
  final VoidCallback onClose;

  const TestResultView({
    super.key,
    required this.correctCount,
    required this.totalCount,
    required this.onRetake,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final scorePercentage = totalCount > 0
        ? (correctCount / totalCount * 100).round()
        : 0;

    return Container(
      color: design.colors.surface,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.xl),
          child: Container(
            padding: EdgeInsets.all(design.spacing.xl),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.xl),
              boxShadow: shadows(design),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: design.colors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.checkCircle2,
                    color: design.colors.success,
                    size: 40,
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                AppText.headline(
                  l10n.testCompleteTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: design.spacing.sm),
                AppText.body(
                  l10n.testCompleteSubtitle,
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.xl),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(design.spacing.lg),
                  decoration: BoxDecoration(
                    color: design.colors.surface,
                    borderRadius: BorderRadius.circular(design.radius.md),
                  ),
                  child: Column(
                    children: [
                      AppText.headline(
                        l10n.testScorePercentage(scorePercentage),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AppText.body(
                        l10n.testScoreSummary(correctCount, totalCount),
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: design.spacing.xl),
                GestureDetector(
                  onTap: onRetake,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                    decoration: BoxDecoration(
                      color: design.colors.textPrimary,
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.refreshCw,
                          color: design.colors.textInverse,
                          size: 20,
                        ),
                        SizedBox(width: design.spacing.sm),
                        AppText.body(
                          l10n.testRetake,
                          color: design.colors.textInverse,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: design.spacing.md),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: design.colors.border),
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: Center(
                      child: AppText.body(
                        l10n.testBackToChapter,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> shadows(DesignConfig design) => [
    BoxShadow(
      color: design.colors.shadow.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}
