import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/assessment_model.dart';

/// Assessment-specific question palette.
/// Matches the reference design (Question Palette, 3 of 15 answered).
/// Legend & States:
///   - Correct    → Green rounded square with checkmark (no number)
///   - Incorrect  → Red/Warning rounded square with X (no number)
///   - Unanswered → White rounded square with gray border, number inside
class AssessmentPalette extends StatelessWidget {
  final List<AssessmentQuestion> questions;
  final Map<String, AssessmentAttemptState> states;
  final int currentIndex;
  final Function(int) onQuestionSelected;
  final VoidCallback onClose;
  final bool Function(AssessmentQuestion q) isCorrectFn;

  const AssessmentPalette({
    super.key,
    required this.questions,
    required this.states,
    required this.currentIndex,
    required this.onQuestionSelected,
    required this.onClose,
    required this.isCorrectFn,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final checkedCount = states.values.where((s) => s.isChecked).length;

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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(design.radius.xl),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(design.spacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.headline(
                              l10n.assessmentPaletteTitle,
                              style: TextStyle(
                                fontSize: design.typographyScale.lg.fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppText.caption(
                              l10n.testPaletteAnsweredCount(
                                checkedCount,
                                questions.length,
                              ),
                              color: design.colors.textSecondary,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onClose,
                          child: Icon(
                            LucideIcons.x,
                            color: design.colors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildLegend(design, l10n),
                  Container(height: 1, color: design.colors.border),
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(design.spacing.lg),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: design.spacing.md,
                        crossAxisSpacing: design.spacing.md,
                      ),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final q = questions[index];
                        final state = states[q.id];
                        return GestureDetector(
                          onTap: () => onQuestionSelected(index),
                          child: Center(
                            child: _buildItemContainer(
                              design: design,
                              index: index,
                              q: q,
                              state: state,
                              isCurrent: index == currentIndex,
                            ),
                          ),
                        );
                      },
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

  Widget _buildItemContainer({
    required DesignConfig design,
    required int index,
    required AssessmentQuestion q,
    required AssessmentAttemptState? state,
    required bool isCurrent,
  }) {
    const double size = 48.0;

    // Default shape variables
    Color bgColor = design.colors.card;
    Color? borderColor = design.colors.border;
    Widget child = Center(
      child: AppText.label(
        '${index + 1}',
        color: design.colors.textSecondary,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: design.typographyScale.base.fontSize,
        ),
      ),
    );

    if (state != null && state.isChecked) {
      final correct = isCorrectFn(q);
      bgColor = correct ? design.colors.success : design.colors.error;
      borderColor = null;
      child = Center(
        child: Icon(
          correct ? LucideIcons.check : LucideIcons.x,
          color: design.colors.textInverse,
          size: 24,
        ),
      );
    } else if (state != null && state.isAnswered && !state.isChecked) {
      // Selected but not checked
      borderColor = design.colors.textPrimary;
      child = Center(
        child: AppText.label(
          '${index + 1}',
          color: design.colors.textPrimary,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: design.typographyScale.base.fontSize,
          ),
        ),
      );
    }

    final tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.5)
            : null,
      ),
      child: child,
    );

    if (!isCurrent) return tile;

    // Current selection ring
    return Container(
      padding: EdgeInsets.all(design.spacing.xs / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: design.colors.success, width: 2),
      ),
      child: tile,
    );
  }

  Widget _buildLegend(DesignConfig design, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.lg,
        right: design.spacing.lg,
        bottom: design.spacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _legendRow(
            design,
            _legendIcon(
              design,
              color: design.colors.success,
              icon: LucideIcons.check,
            ),
            l10n.assessmentCorrect,
          ),
          SizedBox(height: design.spacing.sm),
          _legendRow(
            design,
            _legendIcon(
              design,
              color: design.colors.error,
              icon: LucideIcons.x,
            ),
            l10n.assessmentIncorrect,
          ),
          SizedBox(height: design.spacing.sm),
          _legendRow(
            design,
            _legendIcon(
              design,
              bgColor: design.colors.card,
              borderColor: design.colors.border,
            ),
            l10n.assessmentUnanswered,
          ),
        ],
      ),
    );
  }

  Widget _legendIcon(
    DesignConfig design, {
    Color? color,
    Color? bgColor,
    Color? borderColor,
    IconData? icon,
  }) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color ?? bgColor,
        borderRadius: BorderRadius.circular(4),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: icon != null
          ? Center(
              child: Icon(icon, color: design.colors.textInverse, size: 12),
            )
          : null,
    );
  }

  Widget _legendRow(DesignConfig design, Widget iconWidget, String label) {
    return Row(
      children: [
        iconWidget,
        SizedBox(width: design.spacing.sm),
        AppText.label(
          label,
          color: design.colors.textPrimary,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: design.typographyScale.sm.fontSize,
          ),
        ),
      ],
    );
  }
}
