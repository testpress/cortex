# exam-prescreen-attempt-history Specification

## Purpose
TBD - created by archiving change exam-prescreen-attempt-history. Update Purpose after archive.
## Requirements
### Requirement: Display Past Attempts Table
The system SHALL display a table of previously completed attempts on the exam pre-screen.

#### Scenario: User views exam pre-screen with past completed attempts
- **WHEN** the user navigates to the exam pre-screen
- **THEN** the system fetches the attempt history using the exam's `attemptsUrl`
- **THEN** the system filters the attempts for `state == 'Completed'`
- **THEN** the system displays a table showing the humanized Date (excluding time), Score, Correct count, Incorrect count, and a Review action button.

### Requirement: History Table Skeleton Loading
The system SHALL provide immediate visual feedback while past attempts are being fetched without blocking the main metadata UI.

#### Scenario: Attempts are being fetched over the network
- **WHEN** the attempt history data is actively loading
- **THEN** the system displays a skeleton shimmer for the history list items at the bottom of the screen
- **THEN** the system does not block the top metadata and action buttons from rendering.

### Requirement: Lazy-Loaded Review Navigation
The system SHALL allow users to navigate to the review screens from a past attempt row without requiring full question/answer data in memory.

#### Scenario: User clicks the Review action
- **WHEN** the user taps the Review button on a past attempt row
- **THEN** the system navigates to the review analytics or review answers screen
- **THEN** the system passes the specific `AttemptDto` in the payload, allowing the destination screen to fetch the full question and solution data dynamically from the backend.

