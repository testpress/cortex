import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class VideoMcqSummaryCard extends StatelessWidget {
  final List<LearnLensQuizQuestionDto> questions;
  final Map<int, String> selectedAnswers;
  final VoidCallback onRetake;
  final VoidCallback onBack;

  const VideoMcqSummaryCard({
    super.key,
    required this.questions,
    required this.selectedAnswers,
    required this.onRetake,
    required this.onBack,
  });

  bool _isOptionCorrect(String option, String correctAnswer) {
    final cleanOpt = option.trim();
    final cleanAns = correctAnswer.trim();
    if (cleanOpt.isEmpty || cleanAns.isEmpty) return false;
    if (cleanOpt == cleanAns) return true;
    if (cleanOpt.startsWith(cleanAns)) return true;
    if (cleanAns.startsWith(cleanOpt[0])) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      final ans = selectedAnswers[i];
      if (ans != null && _isOptionCorrect(ans, questions[i].correctAnswer)) {
        correctCount++;
      }
    }
    final percentage = questions.isNotEmpty
        ? ((correctCount / questions.length) * 100).round()
        : 0;

    return Padding(
      padding: EdgeInsets.all(design.spacing.md),
      child: Container(
        padding: EdgeInsets.all(design.spacing.lg),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(color: design.colors.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(design.spacing.md),
              decoration: BoxDecoration(
                color: design.colors.accent2.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.trophy,
                color: design.colors.accent2,
                size: 40,
              ),
            ),
            SizedBox(height: design.spacing.md),
            AppText.title(
              L10n.of(context).videoMcqQuizCompleted,
              color: design.colors.textPrimary,
            ),
            SizedBox(height: design.spacing.xs),
            AppText.subtitle(
              '$correctCount out of ${questions.length} Correct ($percentage%)',
              color: design.colors.textSecondary,
            ),
            SizedBox(height: design.spacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: L10n.of(context).videoMcqRetakeQuiz,
                    onPressed: onRetake,
                    fullWidth: true,
                  ),
                ),
                SizedBox(width: design.spacing.sm),
                Expanded(
                  child: AppButton.primary(
                    label: L10n.of(context).videoMcqBack,
                    onPressed: onBack,
                    fullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
