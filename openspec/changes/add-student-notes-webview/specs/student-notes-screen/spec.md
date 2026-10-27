## ADDED Requirements

### Requirement: Navigation to Student Notes Screen
The system SHALL expose a "Notes" option in the main navigation drawer (`DashboardDrawer`) when student notes are enabled for the institute, and register the route `/student-notes`.

#### Scenario: Notes option visible in drawer
- **WHEN** the dashboard drawer is open and `studentNotesEnabled` in `InstituteSettings` is `true`
- **THEN** the drawer displays the Notes item with an appropriate icon and label (`studentNotesLabel` or localized `drawerNotes`)

#### Scenario: Notes option hidden in drawer
- **WHEN** the dashboard drawer is open and `studentNotesEnabled` in `InstituteSettings` is `false`
- **THEN** the drawer does not display the Notes item

#### Scenario: Tapping Notes drawer item
- **WHEN** the user taps the Notes item in the dashboard drawer
- **THEN** the drawer closes
- **AND** the app navigates to `/student-notes`

### Requirement: Student Notes Presigned SSO URL Resolution
The system SHALL resolve a presigned single sign-on URL using `UserRepository.getAuthenticatedSsoUrl()` and format it with destination `/student-diary/my-notes/?testpress_app=1` and the active institute domain.

#### Scenario: Successful URL resolution with custom domain
- **WHEN** `studentNotesUrlProvider` is invoked with an institute containing custom domain `https://learn.example.com`
- **THEN** `UserRepository.getAuthenticatedSsoUrl()` resolves the presigned SSO path and returns `https://learn.example.com<sso_path>?next=%2Fstudent-diary%2Fmy-notes%2F%3Ftestpress_app%3D1`

#### Scenario: Fallback to API base URL domain
- **WHEN** `studentNotesUrlProvider` is invoked and the institute has no custom domain
- **THEN** `UserRepository.getAuthenticatedSsoUrl()` uses the scheme and host from `AppConfig.apiBaseUrl` as the base domain

### Requirement: Student Notes WebView Authorization and Capabilities
The system SHALL embed `AppWebView` inside `StudentNotesScreen` to display the resolved notes page, supporting file attachments and camera access.

#### Scenario: Loading state display
- **WHEN** the presigned SSO URL is being fetched
- **THEN** `StudentNotesScreen` displays `AppLoadingIndicator` centered on screen

#### Scenario: Error state and retry
- **WHEN** fetching the SSO URL fails due to network error
- **THEN** `StudentNotesScreen` displays an error view with a retry action

#### Scenario: WebView page rendered
- **WHEN** the SSO URL resolves successfully
- **THEN** `StudentNotesScreen` renders `AppWebView` pointing to the resolved URL with camera and storage permissions enabled

### Requirement: Layout, Header, and Back Navigation
`StudentNotesScreen` SHALL provide a header adhering to Cortex design standards with a back button and back navigation delegate for in-webview history.

#### Scenario: Header back button tapped
- **WHEN** the user taps the back button in `AppHeader`
- **THEN** the screen pops and returns to the previous view

#### Scenario: Device back gesture with web navigation history
- **WHEN** the user presses the system back button or initiates a back gesture and the web view `canGoBack()` is true
- **THEN** the web view navigates back to the preceding page in its internal history without popping `StudentNotesScreen`

#### Scenario: Device back gesture at top-level notes page
- **WHEN** the user presses the system back button and the web view cannot go back further
- **THEN** `StudentNotesScreen` pops and returns to the previous route

### Requirement: Attachment and External Link Delegation
`StudentNotesScreen` SHALL intercept navigation requests to prevent the embedded WebView from navigating to external hosts, launching them in the device's system browser instead.

#### Scenario: User taps external link
- **WHEN** a navigation request is initiated with a URL pointing to an external host
- **THEN** the WebView prevents in-app navigation
- **AND** the URL is launched via `url_launcher` in an external application
