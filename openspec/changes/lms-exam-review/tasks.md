## 1. Localization & Strings

- [x] 1.1 Add localized strings for "Exam Review", "Review Answers", filters ("All", "Wrong", "Correct", "Unanswered") and "Correct Answer" labels to `app_en.arb`.
- [x] 1.2 Run `flutter gen-l10n` to update generated localizations.

## 2. Review Components

- [x] 2.1 Create `ReviewQuestionListItem` in `packages/courses/lib/widgets/exam_review/review_question_list_item.dart` (implement accordion logic).
- [x] 2.2 Design the header to match `ExamReviewScreen.tsx` with status icons and Correct/Incorrect badges.
- [x] 2.3 Implement the expanded content to show question text, user selection, and correct answer highlight.

## 3. Core Screen Logic

- [x] 3.1 Create `ExamReviewScreen` in `packages/courses/lib/screens/exam_review_screen.dart`.
- [x] 3.2 Implement the filter bar with count-aware ChoiceChips.
- [x] 3.3 Build the scrollable question list using `ListView.builder` with filter logic.

## 4. Assessment Integration

- [x] 4.1 Update `AssessmentDetailScreen._buildResultView` to include the "Review Answers" button.
- [x] 4.2 Integrate navigation to push `ExamReviewScreen` with the final results data.
