# Subject Analytics UI

## Purpose
Subject Analytics UI capability provides the components, layout, and visualization to allow users to monitor their learning progress.
## Requirements
### Requirement: Navigation and Header UI
The system SHALL render a sticky top header containing a back navigation button, a title "Analytics", and a filter icon button.

#### Scenario: Navigating back from the screen
- **WHEN** the user taps the back button in the header
- **THEN** the system SHALL pop the current route to return to the previous screen

#### Scenario: Filter Dropdown Menu Placement
- **WHEN** the user taps the filter icon in the header
- **THEN** the system SHALL open the filter overlay menu slightly below the filter button (offset vertically by 48px / design.spacing.xxl) so that it does not overlap or obscure the filter icon
- **AND** the top of the menu SHALL start aligned so that the first item ("All") is horizontally on the same line as the "Individual Reports" tab button.

### Requirement: Reports Tab Toggling
The system SHALL present two tabs: "Graph Reports" and "Table Reports", permitting the user to switch between views.

#### Scenario: Switching between tabs
- **WHEN** the user taps the "Graph Reports" tab
- **THEN** the system SHALL display the stacked horizontal bar charts
- **AND** WHEN the user taps the "Table Reports" tab
- **THEN** the system SHALL display the subject stats table and donut cards
- **AND** the tab selector SHALL render as filled rounded pill-shaped buttons side-by-side
- **AND** the active tab button SHALL have a background color of design.colors.primary and contrasting text color of design.colors.onPrimary, while the inactive tab button SHALL have a light background and secondary text color

### Requirement: Graph Reports Performance Charts
The graph reports tab SHALL display a list of root subjects, each visualizing its correct, incorrect, and unanswered counts as a percentage-based stacked horizontal bar.

#### Scenario: Rendering the stacked bar row
- **WHEN** the graph reports tab is active
- **THEN** the system SHALL render a horizontal stacked bar for each subject where green represents strength (correct), red represents weakness (incorrect), and amber represents unanswered questions
- **AND** the legend bar SHALL display Strength, Weakness, and Unanswered items in a single horizontal row using design system success, error, and warning colors respectively
- **AND** the legend items SHALL be distributed dynamically to avoid compression on tablet screens (occupying approximately half to three-quarters of the screen width on wider layouts) while gracefully wrapping or adjusting on mobile viewports.

#### Scenario: Single Filter Percentage Labels
- **WHEN** a single filter is active (e.g. Correct, Incorrect, Unanswered) on the Graph Reports tab
- **THEN** the system SHALL render percentage labels for all subjects, even those with small percentages (including <= 10%)
- **AND** the percentage text SHALL be drawn inside the colored bar segment if it is wide enough (>= 30%), or outside the segment in the light tint background area if the segment is too narrow (< 30%)
- **AND** the legend bar SHALL dynamically display only the single dot and label representing the active filter state (e.g. "Strength / Correct", "Weakness / Incorrect", or "Unanswered").

### Requirement: Table Reports Stats Table
The table reports tab SHALL display a data table showing the subject name, correct count, incorrect count, and unanswered count.

#### Scenario: Displaying subject rows
- **WHEN** the table reports tab is active
- **THEN** the system SHALL render rows showing correct, incorrect, and unanswered counts for each subject
- **AND** the table layout SHALL be optimized for mobile screens to prevent text wrapping or clipping of headers and content.

#### Scenario: Center Alignment of Metrics Columns
- **WHEN** the table reports tab is active
- **THEN** the CORRECT, INCORRECT, and UNANSWERED header texts and the corresponding count values in the body cells SHALL be centered horizontally within their respective columns.

#### Scenario: Prevent Header Text Truncation
- **WHEN** the table reports tab is active (with any filter selected or 'All')
- **THEN** the system SHALL use column widths and cell padding that prevent any header text (such as 'CORRECT', 'INCORRECT', 'UNANSWERED') from wrapping or truncating/clipping the last letter

#### Scenario: Filtering Table Columns and Donut Cards
- **WHEN** a filter is selected (e.g. Correct, Incorrect, Unanswered)
- **THEN** the system SHALL only show the corresponding column in the table (hiding the other counts)
- **AND** the system SHALL filter the category donut cards to show only cards with count > 0 for that metric
- **AND** the donut chart slices for other metrics SHALL be visually muted (rendered in background/surfaceVariant color)

