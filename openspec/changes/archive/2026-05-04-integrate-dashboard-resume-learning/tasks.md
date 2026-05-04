## 1. Network & Data Layer

- [x] 1.1 Add `resume` endpoint to `ApiEndpoints`.
- [x] 1.2 Add `getResumeLearningFeed` method to `DataSource` and implement in `HttpDataSource`.
- [x] 1.3 Update `DashboardContentsDto.fromJson` to branch its parsing logic based on `sectionType` (using the relational "Filter and Match" logic specifically for `resumeLearning`).
- [x] 1.4 Implement `watchResumeLearningFeed` and `refreshResumeLearningFeed` in `DashboardRepository`.

## 2. State Management

- [x] 2.1 Add `resumeLearningFeed` provider to `packages/courses/lib/providers/dashboard_providers.dart`.
- [x] 2.2 Add mock data for the Resume Learning feed in `MockDataSource` to facilitate testing.

## 3. UI Integration

- [x] 3.1 Update `PaidActiveHomeScreen` in `packages/testpress` to watch the new `resumeLearningFeed` provider.
- [x] 3.2 Replace `dummyResumeLessons` with the real data stream from the provider.
- [x] 3.3 Ensure the "Resume Learning" section is hidden in the UI if the feed is empty.

## 4. Verification

- [x] 4.1 Verify that video progress percentages are correctly calculated and displayed.
- [x] 4.2 Verify that tapping a "Resume" card navigates to the correct lesson or exam viewer.
