# whats-new-feed Specification

## Purpose
TBD - created by archiving change integrate-whats-new-section. Update Purpose after archive.
## Requirements
### Requirement: Unified What's New Feed
The system SHALL provide a unified feed of the latest content updates (Videos, Exams, Notes, etc.) across all courses available to the user.

#### Scenario: Metadata resolution from normalized response
- **WHEN** the system receives a normalized "What's New" response from the API
- **THEN** it MUST perform an in-memory lookup to resolve the Chapter Name and Course Title for each content item using the provided metadata lists.

#### Scenario: Content type icons and durations
- **WHEN** displaying a "What's New" item
- **THEN** it MUST show the correct icon based on `content_type` (e.g., Video ➔ Play icon, Exam ➔ Test icon)
- **AND** it MUST calculate the human-readable duration (e.g., "1h 30m") from the raw seconds provided in the video/exam metadata.

#### Scenario: Background background sync
- **WHEN** the user opens the dashboard
- **THEN** the system MUST trigger a background sync of the "What's New" feed
- **AND** it MUST update the local database cache with the fresh items while maintaining the API-defined order.

