## ADDED Requirements

### Requirement: On-Demand Thread Fetching
The provider SHALL fetch the thread data from the network if it does not exist in the local database.

#### Scenario: Navigate to uncached thread
- **WHEN** the detail screen requests a thread by slug that is missing locally
- **THEN** it fetches the thread via `GET /api/v2.5/discussions/<slug>/` and caches it before displaying.
