## ADDED Requirements

### Requirement: Unified Global Feed
The system SHALL display a unified global feed of discussion threads by default, fetching threads across all categories and courses using `GET /api/v2.5/discussions/`.

#### Scenario: User opens the forum
- **WHEN** the user navigates to the Discussion Forum from the main menu
- **THEN** the system SHALL display `ForumPostsListScreen` directly without course selection
- **AND** the system SHALL fetch threads lazily using pagination

### Requirement: Global Feed Route Shape
The system SHALL use a simplified route structure for forum browsing.

#### Scenario: Route entry and detail navigation
- **WHEN** a user opens forum from main navigation
- **THEN** the route SHALL be `/home/discussions/forum`
- **AND WHEN** a thread is opened
- **THEN** the route SHALL be `/home/discussions/forum/posts/:slug`

### Requirement: Global Feed Offline Caching
The system SHALL cache global feed threads locally using Drift to ensure offline availability and persistence across sessions.

#### Scenario: Feed data persistence
- **WHEN** the system fetches threads from the network
- **THEN** it SHALL upsert those threads into the local Drift database
