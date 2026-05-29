## MODIFIED Requirements

### Requirement: Performance Overview Dashboard
The system SHALL display an aggregated view of the user's test performance using metric values sourced exclusively from the API response. No metric SHALL be derived from client-side computation, hardcoded defaults, or heuristics.

#### Scenario: Displaying Time Taken from API
- **WHEN** the user opens the `ReviewAnalyticsScreen` after completing an exam
- **THEN** the system SHALL display Time Taken sourced from the `time_taken` field of the attempt API response
- **AND** if `time_taken` is absent from the API response, the system SHALL display `-` for that metric

#### Scenario: Displaying Total Time from exam configuration
- **WHEN** the user views the Time Taken metric card
- **THEN** the system SHALL display Total Time using the `duration` field from the `ExamDto`
- **AND** if `ExamDto.duration` is absent, the system SHALL derive Total Time by adding `time_taken` and `remaining_time` from the attempt response
- **AND** if neither is available, the system SHALL display `-`

#### Scenario: Displaying primary metrics
- **WHEN** the user opens the `ReviewAnalyticsScreen`
- **THEN** the system SHALL display metric cards for Total Score, Attempted Questions, Percentile, Accuracy, Time Taken, and Overall Rank derived from real Attempt data
- **AND** no metric value SHALL use a hardcoded numeric default

#### Scenario: Hiding rank when not enabled
- **WHEN** the attempt response has `rank_enabled` set to `false` or absent
- **THEN** the system SHALL hide the Overall Rank metric card entirely
- **AND** the system SHALL NOT display `0/0` or `-` as a placeholder for rank

#### Scenario: Visualizing correct, incorrect, and unanswered totals
- **WHEN** the user views the Performance Overview section
- **THEN** the system SHALL render a primary Donut Chart visualization using real Attempt metrics
- **AND** the chart SHALL represent the percentage of Correct (green), Incorrect (red), and Unanswered (orange) questions accurately from the provided data

#### Scenario: Overall Performance Gradient Bar
- **WHEN** the user views the Performance Overview section
- **THEN** the system SHALL display an "Overall Performance" visual gradient bar ranging from red (Bad) to green (Excellent)
- **AND** a marker SHALL indicate the user's percentage score along this continuous bar
- **AND** the score percentage SHALL be computed from the raw score values returned by the API without client-side recomputation

## MODIFIED Requirements

### Requirement: Section Performance Breakdown
The system SHALL calculate subject-level scores using `markPerQuestion` and `negativeMarks` sourced from `ExamDto`. No hardcoded mark-per-question value SHALL be used.

#### Scenario: Subject score uses exam-configured marking scheme
- **WHEN** the system computes a subject's score for the section table
- **THEN** it SHALL use `ExamDto.markPerQuestion` and `ExamDto.negativeMarks` as the marking scheme
- **AND** if `ExamDto.markPerQuestion` is absent, the subject score SHALL default to `0` and not use a hardcoded fallback

#### Scenario: Visualizing section donuts
- **WHEN** the user views the Section Performance area
- **THEN** the system SHALL display a row of smaller Donut Charts for each test section side-by-side powered by real Subject Analytics data

#### Scenario: Reviewing section metrics in a table
- **WHEN** the user looks below the section donut charts
- **THEN** the system SHALL present a scrollable data table summarizing the Total Questions, Correct, Incorrect, Unanswered, Score, Accuracy, and Time Spent for each section from real Subject Analytics data
- **AND** the table SHALL include a master "Overall" aggregation row at the bottom