### Requirement: Category Donut Progress Cards
The table reports view SHALL render category cards below the main table, displaying a circular donut chart visualizing the relative percentages of correct, incorrect, and unanswered questions.

#### Scenario: Rendering donut cards
- **WHEN** the table reports view is scrolled below the table
- **THEN** the system SHALL display cards containing circular donut visualizations with correct, incorrect, and unanswered percentage slices.

### Requirement: Analytics Cleanup Refactoring Guidelines
The system SHALL adhere to the analytics cleanup refactoring guidelines to improve codebase clarity and consistency.

**Overview**
Refactor analytics codebase to improve clarity and consistency by:
1. Clarifying UI naming to use "Analytics" instead of generic "Subject" where analytics context is intended
2. Renaming table and DTO fields for clarity (`leaf` → `isLeaf`, `analyticsUrl` removal)
3. Standardizing button and text sizing across analytics screens

#### Scenario: Table & DTO Field Naming Conventions
- **THEN** Always use boolean flags prefixed with `is` (e.g., `isLeaf` instead of `leaf`).
- **AND** Avoid storing derived fields like `analyticsUrl` in the database; these should be constructed dynamically based on ID in the Data Source or Repository.
- **AND** Match DTO variable names with Database Column names.

#### Scenario: UI Screen/Component Naming
- **THEN** For Analytics screens, headers should clearly define the context (e.g., "Subject Analytics" instead of generic "Analytics" when looking at a specific subject).
- **AND** Section headers must be fully descriptive (e.g., "Subject Performance").
- **AND** Standard filter labels: "Correct", "Incorrect", "Unanswered".

#### Scenario: Text & Button Sizing Standardization
- **THEN** The global `ForumHeader` alignment standard must be applied to the Subject Analytics screen header:
  - Back arrows must use optical alignment: `Padding(top: 2)`
  - Titles must use `AppText.title` with `design.colors.textPrimary`.
- **AND** Filter icon buttons must be sized to `48x48` for accessibility tap targets, with an inner container of `36x36`.
- **AND** Tab buttons in views must use a `minHeight: 48.0` for accessibility standards.

**Affected Components**
- `packages/core/lib/data/db/tables/subject_analytics_table.dart`
- `packages/core/lib/data/models/review_models.dart`
- `packages/exams/lib/screens/subject_analytics/subject_analytics_screen.dart`

### Requirement: Subject Row Interactions
The system SHALL provide interactive navigation for subject rows across all tabs in the analytics UI.

#### Scenario: Tapping a non-leaf subject row
- **WHEN** the user taps a subject row that is NOT a leaf node
- **THEN** the system SHALL navigate deeper into that subject's children analytics view

#### Scenario: Tapping a leaf subject row
- **WHEN** the user taps a subject row that is a leaf node
- **THEN** the system SHALL navigate to the dedicated topic analytics screen to display its specific breakdown

### Requirement: API Integration and Offline-First State
The system SHALL integrate with the backend API to fetch paginated analytics data and persist the results locally using Drift for an offline-first architecture.

#### Scenario: Preserving Pagination State
- **WHEN** the user toggles between "Graph Reports" and "Table Reports", or navigates away and back
- **THEN** the system SHALL NOT discard the existing pagination state or refetch the initial page of data from the network
- **AND** the system SHALL utilize `@Riverpod(keepAlive: true)` to preserve offline data states and render the UI instantly.

### Requirement: Structural Skeleton Loading States
The system SHALL use the `skeletonizer` package to render visually consistent, non-intrusive loading states during API network requests.

#### Scenario: Rendering Chart Skeletons
- **WHEN** the API data is loading
- **THEN** the system SHALL render solid, structural grey (`surfaceVariant`) blocks for the Graph bar charts and Table donut charts
- **AND** the system SHALL NOT render fragmented black text-bone artifacts inside the charts
- **AND** the system SHALL permit surrounding text elements (such as subject titles) to correctly shimmer in tandem with the layout.
