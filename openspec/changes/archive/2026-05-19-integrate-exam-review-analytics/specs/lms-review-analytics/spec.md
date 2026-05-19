## MODIFIED Requirements

### Requirement: Performance Overview Dashboard
The system SHALL display an aggregated view of the user's test performance, detailing key metrics.

#### Scenario: Displaying primary metrics
- **WHEN** the user opens the `ReviewAnalyticsScreen`
- **THEN** the system SHALL display metric cards for Total Score, Attempted Questions, Percentile, Accuracy, Time Taken, and Overall Rank derived from real Attempt data.

#### Scenario: Visualizing correct, incorrect, and unanswered totals
- **WHEN** the user views the Performance Overview section
- **THEN** the system SHALL render a primary Donut Chart visualization using real Attempt metrics.
- **AND** the chart SHALL represent the percentage of Correct (green), Incorrect (red), and Unanswered (orange) questions accurately from the provided data.

#### Scenario: Overall Performance Gradient Bar
- **WHEN** the user views the Performance Overview section
- **THEN** the system SHALL display an "Overall Performance" visual gradient bar ranging from red (Bad) to green (Excellent).
- **AND** a marker SHALL indicate the user's percentage score along this continuous bar.

### Requirement: Section Performance Breakdown
The system SHALL break down the performance data corresponding to each individual section (or subject) of the assessment.

#### Scenario: Visualizing section donuts
- **WHEN** the user views the Section Performance area
- **THEN** the system SHALL display a row of smaller Donut Charts for each test section side-by-side powered by real Subject Analytics data.

#### Scenario: Reviewing section metrics in a table
- **WHEN** the user looks below the section donut charts
- **THEN** the system SHALL present a scrollable data table summarizing the Total Questions, Correct, Incorrect, Unanswered, Score, Accuracy, and Time Spent for each section from real Subject Analytics data.
- **AND** the table SHALL include a master "Overall" aggregation row at the bottom.
