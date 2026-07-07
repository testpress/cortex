## 1. Widget Modifications

- [ ] 1.1 Add `isReviewMode` boolean flag (or enum) to `QuestionPalette` widget.
- [ ] 1.2 Update `_buildPaletteItem` in `QuestionPalette` to render correct colors for review statuses when `isReviewMode` is true (green for Correct, red for Incorrect, grey for Unattempted).
- [ ] 1.3 Update `_buildPaletteLegend` in `QuestionPalette` to display review-specific legend labels when `isReviewMode` is true.

## 2. Review Screen Integration

- [ ] 2.1 Add `TestPaletteTrigger` at the bottom of the `ReviewAnswerDetailScreen`.
- [ ] 2.2 Wire up the trigger to open the `QuestionPalette` bottom sheet, passing in `isReviewMode: true` and mapping the current review evaluation state to the format expected by the palette.
- [ ] 2.3 Implement the non-sequential navigation callback so selecting a question from the palette correctly navigates the review pager to the selected question.