import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import './palette_shapes.dart';

/// The visual style for a single palette item square.
class PaletteItemStyle {
  final Color? fillColor;
  final Color? borderColor;
  final Color textColor;

  const PaletteItemStyle({
    this.fillColor,
    this.borderColor,
    required this.textColor,
  });
}

/// A single entry in the palette legend row.
class PaletteLegendEntry {
  final Widget shape;
  final String label;

  const PaletteLegendEntry({required this.shape, required this.label});
}

/// Defines how a [QuestionPalette] should color its items and render its legend.
/// Implement this to support different palette contexts (active test, review, etc.)
abstract class PaletteColorStrategy {
  /// Returns the style for a single question square given its current state.
  PaletteItemStyle styleFor(
    QuestionDto question,
    AnswerDto? answer,
    DesignConfig design,
  );

  /// The legend entries to display above the grid.
  List<PaletteLegendEntry> legendEntries(
    DesignConfig design,
    AppLocalizations l10n,
  );

  /// Returns the number of answered questions to show in the palette header,
  /// or null if the count should not be shown (e.g. review mode).
  int? answeredCount(
    List<QuestionDto> questions,
    Map<String, AnswerDto> answers,
  );
}

// ---------------------------------------------------------------------------
// TestTakingStrategy — active exam context
// ---------------------------------------------------------------------------

/// Colors items based on test-taking state: answered, marked, not visited.
class TestTakingStrategy implements PaletteColorStrategy {
  const TestTakingStrategy();

  @override
  PaletteItemStyle styleFor(
    QuestionDto question,
    AnswerDto? answer,
    DesignConfig design,
  ) {
    final isSelected = answer != null && answer.selectedOptions.isNotEmpty;
    final isMarked = answer?.isMarked ?? false;

    if (isSelected && isMarked) {
      return PaletteItemStyle(
        fillColor: design.colors.accent1,
        textColor: design.colors.textInverse,
      );
    } else if (isMarked) {
      return PaletteItemStyle(
        fillColor: design.colors.accent3,
        textColor: design.colors.textInverse,
      );
    } else if (isSelected) {
      return PaletteItemStyle(
        fillColor: design.colors.success,
        textColor: design.colors.textInverse,
      );
    } else {
      return PaletteItemStyle(
        borderColor: design.colors.border,
        textColor: design.colors.textSecondary,
      );
    }
  }

  @override
  List<PaletteLegendEntry> legendEntries(
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    return [
      PaletteLegendEntry(
        shape: SquareShape(borderColor: design.colors.border, size: 18),
        label: l10n.testStatusNotVisited,
      ),
      PaletteLegendEntry(
        shape: SquareShape(color: design.colors.success, size: 18),
        label: l10n.testStatusAnswered,
      ),
      PaletteLegendEntry(
        shape: SquareShape(color: design.colors.accent3, size: 18),
        label: l10n.testStatusMarked,
      ),
      PaletteLegendEntry(
        shape: SquareShape(color: design.colors.accent1, size: 18),
        label: l10n.testStatusAnsweredMarked,
      ),
    ];
  }

  @override
  int? answeredCount(
    List<QuestionDto> questions,
    Map<String, AnswerDto> answers,
  ) {
    return questions.where((q) {
      final a = answers[q.id];
      if (a == null) return false;
      if (q.type == 'shortAnswer' || q.type == 'numerical') {
        return (a.shortText ?? '').trim().isNotEmpty;
      }
      if (q.type == 'essay') {
        return (a.essayText ?? '').trim().isNotEmpty;
      }
      return a.selectedOptions.isNotEmpty;
    }).length;
  }
}

// ---------------------------------------------------------------------------
// ReviewStrategy — post-exam review context
// ---------------------------------------------------------------------------

/// Colors items based on evaluation result: correct, incorrect, unanswered.
class ReviewStrategy implements PaletteColorStrategy {
  final bool Function(QuestionDto) isAnswerCorrect;
  final bool Function(QuestionDto) isUnanswered;

  const ReviewStrategy({
    required this.isAnswerCorrect,
    required this.isUnanswered,
  });

  @override
  PaletteItemStyle styleFor(
    QuestionDto question,
    AnswerDto? answer,
    DesignConfig design,
  ) {
    if (isUnanswered(question)) {
      return PaletteItemStyle(
        borderColor: design.colors.border,
        textColor: design.colors.textSecondary,
      );
    } else if (isAnswerCorrect(question)) {
      return PaletteItemStyle(
        fillColor: design.colors.success,
        textColor: design.colors.textInverse,
      );
    } else {
      return PaletteItemStyle(
        fillColor: design.colors.error,
        textColor: design.colors.textInverse,
      );
    }
  }

  @override
  List<PaletteLegendEntry> legendEntries(
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    return [
      PaletteLegendEntry(
        shape: SquareShape(color: design.colors.success, size: 18),
        label: l10n.analyticsCorrect,
      ),
      PaletteLegendEntry(
        shape: SquareShape(color: design.colors.error, size: 18),
        label: l10n.analyticsIncorrect,
      ),
      PaletteLegendEntry(
        shape: SquareShape(borderColor: design.colors.border, size: 18),
        label: l10n.analyticsUnanswered,
      ),
    ];
  }

  @override
  int? answeredCount(
    List<QuestionDto> questions,
    Map<String, AnswerDto> answers,
  ) => null; // Not shown in review mode
}
