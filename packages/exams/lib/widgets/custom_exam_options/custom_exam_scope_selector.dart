import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/custom_exam_options.dart';

class CustomExamScopeSelector extends StatelessWidget {
  final PracticeScope scope;
  final String? selectedCourseName;
  final ValueChanged<PracticeScope> onChanged;

  const CustomExamScopeSelector({
    super.key,
    required this.scope,
    this.selectedCourseName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final options = [
      (
        value: PracticeScope.fullCourse,
        label: context.l10n.customExamFullCourse,
        description: context.l10n.customExamCoverAllTopics,
      ),
      (
        value: PracticeScope.selectCourse,
        label:
            selectedCourseName != null &&
                selectedCourseName!.isNotEmpty &&
                scope == PracticeScope.selectCourse
            ? context.l10n.customExamCoursePrefix(selectedCourseName!)
            : context.l10n.customExamSelectCourse,
        description: context.l10n.customExamSpecificCourse,
      ),
    ];

    return Column(
      children: options.map((opt) {
        final isSelected = scope == opt.value;
        return Padding(
          padding: EdgeInsets.only(bottom: design.spacing.sm),
          child: AppSemantics.button(
            label: opt.label,
            onTap: () => onChanged(opt.value),
            child: GestureDetector(
              onTap: () => onChanged(opt.value),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 56),
                padding: EdgeInsets.all(
                  isSelected ? design.spacing.md - 1 : design.spacing.md,
                ),
                decoration: BoxDecoration(
                  color: design.colors.surface,
                  borderRadius: BorderRadius.circular(design.radius.lg),
                  border: Border.all(
                    color: isSelected
                        ? design.colors.primary
                        : design.colors.textTertiary.withValues(alpha: 0.4),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    _RadioDot(isSelected: isSelected, design: design),
                    SizedBox(width: design.spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.body(
                            opt.label,
                            color: design.colors.textPrimary,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          AppText.caption(
                            opt.description,
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;
  final DesignConfig design;

  const _RadioDot({required this.isSelected, required this.design});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? design.colors.primary : design.colors.border,
      ),
      child: Center(
        child: Container(
          width: isSelected ? 8 : 16,
          height: isSelected ? 8 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: design.colors.surface,
          ),
        ),
      ),
    );
  }
}
