## ADDED Requirements

### Requirement: Submitting State Loader
The system SHALL render a full-screen loading screen when the exam attempt state transitions to `ExamAttemptStatus.submitting` to prevent user interaction and show that the test submission is in progress.

#### Scenario: Displaying submitting loader screen
- **WHEN** the exam attempt status is `ExamAttemptStatus.submitting`
- **THEN** the system SHALL render a blocking loading indicator screen with text indicating that the exam is being submitted
- **AND** the loading indicator screen text SHALL be retrieved from localizations (e.g. `l10n.testSubmitting`)
- **AND** the user SHALL NOT be able to interact with the question card, timer, or exit options

### Requirement: Unified Review Entry Point
The system SHALL present a single "Review" button in the `TestResultView` upon successful exam submission, replacing the previous separate "Review Answers" and "View Analytics" buttons.

#### Scenario: Navigating to Review Analytics from results screen
- **WHEN** the user submits the exam and the `TestResultView` is shown
- **THEN** the system SHALL display a single primary button labeled "Review"
- **AND** the button SHALL be implemented using the core `AppButton.primary` primitive
- **AND** the button SHALL be wrapped with `AppSemantics.button` for accessibility
- **AND** the button label and accessibility text SHALL be localized using a shared translation key (e.g. `l10n.testReview`)
- **AND** WHEN the user taps the "Review" button
- **THEN** the system SHALL navigate the user to the landing page of the review analytics (`ReviewAnalyticsScreen`)
- **AND** the navigation SHALL resolve the GoRouter path dynamically (e.g. by replacing '/player' with '/review-analytics' on the active route context) to ensure correct routing in both `/exams/` and `/study/` contexts

#### Scenario: Close button accessibility and touch target
- **WHEN** the `TestResultView` is shown
- **THEN** the Close icon button SHALL be wrapped with `AppSemantics.button` using the `l10n.commonCloseButton` translation key
- **AND** the button SHALL have a minimum touch target size of 48dp by wrapping the `LucideIcons.x` icon with padding (e.g., 12dp padding around a 24dp icon)

#### Scenario: Score result localization
- **WHEN** the exam is submitted and a score is available
- **THEN** the score message SHALL be retrieved from localizations using a translation key containing a parameter placeholder (e.g. `l10n.testScoreResult(score)`) to avoid hardcoded English text

### Requirement: Simplified Review Analytics Landing Page
The system SHALL display only the general performance overview metrics cards and the "Explore More Details" navigation options card on the main `ReviewAnalyticsScreen`.

#### Scenario: Displaying simplified landing page
- **WHEN** the user navigates to the `ReviewAnalyticsScreen`
- **THEN** the system SHALL display the `MetricsGrid` containing total score, attempted questions, percentile, accuracy, and time taken
- **AND** the system SHALL display the `ExploreDetailsCard` containing options for further analytics and reviews
- **AND** the system SHALL NOT render the overall performance bar chart (`OverallPerformanceCard`), subject-wise donut charts (`SectionDonutList`), or subject tabular report (`SectionTable`) directly on this page
- **AND** the section header "Performance Overview" SHALL be retrieved from localizations using a translation key (e.g. `l10n.reviewPerformanceOverviewTitle`) instead of hardcoded text

### Requirement: Subject-wise Performance Detail Screen
The system SHALL show a dedicated sub-screen/page containing the detailed graphs, performance bar, and tabular subject reports when the user requests "Subject-wise Performance".

#### Scenario: Navigating to Subject-wise Performance details
- **WHEN** the user selects the "Subject-wise Performance" option in the `ExploreDetailsCard`
- **THEN** the system SHALL navigate the user to a dedicated details view containing:
  - The overall performance bar chart (`OverallPerformanceCard`)
  - The subject-wise donut charts/rings (`SectionDonutList` / `HeroDonutCard`) with the corresponding `DonutLegend`
  - The subject-wise tabular report (`SectionTable`)

#### Scenario: Localization and layout constraints
- **WHEN** the `ReviewSubjectPerformanceScreen` is rendered
- **THEN** all user-visible text (header title, card labels, descriptions, and error states) SHALL be retrieved from localizations (e.g. using `l10n.reviewSubjectPerformanceTitle`, `l10n.labelOverallPerformance`, `l10n.labelSectionPerformance`, `l10n.reviewSubjectPerformanceDesc`, `l10n.reviewSubjectAnalyticsError`)
- **AND** the layout padding/margin SHALL use design spacing context tokens (e.g. `design.spacing.md`) instead of hardcoded raw dimensions
- **AND** the navigation actions (such as `onExamReviewTap`) SHALL resolve GoRouter paths dynamically using the active route context rather than hardcoding static paths
