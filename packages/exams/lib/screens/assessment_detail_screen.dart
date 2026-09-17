import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/assessment_model.dart';
import '../providers/assessment_controller.dart';
import '../repositories/exam_repository.dart';
import '../widgets/assessment_detail/assessment_header.dart';
import '../widgets/assessment_detail/assessment_option_card.dart';
import '../widgets/test_detail/nav_button.dart';
import '../widgets/test_detail/pause_confirmation_dialog.dart';

class AssessmentDetailScreen extends ConsumerStatefulWidget {
  final String assessmentId;
  final LessonDto? lesson;
  final VoidCallback onClose;

  const AssessmentDetailScreen({
    super.key,
    required this.assessmentId,
    this.lesson,
    required this.onClose,
  });

  @override
  ConsumerState<AssessmentDetailScreen> createState() =>
      _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState
    extends ConsumerState<AssessmentDetailScreen> {
  bool _showPauseConfirmation = false;

  void _handleExit(AssessmentState state) {
    if (state.status == ExamAttemptStatus.inProgress &&
        !state.isCompleted &&
        state.questions.isNotEmpty) {
      setState(() => _showPauseConfirmation = true);
    } else {
      if (state.isCompleted) {
        final lessonId = widget.lesson?.id ?? widget.assessmentId;
        ref
            .read(appDatabaseProvider.future)
            .then((db) {
              db.updateLessonProgress(lessonId, LessonProgressStatus.completed);
            })
            .catchError((_) {});
      }
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final param = AssessmentParam(
      assessmentId: widget.assessmentId,
      lesson: widget.lesson,
    );
    final state = ref.watch(assessmentControllerProvider(param));
    final controller = ref.read(assessmentControllerProvider(param).notifier);

    if (state.isCompleted || state.status == ExamAttemptStatus.completed) {
      return _buildResultView(design, context, state, controller);
    }

    if (state.status == ExamAttemptStatus.loading) {
      return Container(
        color: design.colors.surface,
        child: Column(
          children: [
            AssessmentHeader(
              assessment: state.asAssessment,
              answeredCount: 0,
              onExit: () => _handleExit(state),
            ),
            const Expanded(child: Center(child: AppLoadingIndicator())),
          ],
        ),
      );
    }

    if (state.status == ExamAttemptStatus.error) {
      return Container(
        color: design.colors.surface,
        child: Column(
          children: [
            AssessmentHeader(
              assessment: state.asAssessment,
              answeredCount: 0,
              onExit: () => _handleExit(state),
            ),
            Expanded(
              child: Center(
                child: AppErrorView(
                  error: state.errorMessage,
                  message: state.errorMessage ?? l10n.errorGenericMessage,
                  onRetry: controller.retry,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.questions.isEmpty) {
      return Container(
        color: design.colors.surface,
        child: Column(
          children: [
            AssessmentHeader(
              assessment: state.asAssessment,
              answeredCount: 0,
              onExit: () => _handleExit(state),
            ),
            Expanded(
              child: Center(
                child: AppErrorView(
                  message: l10n.noQuestionsFound,
                  onRetry: controller.retry,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final q = state.currentQuestion!;
    final questionState = state.stateFor(q.id);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleExit(state);
      },
      child: Container(
        color: design.colors.surface,
        child: Stack(
          children: [
            Column(
              children: [
                AssessmentHeader(
                  assessment: state.asAssessment,
                  answeredCount: state.answeredCount,
                  onExit: () => _handleExit(state),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildProgressSection(design, l10n, state),
                        _buildQuestionCard(
                          design,
                          l10n,
                          q,
                          questionState,
                          state,
                          controller,
                        ),
                        if (questionState.isChecked)
                          _buildFeedbackBlock(
                            design,
                            context,
                            q,
                            state,
                            controller,
                          ),
                        SizedBox(height: design.spacing.md),
                        _buildActions(
                          design,
                          context,
                          q,
                          questionState,
                          state,
                          controller,
                        ),
                        SizedBox(height: design.spacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showPauseConfirmation)
              PauseConfirmationDialog(
                disablePause:
                    widget.lesson?.disableAttemptResume ??
                    state.disableAttemptResume,
                onCancel: () => setState(() => _showPauseConfirmation = false),
                onPause: () async {
                  setState(() => _showPauseConfirmation = false);
                  await controller.pauseExam();
                  widget.onClose();
                },
                onEnd: () async {
                  setState(() => _showPauseConfirmation = false);
                  await controller.endExam();
                },
              ),
          ],
        ),
      ),
    );
  }

  // ─── Progress section ────────────────────────────────────────────────────────

  Widget _buildProgressSection(
    DesignConfig design,
    AppLocalizations l10n,
    AssessmentState state,
  ) {
    final currentIndex = state.currentIndex;
    final totalQuestions = state.questions.length;
    final progress = totalQuestions > 0
        ? (currentIndex + 1) / totalQuestions
        : 0.0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            l10n.testQuestionXofY(currentIndex + 1, totalQuestions),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: design.typographyScale.base.fontSize,
              color: design.colors.textPrimary,
            ),
          ),
          SizedBox(height: design.spacing.sm),
          AppSemantics.progressValue(
            value: progress,
            label: l10n.testQuestionXofY(currentIndex + 1, totalQuestions),
            child: Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(color: design.colors.divider),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(color: design.colors.success),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Question card ───────────────────────────────────────────────────────────

  Widget _buildQuestionCard(
    DesignConfig design,
    AppLocalizations l10n,
    AssessmentQuestion q,
    AssessmentAttemptState questionState,
    AssessmentState state,
    AssessmentController controller,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(design.spacing.md),
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHtml(
            data: q.text,
            fontSize: 17,
            textColor: design.colors.textPrimary,
          ),
          if (q.type == AssessmentQuestionType.multipleSelect)
            Padding(
              padding: EdgeInsets.only(top: design.spacing.sm),
              child: AppText.caption(
                l10n.testSelectAllApply,
                color: design.colors.textSecondary,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          SizedBox(height: design.spacing.xl),
          ...q.options.map((option) {
            final isSelected = questionState.selectedOptions.contains(
              option.id,
            );
            final isCorrect = state.isOptionCorrect(q, option.id);
            final isIncorrect =
                questionState.isChecked && isSelected && !isCorrect;
            return AssessmentOptionCard(
              option: QuestionOptionDto(id: option.id, text: option.text),
              isSelected: isSelected || (questionState.isChecked && isCorrect),
              type: q.type == AssessmentQuestionType.multipleSelect
                  ? 'multipleSelect'
                  : 'singleSelect',
              onTap: questionState.isChecked
                  ? null
                  : () => controller.selectOption(q.id, option.id),
              showFeedback: questionState.isChecked,
              isCorrect: questionState.isChecked && isCorrect,
              isIncorrect: isIncorrect,
            );
          }),
        ],
      ),
    );
  }

  // ─── Feedback block ──────────────────────────────────────────────────────────

  Widget _buildFeedbackBlock(
    DesignConfig design,
    BuildContext context,
    AssessmentQuestion q,
    AssessmentState state,
    AssessmentController controller,
  ) {
    final l10n = L10n.of(context);
    final isCorrect = state.isAnswerCorrect(q);

    final amber = design.subjectPalette.atIndex(6);

    final iconColor = isCorrect ? design.colors.success : amber.accent;
    final textColor = isCorrect ? design.colors.success : amber.foreground;
    final bgColor = isCorrect
        ? design.colors.success.withValues(alpha: 0.07)
        : amber.background;
    final borderColor = isCorrect
        ? design.colors.success.withValues(alpha: 0.3)
        : amber.accent.withValues(alpha: 0.4);

    final feedbackIcon = isCorrect
        ? LucideIcons.checkCircle2
        : LucideIcons.xCircle;
    final feedbackLabel = isCorrect
        ? l10n.assessmentCorrect
        : l10n.assessmentIncorrect;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: design.spacing.md),
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(feedbackIcon, color: iconColor, size: 20),
              SizedBox(width: design.spacing.sm),
              AppText.body(
                feedbackLabel,
                color: textColor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (q.explanation != null && q.explanation!.trim().isNotEmpty) ...[
            SizedBox(height: design.spacing.md),
            Container(height: 1, color: borderColor),
            SizedBox(height: design.spacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.lightbulb,
                  color: design.colors.textSecondary,
                  size: 16,
                ),
                SizedBox(width: design.spacing.sm),
                Expanded(
                  child: AppHtml(
                    data: q.explanation!,
                    fontSize: 14,
                    textColor: design.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
          // "Try Again" button
          if (!isCorrect) ...[
            SizedBox(height: design.spacing.md),
            AppSemantics.button(
              label: l10n.assessmentTryAgain,
              onTap: () => controller.tryAgain(q.id),
              child: GestureDetector(
                onTap: () => controller.tryAgain(q.id),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(design.radius.md),
                    color: design.colors.card,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.refreshCw, color: textColor, size: 16),
                      SizedBox(width: design.spacing.xs),
                      AppText.body(
                        l10n.assessmentTryAgain,
                        color: textColor,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Action bar ──────────────────────────────────────────────────────────────

  Widget _buildActions(
    DesignConfig design,
    BuildContext context,
    AssessmentQuestion q,
    AssessmentAttemptState questionState,
    AssessmentState state,
    AssessmentController controller,
  ) {
    final l10n = L10n.of(context);
    final isLast = state.isLastQuestion;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For multiple-select questions when selections exist but not yet checked
          if (q.type == AssessmentQuestionType.multipleSelect &&
              questionState.isAnswered &&
              !questionState.isChecked)
            AppButton.primary(
              label: l10n.assessmentCheckAnswer,
              onPressed: () => controller.checkAnswer(q.id),
              fullWidth: true,
              backgroundColor: design.colors.success,
              foregroundColor: design.colors.textInverse,
            )
          // Forward-only navigation: only show Next / Finish button
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NavButton(
                  label: isLast ? l10n.testFinish : l10n.assessmentNext,
                  icon: isLast
                      ? LucideIcons.checkCircle2
                      : LucideIcons.chevronRight,
                  onTap: questionState.isChecked ? controller.next : null,
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ─── Result view ─────────────────────────────────────────────────────────────

  Widget _buildResultView(
    DesignConfig design,
    BuildContext context,
    AssessmentState state,
    AssessmentController controller,
  ) {
    final l10n = L10n.of(context);
    final correctCount = state.correctCount;
    final totalQuestions = state.questions.length;
    final scorePercent = state.scorePercent;
    final accentColor = design.colors.success;

    return Container(
      color: design.colors.surface,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.xl),
          child: Container(
            padding: EdgeInsets.all(design.spacing.xl),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.xl),
              boxShadow: [
                BoxShadow(
                  color: design.colors.shadow.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.clipboardCheck,
                    color: accentColor,
                    size: 40,
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                AppText.headline(
                  l10n.assessmentPracticeComplete,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.sm),
                AppText.body(
                  l10n.testCompleteSubtitle,
                  color: design.colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.xl),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(design.spacing.lg),
                  decoration: BoxDecoration(
                    color: design.colors.surface,
                    borderRadius: BorderRadius.circular(design.radius.md),
                  ),
                  child: Column(
                    children: [
                      AppText.headline(
                        l10n.testScorePercentage(scorePercent),
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: accentColor,
                        ),
                      ),
                      AppText.body(
                        l10n.testScoreSummary(correctCount, totalQuestions),
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: design.spacing.xl),
                if (state.allowRetake) ...[
                  AppButton.primary(
                    label: l10n.testRetake,
                    onPressed: controller.retake,
                    fullWidth: true,
                    backgroundColor: design.colors.textPrimary,
                    foregroundColor: design.colors.textInverse,
                    leading: const Icon(LucideIcons.refreshCw),
                  ),
                  SizedBox(height: design.spacing.md),
                ],
                AppButton.secondary(
                  label: l10n.assessmentBackToChapter,
                  onPressed: widget.onClose,
                  fullWidth: true,
                  foregroundColor: design.colors.textPrimary,
                  borderColor: design.colors.border,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
