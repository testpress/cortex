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

    return Container(
      color: design.colors.overlay,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.xl),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(design.spacing.lg),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.lg),
              boxShadow: shadows(design),
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
                  "Test Submitted!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.md),
                AppText.body(
                  "Your test has been successfully submitted. Review your answers or view detailed analytics.",
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
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: Center(
                      child: AppText.body(
                        "Review Answers",
                        color: design.colors.onPrimary,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        "View Analytics",
                        color: design.colors.textPrimary,
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
