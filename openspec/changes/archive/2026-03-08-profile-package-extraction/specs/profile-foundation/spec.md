## ADDED Requirements

### Requirement: Standalone Identity Context
The `profile` package SHALL provide a standalone context for user identity, fetching data exclusively from the `data` package.

#### Scenario: Rendering profile with shared data
- **WHEN** the `ProfilePage` is initialized
- **THEN** it SHALL fetch the current user's identity (name, avatar, joined date) from the `AuthProvider` in the `data` package.
- **AND** it MUST NOT have any dependency on the `courses` package for this data.

### Requirement: Account Settings Management
The `profile` package SHALL host and manage all non-course-specific application settings.

#### Scenario: Toggling notification preferences
- **WHEN** the user interacts with the "Notifications" toggle in the profile settings
- **THEN** the system SHALL update the `notificationPreferencesProvider` hosted within the `profile` package.
- **AND** the state MUST be preserved for the duration of the session.
