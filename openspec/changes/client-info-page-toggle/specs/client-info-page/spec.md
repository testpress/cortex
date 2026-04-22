## ADDED Requirements

### Requirement: Client-Gated Info Experience
The system SHALL keep the Info experience disabled by default and expose it only for clients whose configuration explicitly enables it.

#### Scenario: Feature disabled for the default client experience
- **WHEN** the client configuration does not enable the Info experience
- **THEN** the application MUST continue to expose the standard `Profile` tab label, icon, and destination
- **AND** the client-specific Info page MUST NOT be reachable from primary navigation

#### Scenario: Feature enabled for an eligible client
- **WHEN** the client configuration enables the Info experience
- **THEN** the application MUST expose the client-specific Info page from the primary navigation flow
- **AND** the Info experience MUST replace the standard profile destination only for that configured client variant

### Requirement: Info Resource Catalog
The system SHALL provide an Info landing page that lists curated learning-resource courses for enabled clients.

#### Scenario: Displaying the Info landing page
- **WHEN** an enabled client opens the Info tab
- **THEN** the system MUST render a resource list screen titled `Learning Resources`
- **AND** each resource card MUST show a thumbnail, course title, instructor name, subject label, video count, and total duration
- **AND** the list MUST support multiple curated courses in a vertically scrollable layout

### Requirement: Course Video Drill-In
The system SHALL let users open a course-specific video list from the Info landing page.

#### Scenario: Opening a resource course
- **WHEN** the user selects a course card from the Info landing page
- **THEN** the system MUST navigate to a course-detail view for that resource
- **AND** the detail view MUST show a back affordance, the selected course title, the instructor name, and the list of available videos

#### Scenario: Rendering the course video list
- **WHEN** the course-detail view is displayed
- **THEN** each video row MUST show a thumbnail, title, and duration
- **AND** the row MUST visually indicate that the video opens outside the app

### Requirement: External Video Launch
The system SHALL open Info videos using an external destination rather than inline playback.

#### Scenario: Opening a linked video
- **WHEN** the user selects a video from the course-detail view
- **THEN** the system MUST launch the configured external video URL
- **AND** the application MUST keep the Info navigation state available when the user returns

---

### Technical Note: Configuration
The "client configuration" mentioned in these requirements is implemented via the `ENABLE_INFO_PAGE` environment define. 
Use `--dart-define=ENABLE_INFO_PAGE=true` during `flutter run` or `flutter build` to satisfy the enablement criteria defined in these scenarios.
