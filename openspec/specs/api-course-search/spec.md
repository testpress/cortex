# api-course-search Specification

## Purpose
TBD - created by archiving change api-direct-course-search. Update Purpose after archive.
## Requirements
### Requirement: Server-Side Search
The system SHALL use the backend API to search for courses when a query is provided by the user.

#### Scenario: Search fetches from API
- **WHEN** the user types a query in the search bar
- **THEN** an API request is made with the search parameter to retrieve matching results

### Requirement: Search Result Non-Persistence
The system SHALL NOT persist search results into the local course database table dedicated to regular paginated listings.

#### Scenario: Search results remain ephemeral
- **WHEN** search results are received from the API
- **THEN** they are displayed in the UI but NOT saved to the local `coursesTable`

### Requirement: Search Debounce
The system SHALL debounce search inputs to prevent excessive API calls during typing.

#### Scenario: Rapid typing
- **WHEN** the user types "Swift" within 100ms
- **THEN** only one search request for "Swift" is eventually sent after the pause

