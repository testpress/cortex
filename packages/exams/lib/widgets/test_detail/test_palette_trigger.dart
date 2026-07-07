import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class TestPaletteTrigger extends StatelessWidget {
  final int? answeredCount;
  final int totalQuestions;
  final VoidCallback onTap;

  const TestPaletteTrigger({
    super.key,
    this.answeredCount,
    required this.totalQuestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final label = answeredCount != null
        ? l10n.testViewAllQuestions(answeredCount!, totalQuestions)
        : l10n.testViewAllQuestionsShort;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: design.colors.card,
          border: Border.all(color: design.colors.border),
          borderRadius: BorderRadius.circular(design.radius.md),
        ),
        child: Center(
          child: AppText.body(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: design.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
