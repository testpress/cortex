## Context

In multi-section exams with sectional locks (`hasSectionalLock == true`), sections are strictly timed on the server. Attempting to switch sections before the section timer expires returns `403 Forbidden` from the backend ("You are not allowed to end this section now. Please wait for the timer to end.").

Previously:
1. `SectionsTabBar` had all tabs enabled and clickable, which allowed learners to tap inactive section tabs.
2. On the last question of a locked section, the app presented a "Next Section" button and called `switchSection`.
3. In singleSelect questions, once an option is selected, tapping it again does not deselect it, and there is no "Clear Response" button, preventing learners from skipping questions in negative-marking tests.

## Decisions

- **Disable Inactive Tabs on Locked Exams**:
  - In `SectionsTabBar`, add `isLocked` (defaults to `false`).
  - When `isLocked` is `true`, inactive tabs render with secondary styling (`design.colors.textSecondary`) and `onTap: null` (`enabled: false`).
  - In `TestDetailScreen`, pass `isLocked: useSections && state.attempt?.hasSectionalLock == true` to `SectionsTabBar`.

- **Prevent Premature Section Advancement in Sectional Lock**:
  - In `TestDetailScreen`, when `useSections` is true (`hasSectionalLock == true`), disable forward advancement on the last question of any section (`canGoNext = isLast ? !isSectionLocked : true`).
  - The learner remains on the section questions until the section timer hits `00:00`, which triggers the natural `_handleTimeOut` flow.

- **Explicit Clear Response Action**:
  - In `TestNavigationActions`, render a secondary `Clear Response` action beside the `Mark for Review` button when `hasAnswer == true`.
  - Tapping it invokes `onClearResponse`, setting `selectedOptions` to `[]`, updating local state, and queuing an empty response to the repository/backend.
