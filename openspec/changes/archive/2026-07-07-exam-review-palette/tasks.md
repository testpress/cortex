## 1. Widget Modifications

- [x] 1.1 Extract `PaletteColorStrategy` interface and implement `TestTakingStrategy` and `ReviewStrategy`.
- [x] 1.2 Refactor `QuestionPalette` and `QuestionPaletteItem` to consume the injected strategy for color logic instead of hardcoding or using boolean flags.
- [x] 1.3 Refactor `QuestionPaletteLegend` to consume the injected strategy for legend labels and icons.

## 2. Review Screen Integration

- [x] 2.1 Add `TestPaletteTrigger` at the bottom of the `ReviewAnswerDetailScreen`.
- [x] 2.2 Wire up the trigger to open the `QuestionPalette` bottom sheet, passing in `ReviewStrategy`.
- [x] 2.3 Implement the non-sequential navigation callback so selecting a question from the palette correctly navigates the review pager to the selected question.