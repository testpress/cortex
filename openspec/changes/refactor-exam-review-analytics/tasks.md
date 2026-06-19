## 1. Exam Player and Submission Loader

- [x] 1.1 Add submitting state UI block in `TestDetailScreen` checking `state.status == ExamAttemptStatus.submitting`
- [x] 1.2 Update `TestResultView` to show a single "Review" button instead of separate "Review Answers" and "View Analytics" buttons
- [x] 1.3 Update `TestDetailScreen` usages of `TestResultView` to pass the new unified `onReview` callback

## 2. Review Analytics Landing Page Refactoring

- [x] 2.1 Refactor `ReviewAnalyticsScreen` to render only the metrics grid and explore details card, hiding the other detailed reports
- [x] 2.2 Add navigation callback parameters to `ExploreDetailsCard` for the "Subject-wise Performance" action

## 3. Dedicated Subject-wise Performance Screen and Routing

- [x] 3.1 Implement `ReviewSubjectPerformanceScreen` rendering `OverallPerformanceCard`, `SectionDonutList`, `DonutLegend`, and `SectionTable`
- [x] 3.2 Register the `review-analytics/subject-performance` sub-routes in `exams_routes.dart` and `study_routes.dart`
- [x] 3.3 Connect the "Subject-wise Performance" tile in `ExploreDetailsCard` to navigate to the newly created sub-route
