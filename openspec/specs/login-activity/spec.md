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

### Requirement: Log out other devices button visual spacing
The "Log out other devices" button SHALL have sufficient bottom padding to remain fully visible above the device's system UI (home indicator or gesture bar), using the same spacing convention as other bottom-anchored primary action buttons in the app.

#### Scenario: Button visible above home indicator
- **WHEN** the Login Activity screen is displayed on a device with a bottom gesture bar or home indicator
- **THEN** the "Log out other devices" button SHALL be positioned fully above the system UI area with consistent bottom spacing

#### Scenario: Button spacing on devices without a gesture bar
- **WHEN** the Login Activity screen is displayed on a device without a bottom gesture bar
- **THEN** the "Log out other devices" button SHALL retain its standard bottom spacing, identical to other primary action buttons

