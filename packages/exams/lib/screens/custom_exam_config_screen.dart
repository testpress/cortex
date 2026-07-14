import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/data/data.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/custom_exam_config_provider.dart';

class CustomExamConfigScreen extends ConsumerStatefulWidget {
  final CourseDto course;

  const CustomExamConfigScreen({super.key, required this.course});

  @override
  ConsumerState<CustomExamConfigScreen> createState() =>
      _CustomExamConfigScreenState();
}

class _CustomExamConfigScreenState
    extends ConsumerState<CustomExamConfigScreen> {
  bool _isSubjectSheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(generateCustomExamProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final themeColor = design.colors.primary;

    final configAsync = ref.watch(customExamConfigProvider(course.id));
    final selection = ref.watch(customExamSelectionProvider(course.id));
    final generateState = ref.watch(generateCustomExamProvider);

    ref.listen<AsyncValue<AttemptDto?>>(generateCustomExamProvider, (
      prev,
      next,
    ) {
      if (next.isLoading) return;

      if (next.hasError) {
        final errorMsg = next.error is ApiException
            ? (next.error as ApiException).message
            : next.error.toString();
        AppToast.show(context, message: errorMsg, isError: true);
      } else if (next.hasValue && next.value != null) {
        final attempt = next.value!;
        final assessmentId = attempt.userExamId ?? attempt.id;
        final isQuizMode =
            selection.selectedTestMode?.toLowerCase().contains('quiz') == true;

        context.pop();

        context.push(
          '/exams/test/$assessmentId/player?isQuizMode=$isQuizMode&isCustomTest=true',
          extra: attempt,
        );
      }
    });

    return Stack(
      children: [
        ColoredBox(
          color: design.colors.card,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Drawer-style header ───────────────────────────────────
                Container(
                  padding: EdgeInsets.only(
                    top: design.spacing.md,
                    left: design.spacing.md,
                    right: design.spacing.md,
                    bottom: design.spacing.md,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: design.colors.border, width: 1),
                    ),
                    boxShadow: design.shadows.surfaceSoft,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: design.spacing.xs,
                      horizontal: design.spacing.xs,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFocusable(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(design.radius.md),
                          child: Padding(
                            padding: EdgeInsets.all(design.spacing.xs),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Icon(
                                LucideIcons.arrowLeft,
                                color: design.colors.textPrimary,
                                size: design.iconSize.md,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: design.spacing.sm),
                        Expanded(
                          child: AppSemantics.header(
                            label: l10n.customExamCreateTitle,
                            child: AppText.title(
                              l10n.customExamCreateTitle,
                              color: design.colors.textPrimary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Main Content ──────────────────────────────────────────
                Expanded(
                  child: ColoredBox(
                    color: design.colors.canvas,
                    child: Skeletonizer(
                      enabled: configAsync.isLoading,
                      ignoreContainers: true,
                      effect: ShimmerEffect(
                        baseColor: design.colors.skeleton,
                        highlightColor: design.colors.onSkeleton,
                        duration: MotionPreferences.duration(
                          context,
                          const Duration(milliseconds: 800),
                        ),
                      ),
                      child: Builder(
                        builder: (context) {
                          final CustomTestConfigDto configToDisplay;

                          if (configAsync.isLoading) {
                            configToDisplay = CustomTestConfigDto(
                              subjects: List.generate(
                                3,
                                (i) => CustomTestFilterOptionDto(
                                  label: 'Loading subject...',
                                  value: '$i',
                                ),
                              ),
                              difficultyLevels: List.generate(
                                3,
                                (i) => CustomTestFilterOptionDto(
                                  label: 'Level $i',
                                  value: '$i',
                                ),
                              ),
                              questionTypes: List.generate(
                                2,
                                (i) => CustomTestFilterOptionDto(
                                  label: 'Type $i',
                                  value: '$i',
                                ),
                              ),
                              testModes: List.generate(
                                2,
                                (i) => CustomTestFilterOptionDto(
                                  label: 'Mode $i',
                                  value: '$i',
                                ),
                              ),
                              limits: const CustomTestLimitsDto(
                                maxQuestionsPerTest: 50,
                                dailyAttemptsAvailable: 5,
                                monthlyAttemptsAvailable: 15,
                              ),
                            );
                          } else if (configAsync.hasError) {
                            return Center(
                              child: AppText.body(l10n.errorUnknownOccurred),
                            );
                          } else {
                            configToDisplay = configAsync.valueOrNull!;
                          }

                          String? lockedMessage;
                          if (!configAsync.isLoading) {
                            if (configToDisplay
                                    .limits
                                    .monthlyAttemptsAvailable <=
                                0) {
                              lockedMessage =
                                  l10n.customExamMonthlyLimitExhausted;
                            } else if (configToDisplay
                                    .limits
                                    .dailyAttemptsAvailable <=
                                0) {
                              lockedMessage =
                                  l10n.customExamDailyLimitExhausted;
                            }
                          }
                          final isLocked = lockedMessage != null;

                          return Column(
                            children: [
                              Expanded(
                                child: AppSemantics.scrollableList(
                                  label: l10n.customExamTitle,
                                  itemCount: 6,
                                  child: ListView(
                                    padding: const EdgeInsets.all(20.0),
                                    children: [
                                      _buildHeaderCard(
                                        design,
                                        course,
                                        themeColor,
                                        context,
                                      ),
                                      const SizedBox(height: 32),

                                      if (lockedMessage != null)
                                        _buildLockedBanner(
                                          design,
                                          lockedMessage,
                                        ),

                                      if (configToDisplay.subjects.isNotEmpty)
                                        _buildSubjectDropdownSection(
                                          context: context,
                                          design: design,
                                          l10n: l10n,
                                          title: l10n.customExamSelectSubjects,
                                          subtitle: l10n
                                              .customExamSelectOneOrMoreSubjects,
                                          items: configToDisplay.subjects,
                                          selectedValues: configAsync.isLoading
                                              ? []
                                              : selection.selectedSubjects,
                                          onSelected:
                                              isLocked || configAsync.isLoading
                                              ? null
                                              : (v) => ref
                                                    .read(
                                                      customExamSelectionProvider(
                                                        course.id,
                                                      ).notifier,
                                                    )
                                                    .toggleSubject(v),
                                          themeColor: themeColor,
                                        ),

                                      if (configToDisplay
                                          .difficultyLevels
                                          .isNotEmpty)
                                        _buildDifficultySection(
                                          design: design,
                                          l10n: l10n,
                                          items:
                                              configToDisplay.difficultyLevels,
                                          selectedValues: configAsync.isLoading
                                              ? []
                                              : selection.selectedDifficulties,
                                          onSelected:
                                              isLocked || configAsync.isLoading
                                              ? null
                                              : (v) => ref
                                                    .read(
                                                      customExamSelectionProvider(
                                                        course.id,
                                                      ).notifier,
                                                    )
                                                    .toggleDifficulty(v),
                                          onBatchSelected:
                                              isLocked || configAsync.isLoading
                                              ? null
                                              : (v) => ref
                                                    .read(
                                                      customExamSelectionProvider(
                                                        course.id,
                                                      ).notifier,
                                                    )
                                                    .setDifficulties(v),
                                          themeColor: themeColor,
                                        ),

                                      if (configToDisplay
                                          .questionTypes
                                          .isNotEmpty)
                                        _buildMultiSelectionSection(
                                          design: design,
                                          title: l10n.customExamQuestionType,
                                          subtitle:
                                              l10n.customExamSelectQuestionType,
                                          items: configToDisplay.questionTypes,
                                          selectedValues: configAsync.isLoading
                                              ? []
                                              : selection.selectedQuestionTypes,
                                          onSelected:
                                              isLocked || configAsync.isLoading
                                              ? null
                                              : (v) => ref
                                                    .read(
                                                      customExamSelectionProvider(
                                                        course.id,
                                                      ).notifier,
                                                    )
                                                    .toggleQuestionType(v),
                                          themeColor: themeColor,
                                        ),

                                      if (configToDisplay.testModes.isNotEmpty)
                                        _buildSingleSelectionSection(
                                          design: design,
                                          title: l10n.customExamTestMode,
                                          subtitle: l10n
                                              .customExamChooseTestExperience,
                                          items: configToDisplay.testModes,
                                          selectedValue: configAsync.isLoading
                                              ? null
                                              : selection.selectedTestMode,
                                          onSelected:
                                              isLocked || configAsync.isLoading
                                              ? null
                                              : (v) => ref
                                                    .read(
                                                      customExamSelectionProvider(
                                                        course.id,
                                                      ).notifier,
                                                    )
                                                    .setTestMode(v),
                                          themeColor: themeColor,
                                        ),

                                      _buildSliderSection(
                                        design: design,
                                        l10n: l10n,
                                        selection: selection,
                                        limits: configToDisplay.limits,
                                        isLocked: isLocked,
                                        themeColor: themeColor,
                                        ref: ref,
                                        courseId: course.id,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildBottomBar(
                                context,
                                design,
                                l10n,
                                isLocked,
                                generateState.isLoading,
                                ref,
                                themeColor,
                                configToDisplay,
                                selection,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isSubjectSheetOpen && configAsync.valueOrNull != null)
          _buildSubjectSheet(
            context,
            design,
            l10n,
            themeColor,
            configAsync.valueOrNull!,
            selection,
          ),
      ],
    );
  }

  Widget _buildHeaderCard(
    DesignConfig design,
    CourseDto course,
    Color themeColor,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          L10n.of(context).customExamSelectedCourse,
          color: design.colors.textSecondary,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: design.colors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: course.image != null && course.image!.isNotEmpty
                    ? Image.network(
                        course.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          LucideIcons.graduationCap,
                          color: themeColor,
                          size: 24,
                        ),
                      )
                    : Icon(
                        LucideIcons.graduationCap,
                        color: themeColor,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    AppText.bodySmall(
                      '${course.totalLessons} Lessons',
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectionSection({
    required DesignConfig design,
    required String title,
    required String subtitle,
    required List<CustomTestFilterOptionDto> items,
    required List<String> selectedValues,
    required Function(String)? onSelected,
    required Color themeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          AppText.bodySmall(subtitle, color: design.colors.textSecondary),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) {
              final isSelected = selectedValues.contains(item.value);
              return _buildOptionCard(
                design: design,
                label: item.label,
                isSelected: isSelected,
                isCheckbox: true,
                onTap: onSelected == null ? null : () => onSelected(item.value),
                themeColor: themeColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySection({
    required DesignConfig design,
    required AppLocalizations l10n,
    required List<CustomTestFilterOptionDto> items,
    required List<String> selectedValues,
    required Function(String)? onSelected,
    required Function(List<String>)? onBatchSelected,
    required Color themeColor,
  }) {
    final allValues = items.map((e) => e.value).toList();
    final isMixed =
        allValues.isNotEmpty &&
        allValues.every((val) => selectedValues.contains(val));

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSemantics.header(
            label: l10n.customExamDifficultyLevel,
            child: AppText.body(
              l10n.customExamDifficultyLevel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          AppText.bodySmall(
            l10n.customExamSelectDifficultyLevel,
            color: design.colors.textSecondary,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...items.map((item) {
                final isSelected = selectedValues.contains(item.value);
                return _buildOptionCard(
                  design: design,
                  label: item.label,
                  isSelected: isSelected,
                  isCheckbox: true,
                  onTap: onSelected == null
                      ? null
                      : () => onSelected(item.value),
                  themeColor: themeColor,
                );
              }),
              _buildOptionCard(
                design: design,
                label: l10n.customExamDiffMixed,
                isSelected: isMixed,
                isCheckbox: true,
                onTap: onBatchSelected == null
                    ? null
                    : () {
                        if (isMixed) {
                          onBatchSelected([]);
                        } else {
                          onBatchSelected(allValues);
                        }
                      },
                themeColor: themeColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleSelectionSection({
    required DesignConfig design,
    required String title,
    required String subtitle,
    required List<CustomTestFilterOptionDto> items,
    required String? selectedValue,
    required Function(String)? onSelected,
    required Color themeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          AppText.bodySmall(subtitle, color: design.colors.textSecondary),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) {
              final isSelected = item.value == selectedValue;
              return _buildOptionCard(
                design: design,
                label: item.label,
                isSelected: isSelected,
                isCheckbox: false,
                onTap: onSelected == null ? null : () => onSelected(item.value),
                themeColor: themeColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required DesignConfig design,
    required String label,
    required bool isSelected,
    required bool isCheckbox,
    required VoidCallback? onTap,
    required Color themeColor,
    bool fullWidth = false,
  }) {
    final Widget card = AppSemantics.button(
      label: label,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? themeColor.withValues(alpha: 0.05)
                : design.colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? themeColor : design.colors.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (isCheckbox)
                Icon(
                  isSelected ? LucideIcons.checkSquare : LucideIcons.square,
                  color: isSelected ? themeColor : design.colors.border,
                  size: 20,
                )
              else
                Icon(
                  isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
                  color: isSelected ? themeColor : design.colors.border,
                  size: 20,
                ),
              const SizedBox(width: 12),
              Flexible(
                fit: fullWidth ? FlexFit.tight : FlexFit.loose,
                child: isSelected
                    ? AppText.labelBold(label, color: design.colors.textPrimary)
                    : AppText.label(label, color: design.colors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: card);
    }
    return card;
  }

  Widget _buildSliderSection({
    required DesignConfig design,
    required AppLocalizations l10n,
    required CustomExamSelectionState selection,
    required CustomTestLimitsDto limits,
    required bool isLocked,
    required Color themeColor,
    required WidgetRef ref,
    required String courseId,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.body(
          l10n.customExamNumberOfQuestions,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        AppText.bodySmall(
          l10n.customExamChooseNumberOfQuestions,
          color: design.colors.textSecondary,
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 32), // extra space for the tooltip
        LayoutBuilder(
          builder: (context, constraints) {
            final padding = 24.0;
            final trackWidth = constraints.maxWidth - (padding * 2);
            final min = 1;
            final max = limits.maxQuestionsPerTest;
            final value = selection.numberOfQuestions;

            final percentage = max == min ? 0.0 : (value - min) / (max - min);
            final thumbCenter = padding + (percentage * trackWidth);

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                GestureDetector(
                  onPanUpdate: isLocked
                      ? null
                      : (details) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          final localPosition = renderBox.globalToLocal(
                            details.globalPosition,
                          );
                          final percent = trackWidth <= 0
                              ? 0.0
                              : ((localPosition.dx - padding) / trackWidth)
                                    .clamp(0.0, 1.0);
                          final newValue = (min + percent * (max - min))
                              .round();
                          ref
                              .read(
                                customExamSelectionProvider(courseId).notifier,
                              )
                              .setNumberOfQuestions(newValue);
                        },
                  onTapDown: isLocked
                      ? null
                      : (details) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          final localPosition = renderBox.globalToLocal(
                            details.globalPosition,
                          );
                          final percent = trackWidth <= 0
                              ? 0.0
                              : ((localPosition.dx - padding) / trackWidth)
                                    .clamp(0.0, 1.0);
                          final newValue = (min + percent * (max - min))
                              .round();
                          ref
                              .read(
                                customExamSelectionProvider(courseId).notifier,
                              )
                              .setNumberOfQuestions(newValue);
                        },
                  child: Container(
                    height: 40,
                    color: const Color(0x00000000), // hit area
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: design.colors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: padding),
                          child: Container(
                            width: percentage * trackWidth,
                            height: 4,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Positioned(
                          left: thumbCenter - 10,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: thumbCenter - 24, // Center a 48px wide tooltip
                  top: -24, // Float above the thumb
                  child: Container(
                    width: 48,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: design.colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: design.colors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF000000,
                          ).withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: AppText.caption(
                      '$value',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      color: design.colors.textPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.caption('1', color: design.colors.textSecondary),
              AppText.caption(
                '${limits.maxQuestionsPerTest}',
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
    bool isLocked,
    bool isLoading,
    WidgetRef ref,
    Color themeColor,
    CustomTestConfigDto config,
    CustomExamSelectionState selection,
  ) {
    return SafeArea(
      top: false,
      child: AppButton.primary(
        label: isLoading
            ? l10n.labelLoading
            : l10n.customExamGenerateCustomExam,
        onPressed: isLocked || isLoading
            ? null
            : () {
                if (config.subjects.isNotEmpty &&
                    selection.selectedSubjects.isEmpty) {
                  AppToast.show(
                    context,
                    message: l10n.customExamSelectAtLeastOneSubject,
                    isError: true,
                  );
                  return;
                }
                if (config.difficultyLevels.isNotEmpty &&
                    selection.selectedDifficulties.isEmpty) {
                  AppToast.show(
                    context,
                    message: l10n.customExamSelectDifficultyLevel,
                    isError: true,
                  );
                  return;
                }
                if (config.questionTypes.isNotEmpty &&
                    selection.selectedQuestionTypes.isEmpty) {
                  AppToast.show(
                    context,
                    message: l10n.customExamPleaseSelectAtLeastOneQuestionType,
                    isError: true,
                  );
                  return;
                }
                if (config.testModes.isNotEmpty &&
                    selection.selectedTestMode == null) {
                  AppToast.show(
                    context,
                    message: l10n.customExamPleaseSelectTestMode,
                    isError: true,
                  );
                  return;
                }

                final req = ref
                    .read(
                      customExamSelectionProvider(widget.course.id).notifier,
                    )
                    .toGenerationRequest();
                ref.read(generateCustomExamProvider.notifier).generate(req);
              },
        fullWidth: true,
        backgroundColor: themeColor,
        loading:
            false, // Turn off built-in loading so we can show text + leading
        leading: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: AppLoadingIndicator(color: design.colors.onPrimary),
              )
            : Icon(
                LucideIcons.sparkles,
                size: 20,
                color: design.colors.onPrimary,
              ),
      ),
    );
  }

  Widget _buildLockedBanner(DesignConfig design, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: design.colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: design.colors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.lock, color: design.colors.error, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: AppText.bodySmall(
              message,
              style: const TextStyle(fontWeight: FontWeight.w600),
              color: design.colors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectDropdownSection({
    required BuildContext context,
    required DesignConfig design,
    required AppLocalizations l10n,
    required String title,
    required String subtitle,
    required List<CustomTestFilterOptionDto> items,
    required List<String> selectedValues,
    required Function(String)? onSelected,
    required Color themeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSemantics.header(
            label: title,
            child: AppText.body(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          AppText.bodySmall(subtitle, color: design.colors.textSecondary),
          const SizedBox(height: 16),
          // Dropdown trigger
          AppSemantics.button(
            label: title,
            onTap: onSelected == null
                ? null
                : () => setState(() => _isSubjectSheetOpen = true),
            child: GestureDetector(
              onTap: onSelected == null
                  ? null
                  : () => setState(() => _isSubjectSheetOpen = true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: design.colors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: design.colors.card,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.body(
                      l10n.customExamSelectSubjects,
                      color: design.colors.textSecondary,
                    ),
                    Icon(
                      LucideIcons.chevronDown,
                      color: design.colors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (selectedValues.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedValues.map((val) {
                final item = items.firstWhere(
                  (e) => e.value == val,
                  orElse: () =>
                      CustomTestFilterOptionDto(label: val, value: val),
                );
                return AppSemantics.button(
                  label: l10n.customExamRemoveItem(item.label),
                  onTap: onSelected == null ? null : () => onSelected(val),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onSelected == null ? null : () => onSelected(val),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.labelSmall(item.label, color: themeColor),
                            const SizedBox(width: 6),
                            Icon(LucideIcons.x, size: 14, color: themeColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubjectSheet(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
    Color themeColor,
    CustomTestConfigDto config,
    CustomExamSelectionState selection,
  ) {
    return AppBottomSheet(
      isOpen: _isSubjectSheetOpen,
      onClose: () => setState(() => _isSubjectSheetOpen = false),
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
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle Bar
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
                SizedBox(height: design.spacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSemantics.header(
                      label: l10n.customExamSelectSubjects,
                      child: AppText.title(
                        l10n.customExamSelectSubjects,
                        color: design.colors.textPrimary,
                      ),
                    ),
                    AppSemantics.button(
                      label: l10n.commonCloseButton,
                      onTap: () => setState(() => _isSubjectSheetOpen = false),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            setState(() => _isSubjectSheetOpen = false),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            LucideIcons.x,
                            color: design.colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.md),
                Flexible(
                  child: AppSemantics.scrollableList(
                    label: l10n.customExamSelectSubjects,
                    itemCount: config.subjects.length,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: config.subjects.length,
                      itemBuilder: (context, index) {
                        final item = config.subjects[index];
                        final isSelected = selection.selectedSubjects.contains(
                          item.value,
                        );
                        return AppSemantics.button(
                          label: item.label,
                          onTap: () {
                            ref
                                .read(
                                  customExamSelectionProvider(
                                    widget.course.id,
                                  ).notifier,
                                )
                                .toggleSubject(item.value);
                          },
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              ref
                                  .read(
                                    customExamSelectionProvider(
                                      widget.course.id,
                                    ).notifier,
                                  )
                                  .toggleSubject(item.value);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: AppText.body(item.label)),
                                  if (isSelected)
                                    Icon(
                                      LucideIcons.checkCircle2,
                                      color: themeColor,
                                    )
                                  else
                                    Icon(
                                      LucideIcons.circle,
                                      color: design.colors.border,
                                    ),
                                ],
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
      ),
    );
  }
}
