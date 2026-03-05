import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../models/assessment_model.dart';
import '../data/mock_assessments.dart';
import '../widgets/assessment_detail/assessment_header.dart';
import '../widgets/assessment_detail/assessment_palette.dart';
import '../widgets/test_detail/option_card.dart';
import '../widgets/test_detail/test_palette_trigger.dart';
import '../models/test_model.dart' show QuestionOption, QuestionType;

class AssessmentDetailScreen extends ConsumerStatefulWidget {
  final String assessmentId;
  final VoidCallback onClose;

  const AssessmentDetailScreen({
    super.key,
    required this.assessmentId,
    required this.onClose,
  });

  @override
  ConsumerState<AssessmentDetailScreen> createState() =>
      _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState
    extends ConsumerState<AssessmentDetailScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, AssessmentAttemptState> _attemptStates = {};
  bool _showPalette = false;
  bool _assessmentComplete = false;

  late final Assessment _assessment;
  late final List<AssessmentQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _assessment = MockAssessmentFactory.createMockAssessment();
    _questions = MockAssessmentFactory.createMockQuestions();
  }

  // ─── State helpers ──────────────────────────────────────────────────────────

  AssessmentAttemptState _stateFor(String questionId) =>
      _attemptStates[questionId] ??
      AssessmentAttemptState(questionId: questionId, selectedOptions: []);

  bool _isOptionCorrect(AssessmentQuestion q, String optionId) =>
      q.correctOptionIds.contains(optionId);

  bool _isAnswerCorrect(AssessmentQuestion q) {
    final state = _stateFor(q.id);
    final selected = List<String>.from(state.selectedOptions)..sort();
    final correct = List<String>.from(q.correctOptionIds)..sort();
    return listEquals(selected, correct);
  }

  int get _answeredCount =>
      _attemptStates.values.where((s) => s.isAnswered).length;

  int get _checkedCount =>
      _attemptStates.values.where((s) => s.isChecked).length;

  int get _correctCount {
    int count = 0;
    for (final q in _questions) {
      final state = _stateFor(q.id);
      if (state.isChecked && _isAnswerCorrect(q)) count++;
    }
    return count;
  }

  // ─── Event handlers ─────────────────────────────────────────────────────────

  void _handleOptionSelect(AssessmentQuestion q, String optionId) {
    final state = _stateFor(q.id);
    if (state.isChecked) return;
    setState(() {
      List<String> newSelections;
      if (q.type == AssessmentQuestionType.multipleSelect) {
        newSelections = List.from(state.selectedOptions);
        if (newSelections.contains(optionId)) {
          newSelections.remove(optionId);
        } else {
          newSelections.add(optionId);
        }
      } else {
        newSelections = [optionId];
      }
      _attemptStates[q.id] = state.copyWith(selectedOptions: newSelections);
    });
  }

  void _handleCheckAnswer() {
    final q = _questions[_currentQuestionIndex];
    setState(() {
      _attemptStates[q.id] = _stateFor(q.id).copyWith(isChecked: true);
    });
  }

  void _handleTryAgain() {
    final q = _questions[_currentQuestionIndex];
    setState(() => _attemptStates.remove(q.id));
  }

  void _handleNext() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      setState(() => _assessmentComplete = true);
    }
  }

  void _handlePrevious() {
    if (_currentQuestionIndex > 0) {
      setState(() => _currentQuestionIndex--);
    }
  }

  void _handleRetake() {
    setState(() {
      _attemptStates.clear();
      _currentQuestionIndex = 0;
      _assessmentComplete = false;
    });
  }

  void _navigateToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _showPalette = false;
    });
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    if (_assessmentComplete) return _buildResultView(design, context);

    final q = _questions[_currentQuestionIndex];
    final state = _stateFor(q.id);

    return Container(
      color: design.colors.surface,
      child: Stack(
        children: [
          Column(
            children: [
              AssessmentHeader(
                assessment: _assessment,
                answeredCount: _answeredCount,
                onExit: widget.onClose,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProgressSection(design, l10n),
                      _buildQuestionCard(design, l10n, q, state),
                      if (state.isChecked)
                        _buildFeedbackBlock(design, context, q),
                      SizedBox(height: design.spacing.md),
                      _buildActions(design, context, q, state),
                      SizedBox(height: design.spacing.md),
                      TestPaletteTrigger(
                        answeredCount: _checkedCount,
                        totalQuestions: _questions.length,
                        onTap: () => setState(() => _showPalette = true),
                      ),
                      SizedBox(height: design.spacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showPalette)
            AssessmentPalette(
              questions: _questions,
              states: _attemptStates,
              currentIndex: _currentQuestionIndex,
              onClose: () => setState(() => _showPalette = false),
              onQuestionSelected: _navigateToQuestion,
              isCorrectFn: _isAnswerCorrect,
            ),
        ],
      ),
    );
  }

  // ─── Progress section ────────────────────────────────────────────────────────

  Widget _buildProgressSection(DesignConfig design, AppLocalizations l10n) {
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
            l10n.testQuestionXofY(_currentQuestionIndex + 1, _questions.length),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: design.typographyScale.base.fontSize,
              color: design.colors.textPrimary,
            ),
          ),
          SizedBox(height: design.spacing.sm),
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(color: design.colors.divider),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentQuestionIndex + 1) / _questions.length,
              child: Container(
                decoration: BoxDecoration(color: design.colors.success),
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
    AssessmentAttemptState state,
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
          AppText.body(
            q.text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: design.colors.textPrimary,
            ),
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
            final isSelected = state.selectedOptions.contains(option.id);
            final isCorrect = _isOptionCorrect(q, option.id);
            final isIncorrect = state.isChecked && isSelected && !isCorrect;
            return OptionCard(
              option: QuestionOption(id: option.id, text: option.text),
              isSelected: isSelected || (state.isChecked && isCorrect),
              type: q.type == AssessmentQuestionType.multipleSelect
                  ? QuestionType.multipleSelect
                  : QuestionType.mcq,
              onTap: state.isChecked
                  ? null
                  : () => _handleOptionSelect(q, option.id),
              showFeedback: state.isChecked,
              isCorrect: state.isChecked && isCorrect,
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
  ) {
    final l10n = L10n.of(context);
    final isCorrect = _isAnswerCorrect(q);

    // We use the amber subject palette (index 6) which perfectly matches
    // the "slight yellow/amber" look in the design system.
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
          if (q.explanation != null) ...[
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
                  child: AppText.body(
                    q.explanation!,
                    color: design.colors.textPrimary,
                    style: const TextStyle(height: 1.55, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
          // "Try Again" button
          if (!isCorrect) ...[
            SizedBox(height: design.spacing.md),
            GestureDetector(
              onTap: _handleTryAgain,
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
    AssessmentAttemptState state,
  ) {
    final l10n = L10n.of(context);
    final isLast = _currentQuestionIndex == _questions.length - 1;
    final canGoPrev = _currentQuestionIndex > 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // State 2: answer selected but not yet checked — show ONLY Check Answer
          if (state.isAnswered && !state.isChecked)
            GestureDetector(
              onTap: _handleCheckAnswer,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                decoration: BoxDecoration(
                  color: design.colors.success,
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: Center(
                  child: AppText.body(
                    l10n.assessmentCheckAnswer,
                    color: design.colors.textInverse,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            )
          // States 1 & 3: nothing selected OR already checked → show Prev/Next
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavBtn(
                  design,
                  l10n.testPrevious,
                  LucideIcons.chevronLeft,
                  canGoPrev ? _handlePrevious : null,
                  isBack: true,
                ),
                _buildNavBtn(
                  design,
                  isLast ? l10n.testFinish : l10n.assessmentNext,
                  isLast ? LucideIcons.checkCircle2 : LucideIcons.chevronRight,
                  _handleNext,
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Verbatim copy of TestNavigationActions._buildNavButton
  Widget _buildNavBtn(
    DesignConfig design,
    String label,
    IconData icon,
    VoidCallback? onTap, {
    bool isBack = false,
  }) {
    final bool isDisabled = onTap == null;
    final Color bgColor = isBack || isDisabled
        ? design.colors.card
        : design.colors.textPrimary;
    final Color textColor = isDisabled
        ? design.colors.border
        : (isBack ? design.colors.textPrimary : design.colors.textInverse);
    final Color borderColor = isDisabled
        ? design.colors.border.withValues(alpha: 0.5)
        : (isBack ? design.colors.textSecondary : design.colors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isBack) ...[
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 8),
            ],
            AppText.body(
              label,
              color: textColor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            if (!isBack) ...[
              const SizedBox(width: 8),
              Icon(icon, color: textColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Result view ─────────────────────────────────────────────────────────────

  Widget _buildResultView(DesignConfig design, BuildContext context) {
    final l10n = L10n.of(context);
    final scorePercent = (_correctCount / _questions.length * 100).round();
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
                        l10n.testScoreSummary(_correctCount, _questions.length),
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: design.spacing.xl),
                GestureDetector(
                  onTap: _handleRetake,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                    decoration: BoxDecoration(
                      color: design.colors.textPrimary,
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.refreshCw,
                          color: design.colors.textInverse,
                          size: 20,
                        ),
                        SizedBox(width: design.spacing.sm),
                        AppText.body(
                          l10n.testRetake,
                          color: design.colors.textInverse,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: design.spacing.md),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: design.colors.border),
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: Center(
                      child: AppText.headline(
                        l10n.testBackToChapter, // Assuming this was the intended text
                        style: TextStyle(
                          fontSize: design.typographyScale.xl.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
