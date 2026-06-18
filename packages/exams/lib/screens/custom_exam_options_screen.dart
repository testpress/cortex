import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../models/custom_exam_options.dart';
import '../providers/custom_exam_options_provider.dart';
import '../widgets/custom_exam_options/custom_exam_scope_selector.dart';
import '../widgets/custom_exam_options/course_selection_bottom_sheet.dart';
import '../widgets/custom_exam_options/custom_exam_options_selectors.dart';
import '../widgets/custom_exam_options/custom_exam_bottom_cta.dart';

class CustomExamOptionsScreen extends ConsumerStatefulWidget {
  final List<CourseDto> courses;
  final VoidCallback onInitCourses;
  final VoidCallback onBack;
  final ValueChanged<CustomExamOptionsConfig> onCreateExam;

  const CustomExamOptionsScreen({
    super.key,
    required this.courses,
    required this.onInitCourses,
    required this.onBack,
    required this.onCreateExam,
  });

  @override
  ConsumerState<CustomExamOptionsScreen> createState() =>
      _CustomExamOptionsScreenState();
}

class _CustomExamOptionsScreenState
    extends ConsumerState<CustomExamOptionsScreen> {
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onInitCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final padding = MediaQuery.paddingOf(context);

    final state = ref.watch(customExamOptionsNotifierProvider);
    final notifier = ref.read(customExamOptionsNotifierProvider.notifier);

    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.canvas),
      child: Stack(
        children: [
          // ── Scrollable content ──────────────────────────────────────────
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: padding.top + 64)),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    design.spacing.md,
                    design.spacing.xl,
                    design.spacing.md,
                    0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      CustomExamSectionLabel(
                        label: context.l10n.customExamStepScope,
                        design: design,
                      ),
                      SizedBox(height: design.spacing.sm),
                      CustomExamScopeSelector(
                        scope: state.scope,
                        selectedCourseName: state.courseName,
                        onChanged: (newScope) {
                          if (newScope == PracticeScope.selectCourse) {
                            setState(() {
                              _isBottomSheetOpen = true;
                            });
                          } else {
                            notifier.setScope(newScope);
                          }
                        },
                      ),
                      SizedBox(height: design.spacing.md),

                      CustomExamOptionsSelectors(
                        questionSource: state.questionSource,
                        onQuestionSourceChanged: notifier.setQuestionSource,
                        questionCount: state.questionCount,
                        onQuestionCountChanged: notifier.setQuestionCount,
                        difficulty: state.difficulty,
                        onDifficultyChanged: notifier.setDifficulty,
                        attemptMode: state.attemptMode,
                        onAttemptModeChanged: notifier.setAttemptMode,
                      ),

                      // Space for the fixed CTA
                      SizedBox(height: padding.bottom + 96),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Fixed header ────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(design, padding),
          ),

          // ── Fixed bottom CTA ────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomExamBottomCTA(
              isEnabled: state.canCreate,
              onConfirm: () => widget.onCreateExam(notifier.buildConfig()),
            ),
          ),

          // ── Bottom Sheet ────────────────────────────────────────────────
          AppBottomSheet(
            isOpen: _isBottomSheetOpen,
            onClose: () => setState(() => _isBottomSheetOpen = false),
            child: CourseSelectionSheet(
              courses: widget.courses,
              selectedCourseId: state.courseId,
              onCourseSelected: (course) {
                notifier.setCourse(course);
                setState(() => _isBottomSheetOpen = false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(DesignConfig design, EdgeInsets padding) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(bottom: BorderSide(color: design.colors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          design.spacing.md,
          padding.top + design.spacing.md,
          design.spacing.md,
          design.spacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSemantics.button(
              label: context.l10n.customExamBtnGoBack,
              onTap: widget.onBack,
              child: GestureDetector(
                onTap: widget.onBack,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    right: 8.0,
                  ),
                  child: Icon(
                    LucideIcons.chevronLeft,
                    color: design.colors.textPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AppSemantics.header(
                label: context.l10n.customExamCreateTitle,
                child: AppText.title(
                  context.l10n.customExamCreateTitle,
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
