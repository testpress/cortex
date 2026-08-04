## ADDED Requirements

### Requirement: Navigation to My Report
The system SHALL expose a "My report" option in the main navigation drawer (`DashboardDrawer`) when student reports are not disabled in the institute settings.

#### Scenario: Report option visible
- **WHEN** the dashboard drawer is open and `disableStudentReport` in `InstituteSettings` is false
- **THEN** the drawer displays the "My report" item with the localized label `drawerMyReport`

#### Scenario: Report option hidden
- **WHEN** the dashboard drawer is open and `disableStudentReport` in `InstituteSettings` is true
- **THEN** the drawer does not display the "My report" item

### Requirement: Report Page Authorization and Loading
The report screen SHALL load the student's report URL within an embedded web view (`AppWebView`) and automatically attach the active session JWT token to the authorization header.

#### Scenario: Load URL with auth headers
- **WHEN** the report screen is launched
- **THEN** the web view normalizes the URL and requests it with an `Authorization: JWT <token>` header

### Requirement: Layout and Navigation Header
The report screen SHALL display a custom navigation header styled after the offline and custom exam headers, featuring a back button and the localized screen title.

#### Scenario: Back button navigation
- **WHEN** the user taps the back button on the report screen
- **THEN** the navigator pops the report screen and returns the user to the previous view
