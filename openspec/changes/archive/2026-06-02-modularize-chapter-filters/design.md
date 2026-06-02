## Context

The `ChaptersListPage` in the `courses` package uses the `ChaptersFilterTabBar` widget to display five filter chips: All, Lessons, Videos, Assessments, and Tests. Currently, these chips are displayed unconditionally. When the specialized "Exam" tab is enabled on the app shell (governed by the `showExamTab` flag in `ClientConfig`), having the "Assessments" and "Tests" filters in the courses view causes navigation redundancy. We need to hide these two chips when the Exam tab is active.

## Goals / Non-Goals

**Goals:**
- Dynamically hide "Assessments" and "Tests" filtering chips in `ChaptersListPage` when the Exam tab is enabled.
- Ensure the filtering logic is encapsulated in a modular rule set structure to facilitate future context-dependent filters.
- Safely resolve the selected active filter if it is hidden by a configuration change.

**Non-Goals:**
- Modifying the global navigation architecture.
- Altering the structure of the `ClientConfig` class.

## Decisions

### 1. Introduce `ChaptersFilterRules` Class
We will introduce a class to manage filter visibility:
- **Location**: `packages/courses/lib/widgets/chapters_filter_rules.dart`
- **Rationale**: Isolates the filtering rules from the UI rendering layer, making the rules highly testable and extensible for future context/config flags.
- **Alternatives Considered**: Hardcoding the visibility check inside the widget tree. This was rejected because it reduces code reuse and testability.

### 2. UI-State Decoupling
- **Action**: Pass a list of resolved `visibleFilters` to the `ChaptersFilterTabBar` widget rather than having it query the config internally.
- **Rationale**: Keeps the `ChaptersFilterTabBar` a pure widget, decoupled from global application state and Riverpod providers, allowing easy testing.
- **Alternatives Considered**: Making `ChaptersFilterTabBar` watch `clientConfigProvider` internally. Rejected to maintain widget modularity and testability.

### 3. Safe State Fallback in `ChaptersListPage`
- **Action**: Resolve the current active filter dynamically:
  ```dart
  final activeFilter = visibleFilters.contains(_activeFilter) ? _activeFilter : CurriculumFilter.all;
  ```
- **Rationale**: Prevents crashes or blank states if the active filter state is set to an option that becomes hidden due to a configuration update.

## Risks / Trade-offs

- **[Risk]**: The user could end up in a filtered state for a hidden filter if the client config updates dynamically.
- **[Mitigation]**: The safe fallback check resolves the active filter to `CurriculumFilter.all` instantly if the active selection is not in the list of visible filters.
