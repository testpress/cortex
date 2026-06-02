# dashboard-announcements Specification

## Purpose
TBD - created by archiving change integrate-announcements. Update Purpose after archive.
## Requirements
### Requirement: Fetch and Display Announcements
The system SHALL fetch real announcements from the `/api/v3/posts/` endpoint and display them in the dashboard's updates and announcements section.

#### Scenario: Successful fetch of announcements
- **WHEN** the dashboard is loaded and the device is online
- **THEN** the system fetches the posts and updates the UI with the latest announcements.

### Requirement: Display only Top 3 Announcements
The dashboard SHALL display a maximum of 3 announcement posts, taking only the most recent ones.

#### Scenario: More than 3 announcements exist
- **WHEN** the API returns more than 3 posts
- **THEN** the dashboard UI only renders the top 3 posts.

### Requirement: View All Screen Navigation
The dashboard SHALL provide a "View All" interaction that navigates the user to a screen where all announcements are visible.

#### Scenario: User taps View All
- **WHEN** the user taps the "View All" button on the announcements section
- **THEN** the app navigates to a new screen containing the complete list of announcements.

### Requirement: View Announcement Details
The system SHALL provide an announcement detail screen that renders the rich HTML content of an announcement and handles disabled comments visually.

#### Scenario: User taps an announcement
- **WHEN** the user taps an announcement card on the dashboard or list screen
- **THEN** the app navigates to the announcement detail screen.
- **AND** the app renders the HTML natively without webview elasticity.
- **AND** loading images display a full-width skeleton placeholder.
- **AND** if comments are disabled, a fixed warning banner is displayed at the bottom of the screen.

### Requirement: Cache Announcements
The system SHALL cache the fetched posts and categories in the local Drift database (`PostsTable` and `PostCategoriesTable`) for offline access.

#### Scenario: Device is offline
- **WHEN** the dashboard is loaded and the device is offline
- **THEN** the system displays the cached announcements from the Drift database.

