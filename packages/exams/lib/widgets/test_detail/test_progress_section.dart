import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class TestProgressSection extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isSavedVisible;

  const TestProgressSection({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.isSavedVisible,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body(
                l10n.testQuestionXofY(currentQuestionIndex + 1, totalQuestions),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: design.colors.textPrimary,
                ),
              ),
              if (isSavedVisible)
                Row(
                  children: [
                    Icon(
                      LucideIcons.checkCircle2,
                      color: design.colors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    AppText.caption(
                      l10n.testSaved,
                      color: design.colors.success,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: design.spacing.sm),
          _buildProgressBar(design),
        ],
      ),
    );
  }

  Widget _buildProgressBar(DesignConfig design) {
    final progress = (currentQuestionIndex + 1) / totalQuestions;
    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(color: design.colors.border),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(color: design.colors.textPrimary),
        ),
      ),
    );
  }
}
