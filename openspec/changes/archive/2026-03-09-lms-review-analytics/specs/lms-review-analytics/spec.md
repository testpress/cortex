## ADDED Requirements

### Requirement: Performance Overview Dashboard
The system SHALL display an aggregated view of the user's test performance, detailing key metrics.

#### Scenario: Displaying primary metrics
- **WHEN** the user opens the `ReviewAnalyticsScreen`
- **THEN** the system SHALL display metric cards for Total Score, Attempted Questions, Percentile, Accuracy, Time Taken, and Overall Rank.

#### Scenario: Visualizing correct, incorrect, and unanswered totals
- **WHEN** the user views the Performance Overview section
- **THEN** the system SHALL render a primary Donut Chart visualization.
- **AND** the chart SHALL represent the percentage of Correct (green), Incorrect (red), and Unanswered (orange) questions accurately from the provided data.

#### Scenario: Overall Performance Gradient Bar
- **WHEN** the user views the Performance Overview section
- **THEN** the system SHALL display an "Overall Performance" visual gradient bar ranging from red (Bad) to green (Excellent).
- **AND** a marker SHALL indicate the user's percentage score along this continuous bar.

### Requirement: Section Performance Breakdown
The system SHALL break down the performance data corresponding to each individual section (or subject) of the assessment.

#### Scenario: Visualizing section donuts
- **WHEN** the user views the Section Performance area
- **THEN** the system SHALL display a row of smaller Donut Charts for each test section side-by-side.

#### Scenario: Reviewing section metrics in a table
- **WHEN** the user looks below the section donut charts
- **THEN** the system SHALL present a scrollable data table summarizing the Total Questions, Correct, Incorrect, Unanswered, Score, Accuracy, and Time Spent for each section.
- **AND** the table SHALL include a master "Overall" aggregation row at the bottom.

### Requirement: Analytics Sub-Screen Navigation
The system SHALL surface navigation hooks inviting the user to explore more detailed analytics.

#### Scenario: Launching the Exam Review detail
- **WHEN** the user selects the "Exam Review" action card from the Explore More Details section
- **THEN** the system SHALL push the comprehensive `ReviewAnswerDetailScreen` to the navigation stack.

#### Scenario: Stubbing upcoming analytics screens
- **WHEN** the user selects "Overall Performance", "Subject-wise Performance", or "Insights & Recommendations"
- **THEN** the system SHALL execute the corresponding routing operations to push those complementary analytic screens (or stubs).
