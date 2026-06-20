## 1. Exam Player and Submission Loader

- [x] 1.1 Add submitting state UI block in `TestDetailScreen` checking `state.status == ExamAttemptStatus.submitting`
- [x] 1.2 Update `TestResultView` to show a single "Review" button instead of separate "Review Answers" and "View Analytics" buttons
- [x] 1.3 Update `TestDetailScreen` usages of `TestResultView` to pass the new unified `onReview` callback
- [x] 1.4 Wrap the "Review" button in `TestResultView` with `AppSemantics.button()` and `AppFocusable` for accessibility and clickability
- [x] 1.5 Add `testReview` to the ARB files (`app_en.arb`, `app_ml.arb`, `app_ar.arb`, `app_ta.arb`)
- [x] 1.6 Use `l10n.testReview` for both the semantic label and the text in the "Review" button in `TestResultView`

## 2. Review Analytics Landing Page Refactoring

- [x] 2.1 Refactor `ReviewAnalyticsScreen` to render only the metrics grid and explore details card, hiding the other detailed reports
- [x] 2.2 Add navigation callback parameters to `ExploreDetailsCard` for the "Subject-wise Performance" action

## 3. Dedicated Subject-wise Performance Screen and Routing

- [x] 3.1 Implement `ReviewSubjectPerformanceScreen` rendering `OverallPerformanceCard`, `SectionDonutList`, `DonutLegend`, and `SectionTable`
- [x] 3.2 Register the `review-analytics/subject-performance` sub-routes in `exams_routes.dart` and `study_routes.dart`
- [x] 3.3 Connect the "Subject-wise Performance" tile in `ExploreDetailsCard` to navigate to the newly created sub-route
- [x] 3.4 Localize 'Submitting test...', 'Subject-wise Performance', 'Overall Performance', 'Section Performance', and 'Breakdown of your performance across each subject' in ARB files and regenerate
- [x] 3.5 Reference new l10n keys on the submission loader and Subject-wise Performance screen/widgets
- [x] 3.6 Fix hardcoded error message localization and margin padding layout tokens in `ReviewSubjectPerformanceScreen`
- [x] 3.7 Replace static path in `onExamReviewTap` with GoRouter dynamic path replacement in `ReviewAnalyticsScreen`
- [x] 3.8 Remove unused `testId` field from `ReviewSubjectPerformanceScreen`
- [x] 3.9 Refactor the "Review" button in `TestResultView` to use the standard core primitive `AppButton.primary` instead of custom widget wrappers
- [x] 3.10 Modify the `_openAnalytics` callback in `TestDetailScreen` to resolve the GoRouter path dynamically (replacing '/player' with '/review-analytics')
- [x] 3.11 Add AppSemantics.button and 48dp touch target to Close button in `TestResultView`
- [x] 3.12 Localize score result message in `TestResultView` via new l10n key `testScoreResult(score)`
- [x] 3.13 Localize 'Performance Overview' header in `ReviewAnalyticsScreen` via new l10n key `reviewPerformanceOverviewTitle`
