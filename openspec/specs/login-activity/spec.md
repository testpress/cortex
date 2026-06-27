# login-activity Specification

## Purpose
TBD - created by archiving change add-login-activity. Update Purpose after archive.
## Requirements
### Requirement: Display paginated login activity
The system SHALL fetch and display a paginated list of login sessions from the user's account without persisting them locally.

#### Scenario: View login activity list
- **WHEN** the user opens the Login Activity screen
- **THEN** the system fetches the first page of login sessions and displays them in a list.

#### Scenario: Load more login activity
- **WHEN** the user scrolls to the bottom of the list
- **THEN** the system fetches the next page of login sessions and appends them to the list.

### Requirement: Display session details
The system SHALL display specific device and session details for each login activity entry.

#### Scenario: Render session item
- **WHEN** a login session is displayed
- **THEN** the system shows an appropriate device icon, the OS and Browser, Location, IP Address, and the formatted date/time of last use.

### Requirement: Indicate current session
The system SHALL differentiate the session that corresponds to the device currently being used.

#### Scenario: Highlight current device
- **WHEN** a login session has `current_device` set to true
- **THEN** the system visually distinguishes it (e.g., highlighting or marking as the current device).

