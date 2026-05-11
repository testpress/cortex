# doubts-ui Specification

## Purpose
TBD - created by archiving change lms-doubts-list. Update Purpose after archive.
## Requirements
### Requirement: UI-only Search Bar
The Doubts List SHALL include a top-level search bar for visual parity with other modules.
- **Scope**: Functionality is intentionally excluded from the current scope.
- **Interaction**: The search bar acts as a UI placeholder; it SHALL NOT trigger filtering or data updates.

#### Scenario: Visual Search Bar
- **GIVEN** the user is on the Doubts List screen
- **WHEN** they see the top area
- **THEN** a search bar SHALL be visible but typing in it SHALL NOT affect the list

### Requirement: Status Indication
The system SHALL display a high-visibility "Unanswered" badge for doubts where the last activity was a student post or where no mentor has responded.

#### Scenario: Unanswered Badge Visibility
- **GIVEN** a doubt has no mentor replies
- **WHEN** the doubt is displayed in the list
- **THEN** an "Unanswered" badge SHALL be visible on the card

