import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'exam_mode_option_card.dart';

/// Bottom sheet widget allowing users to select between Regular Exam and Quiz Mode.
class ExamModeBottomSheet extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final ValueChanged<bool> onSelectMode;

  const ExamModeBottomSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onSelectMode,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppBottomSheet(
      isOpen: isOpen,
      onClose: onClose,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          design.spacing.sm,
          0,
          design.spacing.sm,
          design.spacing.md,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              design.spacing.lg,
              design.spacing.md,
              design.spacing.lg,
              design.spacing.lg,
            ),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.all(
                Radius.circular(design.radius.xxl),
              ),
              boxShadow: design.shadows.floating,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: design.spacing.xl * 1.5,
                    height: 4,
                    decoration: BoxDecoration(
                      color: design.colors.border,
                      borderRadius: BorderRadius.circular(design.radius.full),
                    ),
                  ),
                ),
                SizedBox(height: design.spacing.xl),
                ExamModeOptionCard(
                  title: l10n.examModeRegularTitle,
                  description: l10n.examModeRegularDesc,
                  icon: LucideIcons.fileText,
                  isSelected: false,
                  onTap: () => onSelectMode(false),
                ),
                SizedBox(height: design.spacing.md),
                ExamModeOptionCard(
                  title: l10n.examModeQuizTitle,
                  description: l10n.examModeQuizDesc,
                  icon: LucideIcons.checkCircle,
                  isSelected: false,
                  onTap: () => onSelectMode(true),
                ),
                SizedBox(height: design.spacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
