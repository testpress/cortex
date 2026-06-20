# exam-review-analytics Specification

## Purpose
TBD - created by archiving change integrate-exam-review-analytics. Update Purpose after archive.
## Requirements
### Requirement: Unified Solutions and Analytics DTOs
The system SHALL define structured and parsing-safe DTO classes for Review Items, Questions, Answers, and Subject Analytics. The `AttemptDto` SHALL include a `timeTaken` field mapped from the `time_taken` field in the attempt API response.

#### Scenario: Parse Review Item DTO
- **WHEN** the API returns a JSON representation of a review item
- **THEN** the system SHALL successfully deserialize it into a `ReviewItemDto` object with correct types and fields

#### Scenario: Parse Subject Analytics DTO
- **WHEN** the API returns a JSON representation of subject stats
- **THEN** the system SHALL successfully deserialize it into a `SubjectAnalyticsDto` object

#### Scenario: Parse `time_taken` from attempt response
- **WHEN** the attempt end API returns a response containing a `time_taken` field
- **THEN** the system SHALL map it to `AttemptDto.timeTaken` as a `String?`
- **AND** if `time_taken` is absent from the response, `AttemptDto.timeTaken` SHALL be `null`

### Requirement: Real Backend Solutions Fetching
The system SHALL query the standard backend solutions endpoint using the modified review URL to fetch actual, complete question reviews.

#### Scenario: Fetch review items successfully
- **WHEN** a user triggers the Solutions Review flow
- **THEN** the system SHALL request the review items from the translated endpoint `/api/v2.2.1/attempts/<attempt_id>/review/`
- **AND** the system SHALL return the full list of `ReviewItemDto`s

### Requirement: Exam Metadata Forwarded to Analytics
The system SHALL carry `ExamDto` through the review route payload so the analytics screen can access exam-level configuration — specifically `duration`, `markPerQuestion`, and `negativeMarks` — without re-fetching.

#### Scenario: ExamDto available in analytics after exam submission
- **WHEN** a user submits an exam and navigates to `ReviewAnalyticsScreen`
- **THEN** the `ReviewRoutePayload` SHALL contain the `ExamDto` that was active during the exam session

#### Scenario: ExamDto absent when accessing analytics from history
- **WHEN** a user accesses `ReviewAnalyticsScreen` from exam history (not immediately post-submission)
- **THEN** `ReviewRoutePayload.exam` SHALL be `null`
- **AND** the analytics screen SHALL handle this gracefully by showing `-` for any metric that requires exam-level configuration

### Requirement: Submitting State Loader
The system SHALL render a full-screen loading screen when the exam attempt state transitions to `ExamAttemptStatus.submitting` to prevent user interaction and show that the test submission is in progress.

#### Scenario: Displaying submitting loader screen
- **WHEN** the exam attempt status is `ExamAttemptStatus.submitting`
- **THEN** the system SHALL render a blocking loading indicator screen with text indicating that the exam is being submitted
- **AND** the loading indicator screen text SHALL be retrieved from localizations (e.g. `l10n.testSubmitting`)
- **AND** the user SHALL NOT be able to interact with the question card, timer, or exit options
- **AND** the loading indicator screen SHALL block system back-navigation (e.g. using `PopScope(canPop: false)`) to prevent premature exit during submission

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
- **AND** all user-visible labels, headers, and descriptions inside `ExploreDetailsCard` (including the section header "Explore More Details", and descriptions/titles for both "Subject-wise Performance" and "Exam Review") SHALL be retrieved from localizations (e.g. using `l10n.reviewExploreDetailsTitle`, `l10n.reviewSubjectPerformanceTileDesc`, `l10n.reviewExamReviewTitle`, and `l10n.reviewExamReviewDesc`) to avoid hardcoded English text

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

