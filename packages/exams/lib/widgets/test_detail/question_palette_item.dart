import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import './palette_shapes.dart';
import './question_palette_strategy.dart';

class QuestionPaletteItem extends StatelessWidget {
  final QuestionDto question;
  final AnswerDto? answer;
  final int index;
  final PaletteColorStrategy strategy;
  final VoidCallback onTap;

  const QuestionPaletteItem({
    super.key,
    required this.question,
    required this.answer,
    required this.index,
    required this.strategy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    const double baseSize = 48.0;

    final style = strategy.styleFor(question, answer, design);

    final shape = SquareShape(
      size: baseSize,
      color: style.fillColor,
      borderColor: style.borderColor,
      child: Center(
        child: AppText.label(
          '${index + 1}',
          color: style.textColor,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    return AppSemantics.button(
      label: l10n.reviewQuestionLabel('${index + 1}'),
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Center(child: shape),
      ),
    );
  }
}
