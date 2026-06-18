## Why
The current course curriculum filter bar displays chips for "All", "Lessons", "Videos", etc., but their behavior is inconsistent. Currently, "All" acts as a tab to switch back to a Folder View, while "Lessons" flattens the view. To improve UX and consistency, we want the chips to act strictly as toggles. When no chips are active, the UI defaults to the Folder View. Selecting any chip (like "All" or "Videos") flattens the content based on the filter. Tapping an active chip toggles it off, reverting to the Folder View. Additionally, the explicit "Lessons" filter is redundant and will be removed, allowing "All" to serve the purpose of viewing all lessons in a flat view.

## What Changes
- Change the curriculum filter chips to act as toggles that can be deselected.
- Remove the `CurriculumFilter.lesson` filter entirely from the `CurriculumFilter` enum and the UI.
- Update `ChaptersFilterTabBar` to support an empty/null active filter state.
- Update `ChaptersListPage` to map an unselected (null) filter state to the default Folder View (Chapters).
- Update `ChaptersListPage` so that when `CurriculumFilter.all` is selected, it displays a flat list of all curriculum items.
- Ensure that tapping an already active filter chip toggles it off (sets active filter to null).

## Capabilities

### New Capabilities

### Modified Capabilities
- `study-curriculum`: Changing the UX flow of curriculum filters to be toggle-based, removing the explicit "Lesson" filter, and mapping the default view to an unselected filter state.

## Impact
- **UI Components**: `ChaptersFilterTabBar` and `ChaptersListPage` in the `courses` package.
- **Enums**: `CurriculumFilter` enum (removing `lesson`).
- **Providers/Logic**: `_activeFilter` state handling in `_ChaptersListPageState` will need to support nullability and toggling.
