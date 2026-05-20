## ADDED Requirements

### Requirement: Scroll-Driven Stream Control
The UI SHALL use a `ScrollController` to drive pagination of filtered content streams. The stream SHALL be paused immediately after receiving each page chunk, and resumed only when the user scrolls to within 200px of the list's bottom.

#### Scenario: First page load
- **WHEN** a filter tab is activated
- **THEN** the repository stream SHALL start and yield the first page
- **AND** the stream SHALL be paused immediately after the first chunk is delivered
- **AND** no further API requests SHALL be made until the user scrolls

#### Scenario: User scrolls to near the bottom
- **WHEN** the user scrolls and `scrollPosition >= maxScrollExtent - 200`
- **AND** the stream is currently paused
- **THEN** the stream SHALL be resumed
- **AND** a loading indicator SHALL appear at the bottom of the list while the next page loads
- **AND** the stream SHALL be paused again once the next chunk is delivered

#### Scenario: Final page reached
- **WHEN** the stream emits `onDone` (no more pages)
- **THEN** the loading indicator SHALL be removed
- **AND** no further scroll events SHALL trigger network requests

### Requirement: Filter Change Cancellation
Changing the active filter tab SHALL cancel all in-flight streams and reset all pagination state cleanly.

#### Scenario: Switching filter tabs
- **WHEN** the user switches from the "Videos" tab to the "Tests" tab
- **THEN** the existing `StreamSubscription` for Videos SHALL be cancelled
- **AND** the `ScrollController` listener SHALL trigger fresh pagination for the new filter
- **AND** no stale data from the previous filter SHALL appear in the new results

### Requirement: Scroll Controller Lifecycle
The `ScrollController` SHALL be created in `initState` and disposed in `dispose` to prevent memory leaks.

#### Scenario: Widget disposal
- **WHEN** the `ChaptersListPage` widget is removed from the tree
- **THEN** the `ScrollController` SHALL be disposed
- **AND** all active `StreamSubscription` instances SHALL be cancelled
