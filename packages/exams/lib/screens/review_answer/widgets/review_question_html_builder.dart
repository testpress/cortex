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
    final selectedIds =
        attemptState?.selectedOptions.map((e) => e.toString()).toList() ?? [];
    selectedIds.sort();

    List<String> correctIds;

    if (quizReview != null && quizReview.correctAnswers.isNotEmpty) {
      correctIds = quizReview.correctAnswers.map((e) => e.toString()).toList();
    } else {
      correctIds =
          (question.correctOptionIds.isNotEmpty
                  ? question.correctOptionIds
                  : question.options
                        .where((opt) => opt.isCorrect)
                        .map((opt) => opt.id)
                        .toList())
              .map((e) => e.toString())
              .toList();
    }
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

    final isInputType =
        question.type == 'shortAnswer' ||
        question.type == 'numerical' ||
        question.type == 'essay';

    if (isInputType) {
      final userValue =
          (question.type == 'essay'
              ? attemptState?.essayText
              : attemptState?.shortText) ??
          '';

      final hasResult =
          quizReview?.result ??
          (attemptState?.result != null
              ? (attemptState!.result!.toLowerCase() == 'correct' ||
                    attemptState.result == '1')
              : null);

      bool isCorrect;
      if (hasResult != null) {
        isCorrect = hasResult;
      } else if (question.type == 'shortAnswer' ||
          question.type == 'numerical') {
        final userAns = userValue.trim().toLowerCase();
        if (userAns.isEmpty) {
          isCorrect = false;
        } else {
          final correctOptions = question.options
              .where((o) => o.isCorrect)
              .toList();
          final correctValues = correctOptions.isNotEmpty
              ? correctOptions.map((o) => o.text).toList()
              : question.options.map((o) => o.text).toList();
          isCorrect = correctValues.any((val) {
            final cleanVal = val
                .replaceAll(RegExp(r'<[^>]*>'), '')
                .replaceAll('&nbsp;', ' ')
                .replaceAll('&amp;', '&')
                .replaceAll('&lt;', '<')
                .replaceAll('&gt;', '>')
                .replaceAll('&quot;', '"')
                .replaceAll('&#39;', "'")
                .trim()
                .toLowerCase();
            return cleanVal == userAns;
          });
        }
      } else {
        isCorrect = false;
      }

      bool isUnansw;
      if (attemptState?.result != null) {
        final res = attemptState!.result!.toLowerCase();
        isUnansw =
            res == 'unanswered' ||
            res == 'unvisited' ||
            res == '0' ||
            res == '3';
      } else if (question.type == 'shortAnswer' ||
          question.type == 'numerical') {
        isUnansw = userValue.trim().isEmpty;
      } else if (question.type == 'essay') {
        isUnansw = userValue.trim().isEmpty;
      } else {
        isUnansw = selectedIds.isEmpty;
      }

      final borderColorStyle = isUnansw
          ? borderColor
          : (isCorrect ? correctColor : incorrectColor);
      final bgStyle = isUnansw
          ? cardColor
          : (isCorrect ? correctBg : incorrectBg);

      if (question.type == 'essay') {
        sb.writeln('''
          <div class="input-container" style="margin-bottom: 16px;">
            <textarea class="essay_box" rows="10" readonly disabled
                      style="border-color: $borderColorStyle; background-color: $bgStyle; resize: none;">$userValue</textarea>
          </div>
        ''');
      } else {
        sb.writeln('''
          <div class="input-container" style="margin-bottom: 16px;">
            <input class="edit_box" type="text" readonly disabled
                   style="border-color: $borderColorStyle; background-color: $bgStyle;"
                   value="${userValue.replaceAll('"', '&quot;')}">
          </div>
        ''');

        // Render the correct answer(s) below it
        final correctOptions = question.options
            .where((o) => o.isCorrect)
            .toList();
        final correctValues = correctOptions.isNotEmpty
            ? correctOptions.map((o) => o.text).toList()
            : question.options.map((o) => o.text).toList();
        if (correctValues.isNotEmpty) {
          sb.writeln('''
            <div style="margin-top: 12px; margin-bottom: 16px; font-size: 14px; color: $textSecondary;">
              <strong>Correct Answer:</strong>
              <div style="margin-top: 4px; padding: 8px; border-radius: 4px; background: $correctBg; border: 1px solid $correctColor; color: $textPrimary;">
                ${correctValues.join(', ')}
              </div>
            </div>
          ''');
        }
      }
    } else {
      // ── Colour-coded options ───────────────────────────────────────────────
      sb.writeln('<div class="options-container">');
      for (final opt in question.options) {
        final isCorrect = correctIds.any(
          (id) => id.toString() == opt.id.toString(),
        );
        final isSelected =
            attemptState?.selectedOptions.any(
              (id) => id.toString() == opt.id.toString(),
            ) ??
            false;
        final isActive = isCorrect || isSelected;

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
    }

    // ── Explanation (if present) ───────────────────────────────────────────
    final explanationContent =
        (quizReview != null &&
            quizReview.explanationHtml != null &&
            quizReview.explanationHtml!.isNotEmpty)
        ? quizReview.explanationHtml!
        : question.explanation;

    if (explanationContent != null && explanationContent.isNotEmpty) {
      final explBg = _rgba(design.colors.accent2, design.isDark ? 0.18 : 0.12);
      final explBorder = _rgba(
        design.colors.accent2,
        design.isDark ? 0.40 : 0.35,
      );
      final explTitle = _hex(design.colors.accent2);

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

    return _css(
          cardColor: cardColor,
          textPrimary: textPrimary,
          borderColor: borderColor,
        ) +
        sb.toString();
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
    required String borderColor,
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
        
        /* Input questions */
        .edit_box, .essay_box {
          width: 100%;
          box-sizing: border-box;
          padding: 12px;
          margin-top: 12px;
          background-color: transparent;
          border-radius: 8px;
          border: 1.5px solid $borderColor;
          color: $textPrimary;
          font-size: 16px;
          font-family: inherit;
        }
      </style>
    ''';
}
