## MODIFIED Requirements

### Requirement: Global Discovery Search
The system SHALL provide a unified search bar in the Explore tab that allows users to search across store products by title.

#### Scenario: Real-time search feedback
- **WHEN** the user types in the search bar
- **THEN** the system SHOULD filter the store products to show results matching the query (using the `search` query parameter on `/api/v3/products/`)
- **AND** show a "No results found" state if no matches exist

### Requirement: Search Placeholder Context
The search bar MUST display a descriptive placeholder to guide user intent (e.g., "Search for courses and bundles...").

#### Scenario: Clearing search query
- **WHEN** the user manually clears the text in the search bar
- **THEN** the system SHALL reset the results and restore the original store products
