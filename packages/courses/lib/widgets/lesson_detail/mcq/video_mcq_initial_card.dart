import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class VideoMcqInitialCard extends StatelessWidget {
  final String difficulty;
  final int questionCount;
  final VoidCallback onGenerate;
  final VoidCallback? onOpenFilterSheet;

  const VideoMcqInitialCard({
    super.key,
    required this.difficulty,
    required this.questionCount,
    required this.onGenerate,
    this.onOpenFilterSheet,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.xl,
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                design.colors.accent2.withValues(alpha: 0.15),
                design.colors.accent2.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(design.radius.md),
            border: Border.all(
              color: design.colors.accent2.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.sparkles,
                color: design.colors.accent2,
                size: 32,
              ),
              SizedBox(height: design.spacing.xs),
              AppText.cardTitle(
                l10n.videoMcqPracticeQuizTitle,
                color: design.colors.textPrimary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.xs),
              AppText.cardSubtitle(
                l10n.videoMcqPracticeQuizSubtitle,
                color: design.colors.textSecondary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: design.colors.accent2.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(design.radius.sm),
                ),
                child: AppText.labelBold(
                  '${difficulty[0].toUpperCase()}${difficulty.substring(1)} • ${l10n.videoMcqQuestionsCount(questionCount)}',
                  color: design.colors.accent2,
                ),
              ),
              SizedBox(height: design.spacing.md),
              Row(
                children: [
                  AppIconButton(
                    icon: LucideIcons.slidersHorizontal,
                    onTap: onOpenFilterSheet ?? () {},
                    accessibilityLabel: l10n.videoMcqQuizOptions,
                  ),
                  SizedBox(width: design.spacing.sm),
                  Expanded(
                    child: AppButton.primary(
                      label: l10n.videoMcqGenerateButton,
                      fullWidth: true,
                      leading: Icon(
                        LucideIcons.sparkles,
                        color: design.colors.textInverse,
                        size: 16,
                      ),
                      onPressed: onGenerate,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
