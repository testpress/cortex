## 1. Network Layer & Configuration

- [x] 1.1 Add `showExamResults` flag to `packages/core/lib/data/config/app_config.dart` (read via `SHOW_EXAM_RESULTS`).
- [x] 1.2 Create `packages/core/lib/data/integrations/bp_elearn/bp_elearn_exam_api_service.dart` and `BPElearnExamApiService` with a custom Dio instance overriding SSL verification for `65.108.62.51`.
- [x] 1.3 Add models `BPElearnPaginatedResponseDto` and `BPElearnExamDto` in `packages/core/lib/data/integrations/bp_elearn/models/` mapping the expected API structure using Freezed/JsonSerializable.

## 2. State Management

- [x] 2.1 Create repository `BPElearnExamRepository` in `packages/core/lib/data/integrations/bp_elearn/` calling the new API endpoint.
- [x] 2.2 Create Riverpod AsyncNotifier providers `bpElearnModelExamsProvider` and `bpElearnWeeklyExamsProvider` in `packages/core/lib/data/integrations/bp_elearn/bp_elearn_exam_provider.dart` to fetch and paginate exam results.

## 3. UI Implementation

- [x] 3.1 Create the main `BPElearnMyResultsScreen` inside `packages/core/lib/screens/bp_elearn_my_results_screen.dart` with a `DefaultTabController` and `TabBar`.
- [x] 3.2 Create the `BPElearnExamsTabView` widget handling the empty state layout (without magic numbers) and scrolling.
- [x] 3.3 Create the data table UI and components to display each column (rank, grade, total marks, subject marks).

## 4. Integration

- [x] 4.1 Update `dashboard_drawer.dart` in `packages/testpress/lib/widgets/` to show the "My Results" menu item when `AppConfig.showExamResults` is true.
- [x] 4.2 Add the router path for `/my-results` in the app router to navigate to `MyResultsScreen`.
