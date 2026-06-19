## ADDED Requirements

### Requirement: Submitting State Loader
The system SHALL render a full-screen loading screen when the exam attempt state transitions to `ExamAttemptStatus.submitting` to prevent user interaction and show that the test submission is in progress.

#### Scenario: Displaying submitting loader screen
- **WHEN** the exam attempt status is `ExamAttemptStatus.submitting`
- **THEN** the system SHALL render a blocking loading indicator screen with text indicating that the exam is being submitted
- **AND** the user SHALL NOT be able to interact with the question card, timer, or exit options

### Requirement: Unified Review Entry Point
The system SHALL present a single "Review" button in the `TestResultView` upon successful exam submission, replacing the previous separate "Review Answers" and "View Analytics" buttons.

#### Scenario: Navigating to Review Analytics from results screen
- **WHEN** the user submits the exam and the `TestResultView` is shown
- **THEN** the system SHALL display a single primary button labeled "Review"
- **AND** WHEN the user taps the "Review" button
- **THEN** the system SHALL navigate the user to the landing page of the review analytics (`ReviewAnalyticsScreen`)

### Requirement: Simplified Review Analytics Landing Page
The system SHALL display only the general performance overview metrics cards and the "Explore More Details" navigation options card on the main `ReviewAnalyticsScreen`.

#### Scenario: Displaying simplified landing page
- **WHEN** the user navigates to the `ReviewAnalyticsScreen`
- **THEN** the system SHALL display the `MetricsGrid` containing total score, attempted questions, percentile, accuracy, and time taken
- **AND** the system SHALL display the `ExploreDetailsCard` containing options for further analytics and reviews
- **AND** the system SHALL NOT render the overall performance bar chart (`OverallPerformanceCard`), subject-wise donut charts (`SectionDonutList`), or subject tabular report (`SectionTable`) directly on this page

### Requirement: Subject-wise Performance Detail Screen
The system SHALL show a dedicated sub-screen/page containing the detailed graphs, performance bar, and tabular subject reports when the user requests "Subject-wise Performance".

#### Scenario: Navigating to Subject-wise Performance details
- **WHEN** the user selects the "Subject-wise Performance" option in the `ExploreDetailsCard`
- **THEN** the system SHALL navigate the user to a dedicated details view containing:
  - The overall performance bar chart (`OverallPerformanceCard`)
  - The subject-wise donut charts/rings (`SectionDonutList` / `HeroDonutCard`) with the corresponding `DonutLegend`
  - The subject-wise tabular report (`SectionTable`)
