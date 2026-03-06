import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/test_model.dart';
import '../widgets/exam_review/review_question_list_item.dart';
import 'package:flutter/foundation.dart'; // for listEquals

enum ReviewFilter { all, correct, incorrect, unanswered }

class ExamReviewScreen extends StatefulWidget {
  final String assessmentTitle;
  final List<TestQuestion> questions;
  final Map<String, TestAttemptAnswer> attemptStates;
  final VoidCallback onBack;

  const ExamReviewScreen({
    super.key,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    required this.onBack,
  });

  @override
  State<ExamReviewScreen> createState() => _ExamReviewScreenState();
}

class _ExamReviewScreenState extends State<ExamReviewScreen> {
  ReviewFilter _activeFilter = ReviewFilter.all;

  bool _isAnswerCorrect(TestQuestion q) {
    final state = widget.attemptStates[q.id];
    if (state == null || state.selectedOptions.isEmpty) return false;
    final selected = List<String>.from(state.selectedOptions)..sort();
    final correct = List<String>.from(q.correctOptionIds)..sort();
    return listEquals(selected, correct);
  }

  bool _isUnanswered(TestQuestion q) {
    final state = widget.attemptStates[q.id];
    return state == null || state.selectedOptions.isEmpty;
  }

  List<TestQuestion> get _filteredQuestions {
    switch (_activeFilter) {
      case ReviewFilter.all:
        return widget.questions;
      case ReviewFilter.correct:
        return widget.questions.where((q) => _isAnswerCorrect(q)).toList();
      case ReviewFilter.incorrect:
        return widget.questions
            .where((q) => !_isAnswerCorrect(q) && !_isUnanswered(q))
            .toList();
      case ReviewFilter.unanswered:
        return widget.questions.where((q) => _isUnanswered(q)).toList();
    }
  }

  int _countFor(ReviewFilter filter) {
    switch (filter) {
      case ReviewFilter.all:
        return widget.questions.length;
      case ReviewFilter.correct:
        return widget.questions.where((q) => _isAnswerCorrect(q)).length;
      case ReviewFilter.incorrect:
        return widget.questions
            .where((q) => !_isAnswerCorrect(q) && !_isUnanswered(q))
            .length;
      case ReviewFilter.unanswered:
        return widget.questions.where((q) => _isUnanswered(q)).length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final filtered = _filteredQuestions;

    return Container(
      color: design.colors.surface,
      child: Column(
        children: [
          _buildHeader(design, l10n),
          _buildFilterBar(design, l10n),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState(design, l10n)
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: design.spacing.xl),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final q = filtered[index];
                      return ReviewQuestionListItem(
                        index: q.number,
                        question: q,
                        isCorrect: _isAnswerCorrect(q),
                        isUnanswered: _isUnanswered(q),
                        attemptState: widget.attemptStates[q.id],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(DesignConfig design, AppLocalizations l10n) {
    return Container(
      color: design.colors.card,
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onBack,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(design.spacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.chevronLeft,
                    color: design.colors.textPrimary,
                    size: 24,
                  ),
                  SizedBox(width: design.spacing.xs),
                  AppText.body(
                    l10n.curriculumBackButton,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: design.spacing.md),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
            child: AppText.headline(
              "${l10n.examReviewTitle} - ${widget.assessmentTitle}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(DesignConfig design, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AppText.body(
              l10n.labelFilter,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: design.colors.textSecondary,
                fontSize: 14,
              ),
            ),
            SizedBox(width: design.spacing.sm),
            _buildFilterChip(ReviewFilter.all, l10n.filterAll, design),
            SizedBox(width: design.spacing.xs),
            _buildFilterChip(
              ReviewFilter.correct,
              l10n.examReviewFilterCorrect,
              design,
            ),
            SizedBox(width: design.spacing.xs),
            _buildFilterChip(
              ReviewFilter.incorrect,
              l10n.examReviewFilterWrong,
              design,
            ),
            SizedBox(width: design.spacing.xs),
            _buildFilterChip(
              ReviewFilter.unanswered,
              l10n.examReviewFilterUnanswered,
              design,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    ReviewFilter filter,
    String label,
    DesignConfig design,
  ) {
    final isSelected = _activeFilter == filter;
    final count = _countFor(filter);

    return GestureDetector(
      onTap: () => setState(() => _activeFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? design.colors.textPrimary : design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(
            color: isSelected
                ? design.colors.textPrimary
                : design.colors.border,
          ),
        ),
        child: AppText.caption(
          "$label ($count)",
          color: isSelected
              ? design.colors.textInverse
              : design.colors.textPrimary,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyState(DesignConfig design, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.search,
            color: design.colors.textSecondary,
            size: 48,
          ),
          SizedBox(height: design.spacing.md),
          AppText.body(
            l10n.reviewEmptyStateMessage,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}
