# Spec: lms-test-detail-refinement

## NEW Requirements

### Requirement: Test Submission Confirmation
The system SHALL provide a confirmation step before a test is finalized.

#### Scenario: Finish Request
- **WHEN** the user selects "Finish" on the test screen
- **THEN** the system SHALL display the `SubmitConfirmationDialog` as an overlay.
- **AND** it SHALL show the total count of answered and unanswered questions.

#### Scenario: Cancellation
- **WHEN** the user cancels the confirmation dialog
- **THEN** the system SHALL return the user to the active test question without submitting.

### Requirement: Success Overlay
The system SHALL display a submission success message using an overlay pattern.

#### Scenario: Successful Submission
- **WHEN** the user confirms the submission
- **THEN** the system SHALL display the `TestResultView` as an overlay.
- **AND** the background test UI SHALL remain visible but dimmed to preserve context.
- **AND** the system SHALL provide actions for "Review Answers" and "View Analytics".

### Requirement: UI Density & Sizing
The test interface components SHALL adhere to a refined, high-density layout.

#### Scenario: Overlay Scaling
- **WHEN** viewing submission overlays
- **THEN** they SHALL have a maximum width of 400px.
- **AND** they SHALL use scaled-down icons (24px) and headlines (20px) to maximize screen space.

#### Scenario: Content Sizing
- **WHEN** viewing questions and options
- **THEN** `OptionCard` SHALL use a 14px font size for text to improve readability in long lists.
- **AND** vertical padding SHALL be prioritized at `spacing.sm` for action elements.
