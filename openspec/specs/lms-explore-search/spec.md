# Capability: Explore Search

## Purpose
Search and filtering logic specifically for the discovery flow in the Explore tab.

## Requirements

### Requirement: Global Discovery Search
The system SHALL provide a unified search bar in the Explore tab that allows users to search across courses, lessons, and topics.

#### Scenario: Real-time search feedback
- **WHEN** the user types in the search bar
- **THEN** the system SHOULD filter the dashboard sections to show results matching the query
- **AND** show a "No results found" state if no matches exist

### Requirement: Search Placeholder Context
The search bar MUST display a descriptive placeholder to guide user intent (e.g., "Search courses, lessons, topics…").

#### Scenario: Clearing search query
- **WHEN** the user manually clears the text in the search bar
- **THEN** the system SHALL reset the results and restore the original Explore dashboard state
