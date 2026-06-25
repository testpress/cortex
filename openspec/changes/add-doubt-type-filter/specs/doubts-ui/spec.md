## MODIFIED Requirements

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
