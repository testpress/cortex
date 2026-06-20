import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class TestResultView extends StatelessWidget {
  final String? score;
  final VoidCallback onReview;
  final VoidCallback onClose;

  const TestResultView({
    super.key,
    this.score,
    required this.onReview,
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
                  child: AppSemantics.button(
                    label: l10n.commonCloseButton,
                    onTap: onClose,
                    child: GestureDetector(
                      onTap: onClose,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          LucideIcons.x,
                          color: design.colors.textSecondary,
                          size: 24,
                        ),
                      ),
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
                  score != null
                      ? l10n.testScoreResult(score!)
                      : l10n.testSubmittedBody,
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.xl),
                AppButton.primary(
                  label: l10n.testReview,
                  onPressed: onReview,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
