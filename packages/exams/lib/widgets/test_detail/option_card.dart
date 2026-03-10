import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/test_model.dart';

class OptionCard extends StatelessWidget {
  final QuestionOption option;
  final bool isSelected;
  final QuestionType type;
  final VoidCallback? onTap;
  final bool showFeedback;
  final bool isCorrect;
  final bool isIncorrect;

  const OptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.type,
    this.onTap,
    this.showFeedback = false,
    this.isCorrect = false,
    this.isIncorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Finalized styling logic for assessment feedback
    final Color selectionColor = isCorrect
        ? design.colors.success
        : (isIncorrect ? design.colors.error : design.colors.textPrimary);

    Color borderColor = (isSelected || isCorrect || isIncorrect)
        ? selectionColor
        : design.colors.border;

    Color bgColor = isCorrect
        ? design.colors.success.withValues(alpha: 0.05)
        : (isIncorrect
              ? design.colors.error.withValues(alpha: 0.05)
              : design.colors.card);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: design.spacing.md),
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            _buildOptionIndicator(design, selectionColor),
            SizedBox(width: design.spacing.md),
            Expanded(
              child: AppText.body(
                option.text,
                style: TextStyle(
                  fontWeight: (isSelected || isCorrect || isIncorrect)
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: isCorrect
                      ? design.colors.success
                      : (isIncorrect
                            ? design.colors.error
                            : design.colors.textPrimary),
                ),
              ),
            ),
            if (showFeedback && (isCorrect || isIncorrect))
              Icon(
                isCorrect ? LucideIcons.check : LucideIcons.x,
                color: selectionColor,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionIndicator(DesignConfig design, Color selectionColor) {
    final bool active = isSelected || isCorrect || isIncorrect;

    if (type == QuestionType.multipleSelect) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isSelected ? selectionColor : const Color(0x00000000),
          borderRadius: BorderRadius.circular(design.radius.sm),
          border: Border.all(
            color: active ? selectionColor : design.colors.border,
            width: 2.0,
          ),
        ),
        child: active
            ? Icon(
                isIncorrect ? LucideIcons.x : LucideIcons.check,
                color: design.colors.textInverse,
                size: 12,
              )
            : null,
      );
    } else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? selectionColor : design.colors.border,
            width: 2,
          ),
        ),
        child: active
            ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectionColor,
                  ),
                ),
              )
            : null,
      );
    }
  }
}
