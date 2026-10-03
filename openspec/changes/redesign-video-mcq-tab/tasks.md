# Tasks

## 1. Background, Header and Progress Bar

- [x] 1.1 Update `VideoMcqTab`, `VideoMcqInitialCard`, and the quiz loading state to use a flat white background (`design.colors.card`), retaining the grey surface container (`design.colors.surface`) strictly for the bottom action button strip.
- [x] 1.2 Add the header section displaying the `"Practice Test"` title and `<N> Questions` pill badge.
- [x] 1.3 Implement the question progress row (`"Question X of Y"` on the left, `"N answered"` on the right) and the linear progress bar above the question.

## 2. Staged Option Selection and Check Answer Flow

- [x] 2.1 Add `_checkedQuestions` tracking set to `_VideoMcqTabState` and pass `isChecked` and `onCheck` callbacks to `VideoMcqStepperCard`.
- [x] 2.2 Update option tiles in `VideoMcqStepperCard` to show radio indicators in un-checked selection mode without revealing correctness.
- [x] 2.3 Implement the prominent **Check Answer** action button (active when an option is selected; hidden or disabled once checked).
- [x] 2.4 Wire the **Check Answer** button tap to evaluate correctness via `isOptionCorrect`, reveal correctness styles/icons, and show the explanation box.

## 3. Stepper Navigation Buttons

- [x] 3.1 Replace small chevron icons in `VideoMcqStepperCard` footer with full-width side-by-side **Previous** and **Next** action buttons.
- [x] 3.2 Ensure **Previous** is disabled on the first question and **Next** transitions to the next question or completion summary on the final question.

## 4. Verification and Widget Tests

- [x] 4.1 Update and run widget tests in `packages/courses` for `VideoMcqTab` and `VideoMcqStepperCard` to verify the staged selection, check answer evaluation, and navigation flows.

## 5. View All Questions (Question Palette)

- [x] 5.1 Add `VideoMcqPaletteSheet` bottom sheet modal displaying question number grid (1..N) with answered, current, and unanswered status indicators.
- [x] 5.2 Add "View All Questions (X/Y answered)" trigger button in `VideoMcqStepperCard` below navigation controls.
- [x] 5.3 Wire palette item tap to jump directly to the selected question and dismiss the sheet.
- [x] 5.4 Add widget tests covering palette trigger display, opening the bottom sheet, and jumping to questions.
