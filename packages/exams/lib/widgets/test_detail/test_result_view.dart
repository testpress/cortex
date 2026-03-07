import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart' show FontWeight;

class TestResultView extends StatelessWidget {
  final VoidCallback onReviewAnswers;
  final VoidCallback onViewAnalytics;
  final VoidCallback onClose;

  const TestResultView({
    super.key,
    required this.onReviewAnswers,
    required this.onViewAnalytics,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.overlay,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.xl),
          child: Container(
            constraints: BoxConstraints(maxWidth: design.layout.maxDrawerWidth),
            padding: EdgeInsets.all(design.spacing.lg),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.lg),
              boxShadow: design.shadows.floating,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Icon(
                      LucideIcons.x,
                      color: design.colors.textSecondary,
                      size: 24,
                    ),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: design.colors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.checkCircle2,
                    color: design.colors.success,
                    size: 24,
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                AppText.headline(
                  l10n.testSubmittedTitle,
                  style: TextStyle(
                    fontSize: design.typographyScale.xl.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.md),
                AppText.body(
                  l10n.testSubmittedBody,
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.xl),
                GestureDetector(
                  onTap: onReviewAnswers,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: design.spacing.sm),
                    decoration: BoxDecoration(
                      color: design.colors.primary,
                      border: Border.all(color: design.colors.primary),
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: Center(
                      child: AppText.body(
                        l10n.testReviewAnswers,
                        color: design.colors.onPrimary,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: design.spacing.md),
                GestureDetector(
                  onTap: onViewAnalytics,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: design.spacing.sm),
                    decoration: BoxDecoration(
                      color: design.colors.card,
                      border: Border.all(color: design.colors.border),
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: Center(
                      child: AppText.body(
                        l10n.testViewAnalytics,
                        color: design.colors.textPrimary,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
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
}
