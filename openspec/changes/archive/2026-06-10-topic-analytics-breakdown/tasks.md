## 1. UI Components

- [x] 1.1 Create `topic_analytics_screen.dart` inside `packages/exams/lib/screens/subject_analytics/`
- [x] 1.2 Implement the screen header (back button and topic title) using `ForumHeader` alignment standard
- [x] 1.3 Implement the body to display the topic's correct, incorrect, and unanswered counts using a donut progress card

## 2. Navigation & Routing

- [x] 2.1 Add a nested route `topic/:id` under the `analytics` route inside `packages/testpress/lib/navigation/routes/exams_routes.dart`
- [x] 2.2 Update `isLeaf` tap handling in `packages/exams/lib/screens/subject_analytics/widgets/overall_reports_view.dart` to perform a `context.push()` to the new route
- [x] 2.3 Update `isLeaf` tap handling in `packages/exams/lib/screens/subject_analytics/widgets/individual_reports_view.dart` to perform a `context.push()` to the new route
