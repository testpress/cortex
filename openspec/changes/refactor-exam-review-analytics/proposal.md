## Why

Currently, the exam submission flow displays separate "Review Answers" and "View Analytics" buttons on completion, which can be combined for a simpler, review-centric entry point. Additionally, the Review Analytics landing page is cluttered, presenting detailed subject-wise donut charts and tabular reports immediately, rather than keeping the landing page clean and using navigation to access deep-dive reports.

## What Changes

- **Submitting State Loader**: Add a dedicated loading screen / indicator in `TestDetailScreen` when `ExamAttemptStatus.submitting` is active to explicitly show that the test is being submitted.
- **Unified Review Entry Point**: Replace the two buttons ("Review Answers", "View Analytics") in `TestResultView` with a single "Review" button that navigates directly to the main `ReviewAnalyticsScreen`.
- **Simplified Analytics Landing Page**: Refactor `ReviewAnalyticsScreen` to show only the "Performance Overview" metrics grid and the "Explore More Details" options card, removing the other detailed charts and tables from the main list.
- **Subject-wise Performance Sub-route**: Implement a new route / page specifically to show the detailed graph (subject donut rings), bar (overall performance progress bar), and tabular reports that were previously on the landing page, and wire it to the "Subject-wise Performance" action on the options card.

## Capabilities

### New Capabilities
<!-- None needed, we are only changing requirements of existing capabilities -->

### Modified Capabilities
- `exam-review-analytics`: Update submission screen buttons, landing page layout, and add a dedicated subject-wise analytics detail view.

## Impact

- `packages/exams/lib/widgets/test_detail/test_result_view.dart`
- `packages/exams/lib/screens/test_detail_screen.dart`
- `packages/exams/lib/screens/review_analytics/review_analytics_screen.dart`
- `packages/exams/lib/screens/review_analytics/widgets/explore_details_card.dart`
- `packages/testpress/lib/navigation/routes/exams_routes.dart`
- `packages/testpress/lib/navigation/routes/study_routes.dart`
