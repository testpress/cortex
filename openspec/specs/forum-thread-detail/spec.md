# forum-thread-detail Specification

## Purpose
TBD - created by archiving change lms-forum-thread. Update Purpose after archive.
## Requirements
### Requirement: Display Thread Content
The screen SHALL display the full title and body of the discussion thread at the top of the view.

#### Scenario: View Thread
- **WHEN** a user navigates to a thread detail screen from the listing
- **THEN** the original question's full description and author metadata are shown.

### Requirement: Chronological Reply List
Replies to the thread SHALL be displayed in a list sorted by their creation date.

#### Scenario: Display Comments
- **WHEN** the thread detail screen loads
- **THEN** it fetches and displays all related forum comments beneath the main thread content.

### Requirement: Moderation Status Display
The system SHALL display a "Pending Moderation" badge or label next to the timestamp for comments that have not been approved (`isPublic = false`).

#### Scenario: Display pending moderation badge
- **WHEN** a user views a thread with a comment where `is_public` is false
- **THEN** the UI displays the comment with a "Pending Moderation" badge next to its timestamp.

### Requirement: On-Demand Thread Fetching
The provider SHALL fetch the thread data from the network if it does not exist in the local database.

#### Scenario: Navigate to uncached thread
- **WHEN** the detail screen requests a thread by slug that is missing locally
- **THEN** it fetches the thread via `GET /api/v2.5/discussions/<slug>/` and caches it before displaying.

