## ADDED Requirements

### Requirement: Upstream Data Hydration (No UI Fetching)
The system SHALL NOT fetch missing chapter names directly from the UI or within the local database join method. Instead, the repository SHALL hydrate missing nested chapters via a non-blocking background fetch when a lesson is opened, ensuring that the database `innerJoin` works perfectly by the time the user opens the Ask a Doubt screen.

#### Scenario: Navigating from Dashboard / Resume Learning
- **WHEN** the user navigates directly to a lesson from a Dashboard widget (like Resume Learning) without first downloading the course chapter list
- **THEN** the system SHALL silently fetch the missing nested chapter in the background
- **AND** save it to the local SQLite database so the Ask Doubt context badge can render
