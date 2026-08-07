## 1. Network Layer & Configuration

- [x] 1.1 Add `showExamResults` flag to `packages/core/lib/data/config/app_config.dart` (read via `SHOW_EXAM_RESULTS`).
- [x] 1.2 Create `packages/exams/lib/data/network/exam_results_api_service.dart` and `ExamResultApiClient` with a custom Dio instance overriding SSL verification for `65.108.62.51`.
- [x] 1.3 Add models `ExamResultDto` and `ExamResultResponseDto` in `packages/exams/lib/data/models/` mapping the expected API structure using Freezed/JsonSerializable.

## 2. State Management

- [x] 2.1 Create repository `ExamResultsRepository` in `packages/exams/lib/data/repositories/` calling the new API endpoint.
- [x] 2.2 Create a Riverpod AsyncNotifier provider `modelExamResultsProvider` in `packages/exams/lib/providers/` to fetch and cache "Model" exam results.
- [x] 2.3 Create a Riverpod AsyncNotifier provider `weeklyExamResultsProvider` to fetch and cache "Weekly" exam results.

## 3. UI Implementation

- [x] 3.1 Create the main `MyResultsScreen` inside `packages/exams/lib/screens/results/my_results_screen.dart` with a `DefaultTabController` and `TabBar`.
- [x] 3.2 Create the `ExamResultsTabView` widget containing the horizontal scroll view and the `DataTable` (or custom row list).
- [x] 3.3 Create the `ExamResultDataRow` to display each column (rank, grade, total marks, subject marks).

## 4. Integration

- [x] 4.1 Update `dashboard_drawer.dart` in `packages/testpress/lib/widgets/` to show the "My Results" menu item when `AppConfig.showExamResults` is true.
- [x] 4.2 Add the router path for `/my-results` in the app router to navigate to `MyResultsScreen`.
