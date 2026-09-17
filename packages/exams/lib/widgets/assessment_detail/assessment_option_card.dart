import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';

class AssessmentOptionCard extends StatelessWidget {
  final QuestionOptionDto option;
  final bool isSelected;
  final String type; // 'singleSelect' | 'multipleSelect'
  final VoidCallback? onTap;
  final bool showFeedback;
  final bool isCorrect;
  final bool isIncorrect;

  const AssessmentOptionCard({
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

    return AppSemantics.button(
      label: option.text,
      onTap: onTap,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
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
              Expanded(child: _buildOptionContent(design)),
              if (showFeedback && (isCorrect || isIncorrect))
                Icon(
                  isCorrect ? LucideIcons.check : LucideIcons.x,
                  color: selectionColor,
                  size: design.iconSize.sm,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Renders option text using [AppHtml] when the content contains an embedded
  /// media element (video / iframe / embed), so the player is interactive.
  /// Falls back to [AppHtmlV2] (native Flutter, no WebView overhead) for all
  /// plain text / image options — preserving fast layout and tap selection.
  Widget _buildOptionContent(DesignConfig design) {
    final textColor = isCorrect
        ? design.colors.success
        : (isIncorrect ? design.colors.error : design.colors.textPrimary);

    final bool hasEmbed =
        option.text.contains('<iframe') ||
        option.text.contains('<video') ||
        option.text.contains('<embed');

    if (hasEmbed) {
      return AppHtml(
        data: option.text,
        fontSize: design.typography.body.fontSize ?? 18.0,
        textColor: textColor,
      );
    }

    return AbsorbPointer(
      child: AppHtmlV2(
        data: option.text,
        fontSize: design.typography.body.fontSize ?? 18.0,
        textColor: textColor,
      ),
    );
  }

  Widget _buildOptionIndicator(DesignConfig design, Color selectionColor) {
    final bool active = isSelected || isCorrect || isIncorrect;

    if (type == 'multipleSelect') {
      return Container(
        width: design.iconSize.md,
        height: design.iconSize.md,
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
                size: design.iconSize.xs,
              )
            : null,
      );
    } else {
      return SizedBox(
        width: design.iconSize.md,
        height: design.iconSize.md,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              LucideIcons.circle,
              color: active ? selectionColor : design.colors.border,
              size: design.iconSize.md,
            ),
            if (active)
              Container(
                width: design.iconSize.xs,
                height: design.iconSize.xs,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectionColor,
                ),
              ),
          ],
        ),
      );
    }
  }
}
