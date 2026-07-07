import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import './question_palette_strategy.dart';
import './question_palette_item.dart';
import './question_palette_legend.dart';

class QuestionPalette extends StatelessWidget {
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> answers;
  final Function(int) onQuestionSelected;
  final VoidCallback onClose;
  final PaletteColorStrategy strategy;

  const QuestionPalette({
    super.key,
    required this.questions,
    required this.answers,
    required this.onQuestionSelected,
    required this.onClose,
    required this.strategy,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = AppLocalizations.of(context)!;
    final answeredCount = strategy.answeredCount(questions, answers);

    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: onClose,
            child: Container(
              color: design.colors.shadow.withValues(alpha: 0.5),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(design.radius.xl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(design.spacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.headline(l10n.testPaletteTitle),
                              if (answeredCount != null) ...[
                                SizedBox(height: design.spacing.xs),
                                AppText.caption(
                                  l10n.testPaletteAnsweredCount(
                                    answeredCount,
                                    questions.length,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: design.spacing.md),
                        AppSemantics.button(
                          label: l10n.commonCloseButton,
                          onTap: onClose,
                          child: GestureDetector(
                            onTap: onClose,
                            child: Icon(
                              LucideIcons.x,
                              color: design.colors.textSecondary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  QuestionPaletteLegend(strategy: strategy),
                  Container(height: 1, color: design.colors.border),
                  Expanded(
                    child: AppSemantics.scrollableList(
                      itemCount: questions.length,
                      label: l10n.testPaletteTitle,
                      child: GridView.builder(
                        padding: EdgeInsets.all(design.spacing.lg),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = questions[index];
                          final answer = answers[question.id];
                          return QuestionPaletteItem(
                            question: question,
                            answer: answer,
                            index: index,
                            strategy: strategy,
                            onTap: () => onQuestionSelected(index),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
