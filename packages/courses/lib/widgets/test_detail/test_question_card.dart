import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart' show FontWeight, FontStyle;
import '../../models/test_model.dart';
import './option_card.dart';

class TestQuestionCard extends StatelessWidget {
  final TestQuestion question;
  final TestAttemptAnswer? answer;
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
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            question.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: design.colors.textPrimary,
            ),
          ),
          if (question.type == QuestionType.multipleSelect)
            Padding(
              padding: EdgeInsets.only(top: design.spacing.sm),
              child: AppText.caption(
                'Select all that apply',
                color: design.colors.textSecondary,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          SizedBox(height: design.spacing.xl),
          ...question.options.map((option) {
            return OptionCard(
              option: option,
              isSelected: answer?.selectedOptions.contains(option.id) ?? false,
              type: question.type,
              onTap: () => onOptionSelect(option.id),
            );
          }),
        ],
      ),
    );
  }
}
