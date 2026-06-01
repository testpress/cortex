# doubts-ui Specification

## Purpose
TBD - created by archiving change lms-doubts-list. Update Purpose after archive.
## Requirements
### Requirement: UI-only Search Bar
The Doubts List SHALL include a search bar that queries the backend to filter doubts by keyword.
- **Interaction**: Typing in the search bar and submitting SHALL trigger a fetch from the backend `GET /api/v3/helpdesk/?search=<query>` and update the displayed doubts.

#### Scenario: Searching doubts
- **GIVEN** the user is on the Doubts List screen
- **WHEN** they enter a query in the search bar
- **THEN** the list of doubts matching the search query is fetched and displayed

### Requirement: Status Indication
The system SHALL display a high-visibility "Unanswered" badge for doubts where the last activity was a student post or where no mentor has responded.

#### Scenario: Unanswered Badge Visibility
- **GIVEN** a doubt has no mentor replies
- **WHEN** the doubt is displayed in the list
- **THEN** an "Unanswered" badge SHALL be visible on the card

