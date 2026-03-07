import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class SubmitConfirmationDialog extends StatelessWidget {
  final int answeredCount;
  final int totalCount;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const SubmitConfirmationDialog({
    super.key,
    required this.answeredCount,
    required this.totalCount,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final unansweredCount = totalCount - answeredCount;

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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: design.colors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.alertCircle,
                    color: design.colors.warning,
                    size: 24,
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                AppText.headline(
                  l10n.testSubmitConfirmationTitle,
                  style: TextStyle(
                    fontSize: design.typographyScale.xl.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.md),
                AppText.body(
                  l10n.testSubmitConfirmationBody(answeredCount, totalCount),
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.sm),
                AppText.body(
                  l10n.testSubmitConfirmationUnanswered(unansweredCount),
                  color: design.colors.warning,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: design.spacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: design.spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: design.colors.card,
                            border: Border.all(color: design.colors.border),
                            borderRadius: BorderRadius.circular(
                              design.radius.md,
                            ),
                          ),
                          child: Center(
                            child: AppText.body(
                              l10n.labelCancel,
                              color: design.colors.textPrimary,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.md),
                    Expanded(
                      child: GestureDetector(
                        onTap: onSubmit,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: design.spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: design.colors.textPrimary,
                            borderRadius: BorderRadius.circular(
                              design.radius.md,
                            ),
                          ),
                          child: Center(
                            child: AppText.body(
                              l10n.labelSubmitNow,
                              color: design.colors.textInverse,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
