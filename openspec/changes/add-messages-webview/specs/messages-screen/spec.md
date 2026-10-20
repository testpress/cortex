## ADDED Requirements

### Requirement: Navigation to Messages Screen
The system SHALL expose a "Messages" option in the main navigation drawer (`DashboardDrawer`) when messages are enabled for the institute, and register the route `/messages`.

#### Scenario: Messages option visible in drawer
- **WHEN** the dashboard drawer is open and `messagesEnabled` in `InstituteSettings` is `true`
- **THEN** the drawer displays the Messages item with an appropriate icon and label (`messagesLabel` or localized `drawerMessages`)

#### Scenario: Messages option hidden in drawer
- **WHEN** the dashboard drawer is open and `messagesEnabled` in `InstituteSettings` is `false`
- **THEN** the drawer does not display the Messages item

#### Scenario: Tapping Messages drawer item
- **WHEN** the user taps the Messages item in the dashboard drawer
- **THEN** the drawer closes
- **AND** the app navigates to `/messages`

### Requirement: Messages Presigned SSO URL Resolution
The system SHALL resolve a presigned single sign-on URL using `UserRepository.getPresignedSsoUrl()` and format it with the target destination `/messages/?testpress_app=1` and the active institute domain.

#### Scenario: Successful URL resolution with custom domain
- **WHEN** `messagesUrlProvider` is invoked with an institute containing custom domain `https://learn.example.com`
- **THEN** the provider resolves the presigned SSO path and returns `https://learn.example.com<sso_path>?next=%2Fmessages%2F%3Ftestpress_app%3D1`

#### Scenario: Fallback to API base URL domain
- **WHEN** `messagesUrlProvider` is invoked and the institute has no custom domain
- **THEN** the provider uses the scheme and host from `AppConfig.apiBaseUrl` as the base domain

### Requirement: Messages WebView Authorization and Capabilities
The system SHALL embed `AppWebView` inside `MessagesScreen` to display the resolved messaging page, supporting mobile user-agent identification, file/attachment pickers, and required hardware permissions.

#### Scenario: Loading state display
- **WHEN** the presigned SSO URL is being fetched
- **THEN** `MessagesScreen` displays `AppLoadingIndicator` centered on screen

#### Scenario: Error state and retry
- **WHEN** fetching the SSO URL fails due to network error
- **THEN** `MessagesScreen` displays an error view with a retry action

#### Scenario: WebView page rendered
- **WHEN** the SSO URL resolves successfully
- **THEN** `MessagesScreen` renders `AppWebView` pointing to the resolved URL with camera and storage permissions enabled

### Requirement: Layout, Header, and Back Navigation
`MessagesScreen` SHALL provide a header adhering to Cortex design standards with a back button and back navigation delegate for in-webview history.

#### Scenario: Header back button tapped
- **WHEN** the user taps the back button in `AppHeader`
- **THEN** the screen pops and returns to the previous view

#### Scenario: Device back gesture with web navigation history
- **WHEN** the user presses the system back button or initiates a back gesture and the web view `canGoBack()` is true
- **THEN** the web view navigates back to the preceding page in its internal history without popping `MessagesScreen`

#### Scenario: Device back gesture at top-level web page
- **WHEN** the user presses the system back button and the web view cannot go back further
- **THEN** `MessagesScreen` pops and returns to the previous route

### Requirement: Attachment and External Link Delegation
`MessagesScreen` SHALL intercept navigation requests to prevent the embedded WebView from loading external links or file attachments internally, launching them in the device's system browser/external application instead.

#### Scenario: User taps attachment or external link
- **WHEN** a navigation request is initiated with a URL that navigates away from the `/messages` route or points to an external host
- **THEN** the WebView prevents in-app navigation
- **AND** the URL is launched via `url_launcher` in an external application

