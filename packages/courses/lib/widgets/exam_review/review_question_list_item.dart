import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/test_model.dart';
import 'package:flutter/foundation.dart'; // for listEquals

class ReviewQuestionListItem extends StatefulWidget {
  final int index;
  final TestQuestion question;
  final TestAttemptAnswer? attemptState;
  final bool isInitiallyExpanded;

  const ReviewQuestionListItem({
    super.key,
    required this.index,
    required this.question,
    this.attemptState,
    this.isInitiallyExpanded = false,
  });

  @override
  State<ReviewQuestionListItem> createState() => _ReviewQuestionListItemState();
}

class _ReviewQuestionListItemState extends State<ReviewQuestionListItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
  }

  bool _isCorrect() {
    if (widget.attemptState == null ||
        widget.attemptState!.selectedOptions.isEmpty) {
      return false;
    }
    final selected = List<String>.from(widget.attemptState!.selectedOptions)
      ..sort();
    final correct = List<String>.from(widget.question.correctOptionIds)..sort();
    return listEquals(selected, correct);
  }

  bool _isUnanswered() =>
      widget.attemptState == null ||
      widget.attemptState!.selectedOptions.isEmpty;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isCorrect = _isCorrect();
    final isUnanswered = _isUnanswered();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border),
      ),
      child: Column(
        children: [
          _buildHeader(design, l10n, isCorrect, isUnanswered),
          if (_isExpanded) _buildContent(design, l10n, isCorrect, isUnanswered),
        ],
      ),
    );
  }

  Widget _buildHeader(
    DesignConfig design,
    AppLocalizations l10n,
    bool isCorrect,
    bool isUnanswered,
  ) {
    IconData statusIcon;
    Color statusColor;
    String statusLabel;
    Color badgeBg;
    Color badgeText;

    if (isUnanswered) {
      statusIcon = LucideIcons.circle;
      statusColor = design.colors.textSecondary;
      statusLabel = l10n.examReviewFilterUnanswered;
      badgeBg = design.colors.surface;
      badgeText = design.colors.textSecondary;
    } else if (isCorrect) {
      statusIcon = LucideIcons.checkCircle2;
      statusColor = design.colors.success;
      statusLabel = l10n.assessmentCorrect; // "Correct!"
      badgeBg = design.colors.success.withValues(alpha: 0.1);
      badgeText = design.colors.success;
    } else {
      statusIcon = LucideIcons.xCircle;
      statusColor = design.colors.error;
      statusLabel = l10n.assessmentIncorrect;
      statusLabel = isCorrect
          ? "Correct"
          : (isUnanswered ? "Unanswered" : "Incorrect");
      badgeBg = isCorrect
          ? design.colors.success.withValues(alpha: 0.1)
          : (isUnanswered
                ? design.colors.surface
                : design.colors.error.withValues(alpha: 0.1));
      badgeText = isCorrect
          ? design.colors.success
          : (isUnanswered ? design.colors.textSecondary : design.colors.error);
    }

    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(design.spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(statusIcon, color: statusColor, size: 20),
            ),
            SizedBox(width: design.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.body(
                        "Question ${widget.index}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      _buildBadge(statusLabel, badgeBg, badgeText, design),
                    ],
                  ),
                  SizedBox(height: design.spacing.xs),
                  AppText.body(
                    widget.question.text,
                    maxLines: _isExpanded ? null : 2,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                    style: TextStyle(
                      color: design.colors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: design.spacing.xs),
            Icon(
              _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
              color: design.colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color text, DesignConfig design) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(design.radius.xl),
      ),
      child: AppText.caption(
        label,
        color: text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _buildContent(
    DesignConfig design,
    AppLocalizations l10n,
    bool isCorrect,
    bool isUnanswered,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        0,
        design.spacing.md,
        design.spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: design.colors.border,
            margin: EdgeInsets.only(bottom: design.spacing.md),
          ),

          // Your Answer Section
          _buildAnswerLabel(l10n.examReviewYourAnswerLabel, design),
          SizedBox(height: design.spacing.xs),
          _buildAnswerText(
            isUnanswered
                ? "Not answered"
                : widget.question.options
                      .where(
                        (o) =>
                            widget.attemptState!.selectedOptions.contains(o.id),
                      )
                      .map((o) => o.text)
                      .join(", "),
            isUnanswered
                ? design.colors.textSecondary
                : (isCorrect ? design.colors.success : design.colors.error),
            design,
            isItalic: isUnanswered,
          ),

          SizedBox(height: design.spacing.md),

          // Correct Answer Section
          _buildAnswerLabel(l10n.examReviewCorrectAnswerLabel, design),
          SizedBox(height: design.spacing.xs),
          _buildAnswerText(
            widget.question.options
                .where((o) => widget.question.correctOptionIds.contains(o.id))
                .map((o) => o.text)
                .join(", "),
            design.colors.success,
            design,
          ),

          if (widget.question.explanation != null) ...[
            SizedBox(height: design.spacing.lg),
            _buildExplanationBlock(widget.question.explanation!, design, l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerLabel(String label, DesignConfig design) {
    return AppText.caption(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: design.colors.textSecondary,
        fontSize: 12,
      ),
    );
  }

  Widget _buildAnswerText(
    String text,
    Color color,
    DesignConfig design, {
    bool isItalic = false,
  }) {
    return AppText.body(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        fontStyle: isItalic ? FontStyle.italic : null,
      ),
    );
  }

  Widget _buildExplanationBlock(
    String text,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.lightbulb,
                color: design.colors.primary,
                size: 16,
              ),
              SizedBox(width: design.spacing.xs),
              AppText.caption(
                l10n.assessmentExplanation,
                color: design.colors.primary,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: design.spacing.sm),
          AppText.body(
            text,
            style: TextStyle(
              color: design.colors.textPrimary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
