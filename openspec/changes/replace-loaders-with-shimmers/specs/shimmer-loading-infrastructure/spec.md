## MODIFIED Requirements

### Requirement: Global Skeletonizer Support
The system SHALL support wrapping components across all application layers (Dashboard, Explore, Study, Exams) in a `Skeletonizer` widget to provide structural loading states instead of static spinners.

#### Scenario: Page loading with skeletons
- **WHEN** the user navigates to a screen and network data is being fetched
- **THEN** the system displays shimmer skeleton placeholders that match the layout of the final list items or grids.

## ADDED Requirements

### Requirement: Content-Density Proportional Skeleton Counts
UI components using Skeletonizer SHALL display a fixed, representative number of placeholder items consistent with the intended view density, regardless of the actual final data count, during initial loading.

#### Scenario: Explore list initial fetch
- **WHEN** a horizontally scrolling carousel is in a loading state
- **THEN** it MUST render at least 3 visible placeholder skeleton cards to communicate content structure correctly.

#### Scenario: Vertical course grid initial fetch
- **WHEN** a course list page loads initially
- **THEN** it MUST render between 6 and 8 placeholder skeletons to occupy the viewport gracefully.

### Requirement: Decoupled Static Identifiers
The system SHALL decouple primary page identification (like titles, parent headers, or basic metadata) from nested, blocking content streams. Headers MUST utilize non-blocking local database streams to render the real title immediately with **ZERO shimmer**, while only the nested list content below displays active shimmering loaders.

#### Scenario: Opening a Chapter Contents detail screen
- **WHEN** a user drills into a sub-item from a master list
- **THEN** the Header immediately queries local cache and renders the true chapter title with zero shimmer.
- **AND** the lower content list concurrently executes the blocking network sync and renders shimmer placeholders exclusively over the missing content rows.

### Requirement: Container Preserving Isolation
When applying shimmers to elevated or decorated list items (such as `AppCard` components), the `Skeletonizer` widget SHALL NOT wrap the outermost container decoration. Instead, it MUST be applied localized inside the element, wrapping exclusively the inner layout row/column to fully preserve the card's background color, drop-shadows, and borders during the loading state.

#### Scenario: Course list item loading
- **WHEN** a course card is skeletonized
- **THEN** the surrounding white background card and elevated drop-shadow remains perfectly visible.
- **AND** only the inner text fields and image widgets shimmer grey.

