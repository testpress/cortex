import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Builds the unified HTML payload for a single exam question card.
///
/// Combines the question text and all options into one HTML document so
/// that a single [AppHtml] / WebView handles MathJax initialisation once
/// per question instead of once per widget (question text + N options).
///
/// The generated HTML includes:
///   - Question text (may contain MathJax / rich HTML from the API)
///   - All option rows with radio / checkbox indicators
///   - A `selectOption` JS function that posts the selected option ID back
///     to Flutter via the `MessageChannel` JS channel.
abstract final class TestQuestionHtmlBuilder {
  /// Returns a complete HTML string for [question], reflecting the currently
  /// selected [answer] and styled using [design] tokens.
  static String build({
    required QuestionDto question,
    required AnswerDto? answer,
    required DesignConfig design,
    required BuildContext context,
  }) {
    final borderColor = _hex(design.colors.border);
    final cardColor = _hex(design.colors.card);
    final textPrimary = _hex(design.colors.textPrimary);
    final primaryColor = _hex(design.colors.primary);

    final sb = StringBuffer();

    // ── Question text ──────────────────────────────────────────────────────
    sb.writeln('<div class="question-container">');
    sb.writeln('<div class="question-text">');
    sb.writeln(question.text);
    sb.writeln('</div>');

    // "Select all that apply" hint for multi-select questions
    if (question.type == 'multipleSelect') {
      sb.writeln(
        '<div style="font-size: 12px; font-style: italic; color: #888; '
        'margin-bottom: ${design.spacing.md}px;">'
        '${L10n.of(context).testSelectAllApply}</div>',
      );
    }

    if (question.type == 'shortAnswer') {
      final value = (answer?.shortText ?? '')
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;');
      sb.writeln('''
        <div class="input-container">
          <input class="edit_box" type="text" inputmode="text" placeholder="YOUR ANSWER"
                 value="$value"
                 oninput="onInputChange(this.value)">
        </div>
      ''');
    } else if (question.type == 'numerical') {
      final value = (answer?.shortText ?? '')
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;');
      sb.writeln('''
        <div class="input-container">
          <input class="edit_box" type="text" inputmode="decimal" placeholder="YOUR ANSWER"
                 value="$value"
                 oninput="onNumericalChange(this)">
        </div>
      ''');
    } else if (question.type == 'essay') {
      final value = (answer?.essayText ?? '')
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;');
      sb.writeln('''
        <div class="input-container">
          <textarea class="essay_box" rows="10" placeholder="YOUR ANSWER"
                    oninput="onInputChange(this.value)">$value</textarea>
        </div>
      ''');
    } else {
      // ── Options (MCQ) ────────────────────────────────────────────────────────────
      sb.writeln('<div class="options-container">');
      for (final option in question.options) {
        final isSelected =
            answer?.selectedOptions.any(
              (id) => id.toString() == option.id.toString(),
            ) ??
            false;
        final indicatorType = question.type == 'multipleSelect'
            ? 'checkbox'
            : 'radio';

        sb.writeln('''
          <div class="option-card ${isSelected ? 'selected' : ''}"
               onclick="selectOption('${option.id}', '${question.type}')"
               id="option-${option.id}">
            <div class="indicator $indicatorType">
              <div class="inner"></div>
            </div>
            <div class="option-text">
              ${option.text}
            </div>
          </div>
        ''');
      }
      sb.writeln('</div>');
    }
    sb.writeln('</div>');

    return _css(
          cardColor: cardColor,
          textPrimary: textPrimary,
          borderColor: borderColor,
          primaryColor: primaryColor,
          design: design,
        ) +
        sb.toString() +
        _js();
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

  static String _css({
    required String cardColor,
    required String textPrimary,
    required String borderColor,
    required String primaryColor,
    required DesignConfig design,
  }) =>
      '''
      <style>
        body {
          background-color: $cardColor;
          color: $textPrimary;
          margin: 0;
          padding: 0;
        }
        .option-card {
          display: flex;
          align-items: center;
          margin-bottom: ${design.spacing.md}px;
          padding: ${design.spacing.md}px;
          background-color: transparent;
          border-radius: ${design.radius.md}px;
          border: 1.5px solid $borderColor;
          cursor: pointer;
          -webkit-tap-highlight-color: transparent;
          transition: border-color 0.2s, background-color 0.2s;
        }
        .option-card.selected {
          border-color: $primaryColor;
          background-color: transparent;
        }
        .indicator {
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: ${design.spacing.md}px;
          border: 2px solid $borderColor;
          flex-shrink: 0;
        }
        .option-card.selected .indicator {
          border-color: $primaryColor;
        }
        .indicator.radio {
          width: 20px;
          height: 20px;
          border-radius: 50%;
        }
        .indicator.checkbox {
          width: 20px;
          height: 20px;
          border-radius: ${design.radius.sm}px;
        }
        .option-card.selected .indicator.radio .inner {
          width: 10px;
          height: 10px;
          background-color: $primaryColor;
          border-radius: 50%;
        }
        .option-card.selected .indicator.checkbox {
          background-color: $primaryColor;
        }
        .option-card.selected .indicator.checkbox::after {
          content: '✓';
          color: white;
          font-size: 12px;
          font-weight: bold;
        }
        .option-text {
          flex: 1;
          font-size: 16px;
          color: $textPrimary;
          pointer-events: none;
        }
        .option-text p { margin: 0; }
        .mjx-chtml { color: inherit !important; }
        
        /* Input questions */
        .edit_box, .essay_box {
          width: 100%;
          box-sizing: border-box;
          padding: ${design.spacing.md}px;
          margin-top: ${design.spacing.md}px;
          background-color: transparent;
          border-radius: ${design.radius.md}px;
          border: 1.5px solid $borderColor;
          color: $textPrimary;
          font-size: 16px;
          font-family: inherit;
        }
        .edit_box:focus, .essay_box:focus {
          outline: none;
          border-color: $primaryColor;
        }
      </style>
    ''';

  /// JS that toggles option selection and posts the option ID to Flutter
  /// via the `MessageChannel` JS channel registered in [AppHtml].
  static String _js() => '''
      <script>
        function selectOption(id, type) {
          if (type === 'multipleSelect') {
            document.getElementById('option-' + id).classList.toggle('selected');
          } else {
            var cards = document.getElementsByClassName('option-card');
            for (var i = 0; i < cards.length; i++) {
              cards[i].classList.remove('selected');
            }
            document.getElementById('option-' + id).classList.add('selected');
          }
          if (window.MessageChannel) {
            MessageChannel.postMessage(JSON.stringify({ type: 'optionSelect', id: id.toString() }));
          }
        }
        
        function onInputChange(val) {
          if (window.MessageChannel) {
            MessageChannel.postMessage(JSON.stringify({ type: 'inputChange', value: val }));
          }
        }
        
        function onNumericalChange(input) {
          var val = input.value;
          val = val.replace(/,/g, '');
          var hasNegative = val.startsWith('-');
          val = val.replace(/-/g, '');
          var parts = val.split('.');
          if (parts.length > 1) {
            val = parts[0] + '.' + parts.slice(1).join('');
          }
          if (hasNegative) val = '-' + val;
          input.value = val;
          onInputChange(val);
        }
      </script>
    ''';
}
