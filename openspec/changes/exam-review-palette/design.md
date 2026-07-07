## Context

During an active exam, the `QuestionPalette` widget provides a bottom sheet grid that lets users quickly see all question statuses and jump to specific questions. However, during the post-exam review phase (on the `ReviewAnswerDetailScreen`), users are forced to navigate sequentially using 'Next' and 'Previous' buttons. This change introduces the same grid palette to the review screen, allowing users to jump directly to questions and see an overview of correctness.

## Goals / Non-Goals

**Goals:**
- Provide a non-sequential navigation option (the question palette) in the exam review screen.
- Reuse the existing `QuestionPalette` widget to ensure a consistent UX.
- Adapt the color-coding in `QuestionPalette` to reflect review statuses (Correct, Incorrect, Unattempted) when used in a review context.

**Non-Goals:**
- We are not rewriting the entire review flow.
- We are not altering how active exams function.

## Decisions

**1. Mode Flag vs Separate Widget:**
- *Decision:* Introduce an `isReviewMode` flag (or `PaletteMode` enum) to the `QuestionPalette` widget.
- *Rationale:* The layout, interaction logic, and bottom-sheet presentation are identical between exam and review contexts. Duplicating the widget into a `ReviewQuestionPalette` would cause maintenance overhead. By passing a mode flag, we can selectively alter just the color resolution (`_buildPaletteItem`) and legend labels.

**2. State Integration:**
- *Decision:* Add the `TestPaletteTrigger` widget to the bottom of the `ReviewAnswerDetailScreen`.
- *Rationale:* This mirrors how it is integrated into the `TestDetailScreen`. The trigger will open the bottom sheet containing the `QuestionPalette`, passing the current evaluation state of each question to determine correctness colors.

## Risks / Trade-offs

- [Risk] The `QuestionPalette` currently expects a `Map<String, AnswerDto> answers` object, but review state might be structured differently (e.g. `ReviewQuestion` objects).
  - *Mitigation:* We will ensure the data passed to `QuestionPalette` in review mode can be mapped to the expected correctness states, potentially adjusting the parameter types if needed or mapping the review data to the expected DTOs before passing.
