import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import './option_card.dart';

class TestQuestionCard extends StatelessWidget {
  final QuestionDto question;
  final AnswerDto? answer;
  final void Function(String) onOptionSelect;

  const TestQuestionCard({
    super.key,
    required this.question,
    required this.answer,
    required this.onOptionSelect,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(design.spacing.md),
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.directionHtml != null && question.directionHtml!.isNotEmpty) ...[
            AppHtml(
              data: question.directionHtml!,
              fontSize: 16,
            ),
            SizedBox(height: design.spacing.md),
            Container(
              height: 1,
              color: design.colors.border,
            ),
            SizedBox(height: design.spacing.md),
          ],
          AppHtml(
            data: question.text,
            fontSize: 18,
          ),
          if (question.type == 'multipleSelect')
            Padding(
              padding: EdgeInsets.only(top: design.spacing.sm),
              child: AppText.caption(
                L10n.of(context).testSelectAllApply,
                color: design.colors.textSecondary,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          SizedBox(height: design.spacing.md),
          ...question.options.map((option) {
            final isSelected = answer?.selectedOptions.any((id) => id.toString() == option.id.toString()) ?? false;
            
            return OptionCard(
              option: option,
              isSelected: isSelected,
              type: question.type,
              onTap: () => onOptionSelect(option.id),
            );
          }),
        ],
      ),
    );
  }
}
