import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/custom_exam_builder_provider.dart';
import '../providers/custom_exam_config_provider.dart';

class CustomExamModeBottomSheet extends ConsumerStatefulWidget {
  final String courseId;
  final VoidCallback onClose;
  final Function(int userExamId, AttemptDto attempt, {required bool isQuizMode})
  onSuccess;

  const CustomExamModeBottomSheet({
    super.key,
    required this.courseId,
    required this.onClose,
    required this.onSuccess,
  });

  @override
  ConsumerState<CustomExamModeBottomSheet> createState() =>
      _CustomExamModeBottomSheetState();
}

class _CustomExamModeBottomSheetState
    extends ConsumerState<CustomExamModeBottomSheet> {
  String _selectedMode = 'quiz';

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final design = Design.of(context);
    final generateState = ref.watch(generateCustomExamProvider);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.6),
      margin: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        bottom:
            math.max(
              MediaQuery.viewInsetsOf(context).bottom,
              MediaQuery.paddingOf(context).bottom,
            ) +
            design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
        boxShadow: design.shadows.floating,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag pill
          Center(
            child: Container(
              margin: EdgeInsets.only(top: design.spacing.sm),
              width: design.spacing.xl * 1.5,
              height: 4,
              decoration: BoxDecoration(
                color: design.colors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(design.radius.full),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              design.spacing.md,
              design.spacing.md,
              design.spacing.md,
              design.spacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSemantics.header(
                  label: l10n.customExamSelectModeTitle,
                  child: AppText.headline(l10n.customExamSelectModeTitle),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.body(
                  l10n.customExamSelectModeDesc,
                  color: design.colors.textSecondary,
                ),
                SizedBox(height: design.spacing.lg),

                // Mode cards
                Row(
                  children: [
                    Expanded(
                      child: _modeCard(
                        design,
                        title: l10n.customExamPracticeQuizTitle,
                        value: 'quiz',
                        icon: LucideIcons.bookOpen,
                        desc: l10n.customExamPracticeQuizDesc,
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: _modeCard(
                        design,
                        title: l10n.customExamRegularTitle,
                        value: 'regular',
                        icon: LucideIcons.timer,
                        desc: l10n.customExamRegularDesc,
                      ),
                    ),
                  ],
                ),

                if (generateState is AsyncError) ...[
                  SizedBox(height: design.spacing.md),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(design.spacing.sm),
                    decoration: BoxDecoration(
                      color: design.colors.error.withValues(alpha: 0.08),
                      borderRadius: design.radius.card,
                      border: Border.all(
                        color: design.colors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: AppText.caption(
                      '${generateState.error}',
                      color: design.colors.error,
                    ),
                  ),
                ],

                SizedBox(height: design.spacing.lg),
                AppSemantics.button(
                  label: l10n.customExamStart,
                  onTap: generateState is AsyncLoading
                      ? () {}
                      : _generateAndStart,
                  child: AppButton.primary(
                    label: generateState is AsyncLoading
                        ? l10n.customExamGenerating
                        : l10n.customExamStart,
                    fullWidth: true,
                    onPressed: generateState is AsyncLoading
                        ? () {}
                        : _generateAndStart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeCard(
    DesignConfig design, {
    required String title,
    required String value,
    required IconData icon,
    required String desc,
  }) {
    final isSelected = _selectedMode == value;

    return AppSemantics.button(
      label: title,
      onTap: () => setState(() => _selectedMode = value),
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = value),
        child: AnimatedContainer(
          duration: MotionPreferences.duration(context, design.motion.fast),
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? design.colors.primary.withValues(alpha: 0.08)
                : design.colors.surfaceVariant,
            borderRadius: design.radius.card,
            border: Border.all(
              color: isSelected ? design.colors.primary : design.colors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: design.iconSize.md,
                color: isSelected
                    ? design.colors.primary
                    : design.colors.textTertiary,
              ),
              SizedBox(height: design.spacing.sm),
              AppText.title(
                title,
                color: isSelected ? design.colors.primary : null,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: design.spacing.xs),
              AppText.caption(desc, color: design.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _generateAndStart() async {
    final builderState = ref.read(customExamBuilderProvider(widget.courseId));

    await ref
        .read(generateCustomExamProvider.notifier)
        .generate(
          CustomExamGenerationRequestDto(
            courseId: widget.courseId,
            testMode: _selectedMode,
            questionnaires: builderState.blocks
                .map(
                  (b) => CustomExamQuestionnaireBlockDto(
                    subjects: b.subjects,
                    difficultyLevels: b.difficultyLevels,
                    questionTypes: b.questionTypes,
                    numberOfQuestions: b.noOfQuestions,
                  ),
                )
                .toList(),
          ),
        );

    final result = ref.read(generateCustomExamProvider);
    if (result is AsyncData && result.value != null) {
      final attempt = result.value!;
      final id = attempt.activeId;
      if (id != null) {
        widget.onSuccess(id, attempt, isQuizMode: _selectedMode == 'quiz');
      }
    }
  }
}
