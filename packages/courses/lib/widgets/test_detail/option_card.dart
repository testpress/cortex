import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart' show FontWeight;
import '../../models/test_model.dart';

class OptionCard extends StatelessWidget {
  final QuestionOption option;
  final bool isSelected;
  final QuestionType type;
  final VoidCallback? onTap;

  const OptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final Color selectionColor = design.colors.textPrimary;
    Color borderColor = isSelected ? selectionColor : design.colors.border;
    Color bgColor = design.colors.card;

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
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          children: [
            _buildOptionIndicator(design),
            SizedBox(width: design.spacing.md),
            Expanded(
              child: AppText.body(
                option.text,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionIndicator(DesignConfig design) {
    final selectionColor = design.colors.textPrimary;
    if (type == QuestionType.multipleSelect) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isSelected ? selectionColor : Colors.transparent,
          borderRadius: BorderRadius.circular(design.radius.sm),
          border: Border.all(
            color: isSelected ? selectionColor : design.colors.border,
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(
                LucideIcons.check,
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
            color: isSelected ? selectionColor : design.colors.border,
            width: 2,
          ),
        ),
        child: isSelected
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
