## MODIFIED Requirements

### Requirement: UI-only Search Bar
The Doubts List SHALL include a search bar that queries the backend to filter doubts by keyword.
- **Interaction**: Typing in the search bar and submitting SHALL trigger a fetch from the backend `GET /api/v3/helpdesk/?search=<query>` and update the displayed doubts.

#### Scenario: Searching doubts
- **GIVEN** the user is on the Doubts List screen
- **WHEN** they enter a query in the search bar
- **THEN** the list of doubts matching the search query is fetched and displayed
