# Subject Analytics UI

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
The system SHALL present two tabs: "Overall Reports" and "Individual Reports", permitting the user to switch between views.

#### Scenario: Switching between tabs
- **WHEN** the user taps the "Overall Reports" tab
- **THEN** the system SHALL display the stacked horizontal bar charts
- **AND** WHEN the user taps the "Individual Reports" tab
- **THEN** the system SHALL display the subject stats table and donut cards
- **AND** the tab selector SHALL render as filled rounded pill-shaped buttons side-by-side
- **AND** the active tab button SHALL have a background color of design.colors.primary and contrasting text color of design.colors.onPrimary, while the inactive tab button SHALL have a light background and secondary text color

### Requirement: Overall Reports Performance Charts
The overall reports tab SHALL display a list of root subjects, each visualizing its correct, incorrect, and unanswered counts as a percentage-based stacked horizontal bar.

#### Scenario: Rendering the stacked bar row
- **WHEN** the overall reports tab is active
- **THEN** the system SHALL render a horizontal stacked bar for each subject where green represents strength (correct), red represents weakness (incorrect), and amber represents unanswered questions
- **AND** the legend bar SHALL display Strength, Weakness, and Unanswered items in a single horizontal row using design system success, error, and warning colors respectively
- **AND** the legend items SHALL be distributed dynamically to avoid compression on tablet screens (occupying approximately half to three-quarters of the screen width on wider layouts) while gracefully wrapping or adjusting on mobile viewports.

#### Scenario: Single Filter Percentage Labels
- **WHEN** a single filter is active (e.g. Correct, Incorrect, Unanswered) on the Overall Reports tab
- **THEN** the system SHALL render percentage labels for all subjects, even those with small percentages (including <= 10%)
- **AND** the percentage text SHALL be drawn inside the colored bar segment if it is wide enough (>= 30%), or outside the segment in the light tint background area if the segment is too narrow (< 30%)
- **AND** the legend bar SHALL dynamically display only the single dot and label representing the active filter state (e.g. "Strength / Correct", "Weakness / Incorrect", or "Unanswered").

### Requirement: Individual Reports Stats Table
The individual reports tab SHALL display a data table showing the subject name, correct count, incorrect count, and unanswered count.

#### Scenario: Displaying subject rows
- **WHEN** the individual reports tab is active
- **THEN** the system SHALL render rows showing correct, incorrect, and unanswered counts for each subject
- **AND** the table layout SHALL be optimized for mobile screens to prevent text wrapping or clipping of headers and content.

#### Scenario: Center Alignment of Metrics Columns
- **WHEN** the individual reports tab is active
- **THEN** the CORRECT, INCORRECT, and UNANSWERED header texts and the corresponding count values in the body cells SHALL be centered horizontally within their respective columns.

#### Scenario: Prevent Header Text Truncation
- **WHEN** the individual reports tab is active (with any filter selected or 'All')
- **THEN** the system SHALL use column widths and cell padding that prevent any header text (such as 'CORRECT', 'INCORRECT', 'UNANSWERED') from wrapping or truncating/clipping the last letter

#### Scenario: Filtering Table Columns and Donut Cards
- **WHEN** a filter is selected (e.g. Correct, Incorrect, Unanswered)
- **THEN** the system SHALL only show the corresponding column in the table (hiding the other counts)
- **AND** the system SHALL filter the category donut cards to show only cards with count > 0 for that metric
- **AND** the donut chart slices for other metrics SHALL be visually muted (rendered in background/surfaceVariant color)

### Requirement: Category Donut Progress Cards
The individual reports view SHALL render category cards below the main table, displaying a circular donut chart visualizing the relative percentages of correct, incorrect, and unanswered questions.

#### Scenario: Rendering donut cards
- **WHEN** the individual reports view is scrolled below the table
- **THEN** the system SHALL display cards containing circular donut visualizations with correct, incorrect, and unanswered percentage slices.
