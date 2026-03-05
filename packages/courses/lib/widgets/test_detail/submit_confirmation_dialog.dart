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
    final unansweredCount = totalCount - answeredCount;

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
                  "Submit Test?",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.md),
                AppText.body(
                  "You have answered $answeredCount out of $totalCount questions.",
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.sm),
                AppText.body(
                  "$unansweredCount question(s) remain unanswered.",
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
                              "Cancel",
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
                              "Submit Now",
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

  List<BoxShadow> shadows(DesignConfig design) => [
    BoxShadow(
      color: design.colors.shadow.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}
