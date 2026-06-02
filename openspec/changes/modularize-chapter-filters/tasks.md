## 1. Rule Set Implementation

- [x] 1.1 Create the `ChaptersFilterRules` class in `packages/courses/lib/widgets/chapters_filter_rules.dart` to filter `CurriculumFilter` enum values based on `ClientConfig`.
- [x] 1.2 Add unit tests for `ChaptersFilterRules` in `packages/courses/test/widgets/chapters_filter_rules_test.dart` to verify logic with and without `showExamTab` enabled.

## 2. UI Integration

- [x] 2.1 Modify the `ChaptersFilterTabBar` constructor to accept a list of `visibleFilters` and render only those tabs.
- [x] 2.2 In `ChaptersListPage`, read `clientConfigProvider` using Riverpod to retrieve the current config.
- [x] 2.3 Compute `visibleFilters` using `ChaptersFilterRules.getVisibleFilters(config)` in `ChaptersListPage.build`.
- [x] 2.4 Safely resolve the active filter choice to fallback to `CurriculumFilter.all` if the user's current filter selection is hidden.
- [x] 2.5 Pass the resolved list of `visibleFilters` to all instances of `ChaptersFilterTabBar` in `ChaptersListPage`.

## 3. Verification & UI Testing

- [x] 3.1 Write widget tests in `packages/courses/test/widgets/chapters_list_page_test.dart` to assert filter tab visibility under different `ClientConfig` mock setups.
- [x] 3.2 Run all unit and widget tests in the courses package to ensure they pass successfully without regressions.
