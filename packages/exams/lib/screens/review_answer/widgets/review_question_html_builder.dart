import 'dart:developer' as dev;
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Builds the unified HTML payload for a question card in review mode.
///
/// After a test is submitted, each question is displayed with colour-coded
/// options (green = correct, red = wrong selection) and an optional
/// explanation section.  Everything is merged into a single HTML document
/// so that MathJax initialises only once per card.
abstract final class ReviewQuestionHtmlBuilder {
  /// Returns a complete, self-contained HTML string for [question].
  ///
  /// [attemptState] is the user's recorded answer; may be null for
  /// unanswered questions.  [l10n] is used for the explanation label.
  static String build({
    required QuestionDto question,
    required AnswerDto? attemptState,
    QuizReviewResultDto? quizReview,
    required DesignConfig design,
    required AppLocalizations l10n,
  }) {
    // ── Theme colour tokens ────────────────────────────────────────────────
    final borderColor = _hex(design.colors.border);
    final textPrimary = _hex(design.colors.textPrimary);
    final textSecondary = _hex(design.colors.textSecondary);
    final cardColor = _hex(design.colors.card);
    final correctColor = _hex(design.colors.accent4);
    final correctBg = _rgba(design.colors.accent4, design.isDark ? 0.15 : 0.08);
    final incorrectColor = _hex(design.colors.accent5);
    final incorrectBg = _rgba(
      design.colors.accent5,
      design.isDark ? 0.15 : 0.08,
    );

    // ── Evaluate exact correctness ─────────────────────────────────────────
    final selectedIds = attemptState?.selectedOptions.map((e) => e.toString()).toList() ?? [];
    selectedIds.sort();

    List<String> correctIds;

    if (quizReview != null && quizReview.correctAnswers.isNotEmpty) {
      correctIds = quizReview.correctAnswers.map((e) => e.toString()).toList();
    } else {
      correctIds = (question.correctOptionIds.isNotEmpty
              ? question.correctOptionIds
              : question.options
                  .where((opt) => opt.isCorrect)
                  .map((opt) => opt.id)
                  .toList())
          .map((e) => e.toString())
          .toList();
    }
    correctIds.sort();
    final isAnswerCorrect = selectedIds.join(',') == correctIds.join(',');
    dev.log(
      'Review builder: '
      'questionId=${question.id}, '
      'selectedIds=$selectedIds, '
      'correctIds=$correctIds, '
      'hasQuizReview=${quizReview != null}, '
      'quizReviewResult=${quizReview?.result}, '
      'quizReviewSelected=${quizReview?.selectedAnswers}, '
      'quizReviewCorrect=${quizReview?.correctAnswers}',
      name: 'ReviewQuestionHtmlBuilder',
    );

    final sb = StringBuffer();

    // ── Question text ──────────────────────────────────────────────────────
    sb.writeln('<div class="review-container">');
    sb.writeln('<div class="question-text">${question.text}</div>');

    // ── Colour-coded options ───────────────────────────────────────────────
    sb.writeln('<div class="options-container">');
    for (final opt in question.options) {
      final isCorrect = correctIds.any((id) => id.toString() == opt.id.toString());
      final isSelected = attemptState?.selectedOptions.any((id) => id.toString() == opt.id.toString()) ?? false;
      final isActive   = isCorrect || isSelected;

      // Border, background and text colour per option state
      final optBorder = isCorrect
          ? correctColor
          : (isSelected ? incorrectColor : borderColor);
      final optBg = isCorrect
          ? correctBg
          : (isSelected ? incorrectBg : cardColor);
      final optTextColor = isActive ? textPrimary : textSecondary;
      final indicatorColor = isCorrect ? correctColor : incorrectColor;

      // Trailing icon: ✓ for correct, ✗ for wrong selection, empty otherwise
      final iconHtml = isCorrect
          ? '<span style="color: $correctColor; margin-left: 12px; font-weight: bold; font-size: 18px;">✓</span>'
          : isSelected
          ? '<span style="color: $incorrectColor; margin-left: 12px; font-weight: bold; font-size: 18px;">✗</span>'
          : '';

      sb.writeln('''
        <div class="option-item" style="border-color: $optBorder; background-color: $optBg; border-width: ${isActive ? '1.5px' : '1px'};">
          <div class="indicator" style="border-color: ${isActive ? indicatorColor : borderColor}; background-color: ${isActive ? indicatorColor : cardColor};">
            ${isActive ? '<div class="inner"></div>' : ''}
          </div>
          <div class="option-text" style="color: $optTextColor;">
            ${opt.text}
          </div>
          $iconHtml
        </div>
      ''');
    }
    sb.writeln('</div>');

    // ── Feedback Banner ────────────────────────────────────────────────────
    final amberAccent = _hex(design.subjectPalette.atIndex(6).accent);
    final amberBg     = _hex(design.subjectPalette.atIndex(6).background);
    final amberFg     = _hex(design.subjectPalette.atIndex(6).foreground);
    final successColor = _hex(design.colors.success);
    final successBg    = _rgba(design.colors.success, 0.07);

    final feedbackIcon = isAnswerCorrect ? '✓' : '✗';
    final feedbackColor = isAnswerCorrect ? successColor : amberFg;
    final feedbackIconColor = isAnswerCorrect ? successColor : amberAccent;
    final feedbackBgColor = isAnswerCorrect ? successBg : amberBg;
    final feedbackBorder = isAnswerCorrect 
        ? _rgba(design.colors.success, 0.3) 
        : _rgba(design.subjectPalette.atIndex(6).accent, 0.4);
    final feedbackLabel = isAnswerCorrect ? l10n.assessmentCorrect : l10n.assessmentIncorrect;

    sb.writeln('''
      <div class="feedback-banner" style="background-color: $feedbackBgColor; border-color: $feedbackBorder;">
        <span class="feedback-icon" style="color: $feedbackIconColor;">$feedbackIcon</span>
        <span class="feedback-text" style="color: $feedbackColor;">$feedbackLabel</span>
      </div>
    ''');

    // ── Explanation (if present) ───────────────────────────────────────────
    final explanationContent = (quizReview != null && quizReview.explanationHtml != null && quizReview.explanationHtml!.isNotEmpty)
        ? quizReview.explanationHtml!
        : question.explanation;

    if (explanationContent != null && explanationContent.isNotEmpty) {
      final explBg     = _rgba(design.colors.accent2, design.isDark ? 0.18 : 0.12);
      final explBorder = _rgba(design.colors.accent2, design.isDark ? 0.40 : 0.35);
      final explTitle  = _hex(design.colors.accent2);

      sb.writeln('''
        <div class="explanation-box" style="background-color: $explBg; border-color: $explBorder;">
          <div class="explanation-title" style="color: $explTitle;">${l10n.assessmentExplanation}</div>
          <div class="explanation-text" style="color: $textSecondary;">
            $explanationContent
          </div>
        </div>
      ''');
    }

    sb.writeln('</div>');

    return _css(cardColor: cardColor, textPrimary: textPrimary) + sb.toString();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  static String _hex(Color color) {
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }

  static String _rgba(Color color, double alpha) {
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    return 'rgba($r, $g, $b, $alpha)';
  }

  static String _css({
    required String cardColor,
    required String textPrimary,
  }) =>
      '''
      <style>
        body {
          background-color: $cardColor;
          color: $textPrimary;
          margin: 0;
          padding: 0;
          font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        .review-container  { padding-bottom: 20px; }
        .question-text     { font-size: 16px; margin-bottom: 24px; }
        .options-container { margin-bottom: 16px; }
        .option-item {
          display: flex;
          align-items: center;
          margin-bottom: 12px;
          padding: 16px;
          border-radius: 16px;
          border-style: solid;
        }
        .indicator {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 24px;
          height: 24px;
          border-radius: 50%;
          border-style: solid;
          border-width: 2px;
          margin-right: 12px;
          flex-shrink: 0;
        }
        .indicator .inner {
          width: 8px;
          height: 8px;
          border-radius: 50%;
          background-color: #ffffff;
        }
        .option-text     { flex: 1; font-size: 15px; }
        .option-text p   { margin: 0; }
        .explanation-box {
          margin-top: 16px;
          padding: 16px;
          border-radius: 8px;
          border-style: solid;
          border-width: 1px;
        }
        .explanation-title { font-weight: 600; margin-bottom: 8px; }
        .explanation-text  { font-size: 14px; }
        .feedback-banner {
          display: flex;
          align-items: center;
          padding: 16px;
          border-radius: 8px;
          border-style: solid;
          border-width: 1px;
        }
        .feedback-icon { font-weight: bold; font-size: 18px; margin-right: 8px; }
        .feedback-text { font-weight: bold; font-size: 15px; }
        .mjx-chtml         { color: inherit !important; }
      </style>
    ''';
}
