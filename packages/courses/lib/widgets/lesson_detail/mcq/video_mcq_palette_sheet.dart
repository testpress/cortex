import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class VideoMcqPaletteSheet extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Set<int> answeredIndices;
  final ValueChanged<int> onQuestionSelected;
  final VoidCallback onClose;

  const VideoMcqPaletteSheet({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answeredIndices,
    required this.onQuestionSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final answeredCount = answeredIndices.length;

    return AppSemantics.container(
      label: l10n.testPaletteTitle,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.72,
        ),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(design.radius.xl),
          ),
          boxShadow: design.shadows.floating,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  design.spacing.lg,
                  design.spacing.lg,
                  design.spacing.lg,
                  design.spacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.headline(
                            l10n.testPaletteTitle,
                            color: design.colors.textPrimary,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: design.spacing.xs),
                          AppText.caption(
                            l10n.testPaletteAnsweredCount(
                              answeredCount,
                              totalQuestions,
                            ),
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    AppSemantics.button(
                      label: l10n.commonCloseButton,
                      onTap: onClose,
                      child: AppFocusable(
                        onTap: onClose,
                        borderRadius: BorderRadius.circular(design.radius.full),
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(
                            LucideIcons.x,
                            color: design.colors.textSecondary,
                            size: design.iconSize.md,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: design.spacing.lg,
                  right: design.spacing.lg,
                  bottom: design.spacing.lg,
                ),
                child: Row(
                  children: [
                    _PaletteLegendCircle(
                      borderColor: design.colors.border,
                      label: l10n.testStatusNotVisited,
                    ),
                    SizedBox(width: design.spacing.xl),
                    _PaletteLegendCircle(
                      color: design.colors.success,
                      label: l10n.testStatusAnswered,
                    ),
                  ],
                ),
              ),
              Container(
                  height: 1,
                  color: design.colors.border.withValues(alpha: 0.5)),
              Flexible(
                child: AppSemantics.scrollableList(
                  itemCount: totalQuestions,
                  label: l10n.testPaletteTitle,
                  child: GridView.builder(
                    padding: EdgeInsets.all(design.spacing.lg),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: design.spacing.md,
                      crossAxisSpacing: design.spacing.md,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: totalQuestions,
                    itemBuilder: (context, index) {
                      final isAnswered = answeredIndices.contains(index);

                      final Color? bgColor =
                          isAnswered ? design.colors.success : null;
                      final Color? borderColor =
                          isAnswered ? null : design.colors.border;
                      final Color textColor = isAnswered
                          ? design.colors.textInverse
                          : design.colors.textSecondary;

                      return AppSemantics.button(
                        label: l10n.reviewQuestionLabel('${index + 1}'),
                        onTap: () => onQuestionSelected(index),
                        child: AppFocusable(
                          onTap: () => onQuestionSelected(index),
                          child: Center(
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(
                                  design.radius.md,
                                ),
                                border: borderColor != null
                                    ? Border.all(
                                        color: borderColor,
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: AppText.labelBold(
                                '${index + 1}',
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaletteLegendCircle extends StatelessWidget {
  final Color? color;
  final Color? borderColor;
  final String label;

  const _PaletteLegendCircle(
      {this.color, this.borderColor, required this.label});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: design.iconSize.sm,
          height: design.iconSize.sm,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.5)
                : null,
          ),
        ),
        SizedBox(width: design.spacing.sm),
        AppText.caption(
          label,
          color: design.colors.textSecondary,
        ),
      ],
    );
  }
}
