## ADDED Requirements

### Requirement: Student Access State Verification
The system SHALL verify the learner's AI Chat access policy and handle restricted student access state gracefully.

#### Scenario: Student has active generation permissions
- **WHEN** the session policy indicates `can_generate: true`
- **THEN** the system SHALL allow interactive message composer submissions.

#### Scenario: Student access is restricted
- **WHEN** the session policy indicates `can_generate: false` or access is rejected with a 403 authorization error
- **THEN** the system SHALL disable composer submissions and surface an access restricted notice in the AI workspace.
