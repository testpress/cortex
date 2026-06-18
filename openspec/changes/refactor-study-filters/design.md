## Context
The curriculum filter bar currently requires an active filter at all times, defaulting to `CurriculumFilter.all`. Clicking "All" brings up a folder view (Chapters), while other filters like "Lessons" bring up a flat list view of filtered items. To improve the user experience, we are refactoring these filter chips to act as toggle buttons. If no button is selected, the folder view is displayed. If the "All" button is selected, it flattens the view to show all lessons. We are also removing the redundant "Lesson" filter.

## Goals / Non-Goals

**Goals:**
- Implement toggle behavior for curriculum filter chips.
- Ensure that `activeFilter` can be null/unselected.
- Route a `null` active filter to display the Chapters (Folder view).
- Route an `All` active filter to display all lessons in a flat list.
- Remove the `CurriculumFilter.lesson` enum value and associated logic.

**Non-Goals:**
- Completely redesign the filter bar visually.
- Change the backend API or how chapters/lessons are fetched from Drift DB.
- Change how the Assessment/Test logic is toggled based on the `exams` package.

## Decisions

- **Nullable Active Filter:** `_activeFilter` in `_ChaptersListPageState` will be changed from `CurriculumFilter` to `CurriculumFilter?`. This allows a "no filter selected" state.
- **Toggle Logic:** In `_onFilterChanged`, if the tapped `filter` is equal to the currently `_activeFilter`, it will be set to `null` (deselected). Otherwise, it will be set to the new `filter`.
- **View Mapping:** 
  - The variable `showChapters` will be updated to: `activeFilter == null && chapters.isNotEmpty`.
  - The variable `filteredLessons` logic will bypass the `lesson` condition since it's removed, and fallback to fetching everything when `activeFilter == CurriculumFilter.all`.
- **Removing `lesson`:** The `CurriculumFilter.lesson` value will be deleted from the `CurriculumFilter` enum in `chapters_filter_tab_bar.dart` and removed from `ChaptersFilterRules` if present.

## Risks / Trade-offs
- **[Risk] Null Safety / State Handling:** Some parts of the codebase might assume `activeFilter` is always non-null. 
  - **Mitigation:** Ensure that `activeFilter` defaults to `null` initially and handle the null cases explicitly throughout `_ChaptersListPageState`.
