import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class QuizResultView extends StatelessWidget {
  final String? score;
  final VoidCallback onRetake;
  final VoidCallback onClose;
  final bool allowRetake;
  final bool isOffline;

  const QuizResultView({
    super.key,
    this.score,
    required this.onRetake,
    required this.onClose,
    this.allowRetake = true,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final accentColor = design.colors.success;

    return Container(
      color: design.colors.surface,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.xl),
          child: Container(
            constraints: BoxConstraints(maxWidth: design.layout.maxDrawerWidth),
            padding: EdgeInsets.all(design.spacing.xl),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.xl),
              boxShadow: [
                BoxShadow(
                  color: design.colors.shadow.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.clipboardCheck,
                    color: accentColor,
                    size: 40,
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                AppText.headline(
                  l10n.assessmentPracticeComplete,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.sm),
                AppText.body(
                  isOffline
                      ? l10n.testSavedLocallyOffline
                      : l10n.testCompleteSubtitle,
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.xl),
                if (!isOffline)
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
                          score ?? '-',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                          ),
                        ),
                        AppText.body(
                          'Your Score', // Fallback or find better l10n
                          color: design.colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                if (!isOffline) SizedBox(height: design.spacing.xl),
                if (!isOffline && allowRetake) ...[
                  GestureDetector(
                    onTap: onRetake,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: design.spacing.md,
                      ),
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
                ],
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
                      child: AppText.headline(
                        l10n.assessmentBackToChapter,
                        style: TextStyle(
                          fontSize: design.typographyScale.xl.fontSize,
                          fontWeight: FontWeight.bold,
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
