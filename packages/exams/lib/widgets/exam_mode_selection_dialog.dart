import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ExamModeSelectionDialog extends StatelessWidget {
  final VoidCallback onSelectRegular;
  final VoidCallback onSelectQuiz;

  const ExamModeSelectionDialog({
    super.key,
    required this.onSelectRegular,
    required this.onSelectQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: design.colors.surface,
          borderRadius: BorderRadius.circular(design.radius.xl),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(design.spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText.title(
                      l10n.examModeSelectTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      LucideIcons.x,
                      color: design.colors.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: design.spacing.xl),

              // Regular Mode Option
              GestureDetector(
                onTap: onSelectRegular,
                child: Container(
                  padding: EdgeInsets.all(design.spacing.lg),
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    borderRadius: BorderRadius.circular(design.radius.lg),
                    border: Border.all(color: design.colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(design.spacing.sm),
                        decoration: BoxDecoration(
                          color: design.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(design.radius.md),
                        ),
                        child: Icon(
                          LucideIcons.fileText,
                          color: design.colors.primary,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: design.spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.body(
                              l10n.examModeRegularTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AppText.caption(
                              l10n.examModeRegularDesc,
                              color: design.colors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        color: design.colors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: design.spacing.md),

              // Quiz Mode Option
              GestureDetector(
                onTap: onSelectQuiz,
                child: Container(
                  padding: EdgeInsets.all(design.spacing.lg),
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    borderRadius: BorderRadius.circular(design.radius.lg),
                    border: Border.all(color: design.colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(design.spacing.sm),
                        decoration: BoxDecoration(
                          color: design.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(design.radius.md),
                        ),
                        child: Icon(
                          LucideIcons.checkCircle,
                          color: design.colors.primary,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: design.spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.body(
                              l10n.examModeQuizTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AppText.caption(
                              l10n.examModeQuizDesc,
                              color: design.colors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        color: design.colors.textSecondary,
                        size: 20,
                      ),
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
