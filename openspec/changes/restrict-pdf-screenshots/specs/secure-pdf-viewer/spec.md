## ADDED Requirements

### Requirement: Prevent Screenshots During PDF View
The system SHALL prevent users from capturing screenshots while the PDF viewer is actively displayed on the screen.

#### Scenario: User attempts to take screenshot
- **WHEN** the user is viewing a PDF document
- **THEN** the operating system captures a blank screen or a protected screen overlay instead of the actual PDF content

### Requirement: Protect App Switcher View
The system SHALL display a secure overlay (e.g., solid color or blur) when the app is moved to the background while the PDF viewer is active.

#### Scenario: User backgrounds the app
- **WHEN** the user pushes the app to the background (app switcher/recents view) while viewing a PDF
- **THEN** the app preview in the switcher is obscured to prevent sensitive content from being readable
