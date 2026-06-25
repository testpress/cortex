# doubts-ui Specification

## Purpose
TBD - created by archiving change lms-doubts-list. Update Purpose after archive.
## Requirements
### Requirement: UI-only Search Bar
The Doubts List SHALL include a search bar and type filter chips that query the backend to filter doubts by keyword and query type.
- **Interaction**: Selecting a type filter chip (ALL, AI, MENTOR) SHALL trigger a fetch from the backend `GET /api/v3/helpdesk/?query_type=<type>` and update the displayed doubts.

#### Scenario: Searching doubts
- **GIVEN** the user is on the Doubts List screen
- **WHEN** they enter a query in the search bar
- **THEN** the list of doubts matching the search query is fetched and displayed

#### Scenario: Filtering doubts by type
- **GIVEN** the user is on the Doubts List screen
- **WHEN** they tap the "AI" filter chip
- **THEN** the list of doubts matching the "AI" query type is fetched and displayed

### Requirement: Status Indication
The system SHALL display a high-visibility "Unanswered" badge for doubts where the last activity was a student post or where no mentor has responded.

#### Scenario: Unanswered Badge Visibility
- **GIVEN** a doubt has no mentor replies
- **WHEN** the doubt is displayed in the list
- **THEN** an "Unanswered" badge SHALL be visible on the card

