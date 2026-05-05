## ADDED Requirements

### Requirement: Recently Completed Feed Integration
The system SHALL provide a feed of content items recently finished by the user from the `/api/v2.4/completed/` endpoint.

#### Scenario: Mapping Completed Content
- **WHEN** the system receives a "Completed" response from the API
- **THEN** it MUST perform an in-memory lookup to resolve the Chapter Name for each content item using the provided `chapters` list.
- **AND** it MUST set the progress to 100.0 for all items in this section.

#### Scenario: Metadata and UI State
- **WHEN** displaying a "Recently Completed" item
- **THEN** it MUST show the 100% progress badge in the top right corner.
- **AND** it MUST show the full progress bar at the bottom of the card.
- **AND** it MUST display the chapter name as the subtitle.

#### Scenario: Background Synchronization
- **WHEN** the user opens the dashboard
- **THEN** the system MUST trigger a background sync for the "Recently Completed" feed.
- **AND** it MUST update the local database cache under the `recentlyCompleted` section type.
