## Why

The Chapter Lists screen displays filtering chips for all content types, including "Assessments" and "Tests". When the dedicated "Exam" tab is enabled on the app shell (via `ClientConfig`), having these same filtering chips on the Study/Chapter tab creates redundant navigation paths and cluttered UI. Conditionally hiding them keeps the curriculum view focused on pure course content (Videos, Lessons).

## What Changes

- Hide the "Assessments" and "Tests" filtering chips in the Chapters list screen when `showExamTab` is active in the current `ClientConfig`.
- Implement a modular, scalable rule set or config mapping that determines which filters are visible under which config flags, facilitating future dynamic filter logic.

## Capabilities

### New Capabilities

*(None)*

### Modified Capabilities

- `lms-study-chapters-list`: Conditionally hide filter chips (Assessments, Tests) based on the `showExamTab` state.

## Impact

- **UI Components**:
  - `packages/courses/lib/widgets/chapters_filter_tab_bar.dart`: Update to conditionally build tabs based on a configuration/rule set.
  - `packages/courses/lib/screens/chapters_list_page.dart`: Pass the current `ClientConfig` state or resolved visible filters down to the tab bar.
- **Data/Logic Layer**:
  - Read `clientConfigProvider` from `package:core/data/data.dart` to determine the active tenant configurations.
