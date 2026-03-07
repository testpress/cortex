## 1. Localization & Strings

- [x] 1.1 Add localized strings for "Exam Review", "Review Answers", filters ("All", "Wrong", "Correct", "Unanswered") and "Correct Answer" labels to `app_en.arb`.
- [x] 1.2 Run `flutter gen-l10n` to update generated localizations.

## 2. Review Components

- [x] 2.1 Create `ReviewQuestionCard` in `packages/courses/lib/widgets/exam_review/review_question_card.dart` (implement question display logic).
- [x] 2.2 Design the card to display status icons and Correct/Incorrect badges based on correctness.
- [x] 2.3 Implement the card content to show question text, user selection, correct answer highlight, and explanation without expanding.

## 3. Core Screen Logic

- [x] 3.1 Update `ReviewAnswerDetailScreen` in `packages/courses/lib/screens/review_answer/review_answer_detail_screen.dart`.
- [x] 3.2 Implement the filter functionality with count-aware ChoiceChips.
- [x] 3.3 Build the paged question navigation using `PageView` and "Previous"/"Next" buttons with filter logic.

## 4. Test Integration

- [x] 4.1 Update `TestDetailScreen._buildResultView` to include the "Review Answers" button.
- [x] 4.2 Integrate navigation to push `ReviewAnswerDetailScreen` with the final results data.
