## Purpose

Provide a centralized screen and API integration for students to browse, search, and filter ongoing, upcoming, completed, and cancelled live classes using list and calendar interfaces.

## ADDED Requirements

### Requirement: Browse Live Classes
The system SHALL provide a unified interface displaying scheduled live classes, supporting both a sequential list layout and a monthly calendar layout.

#### Scenario: Toggling between list and calendar layouts
- **WHEN** the user navigates to the Live Classes screen
- **THEN** the system SHALL display the list of live classes by default and allow toggling to the calendar view to browse by date.

### Requirement: Status Filtering
The system SHALL allow users to filter live classes by their status, including Live, Upcoming, Completed, and Cancelled.

#### Scenario: Applying status filters
- **WHEN** the user selects a status chip filter (e.g., "Live")
- **THEN** the system SHALL filter the classes and display only those matching the selected status.

### Requirement: Offline Cache Synchronization
The system SHALL cache live classes in a local database and synchronize with the network in the background, serving the local cache as the single source of truth.

#### Scenario: Offline viewing of cached classes
- **WHEN** the user opens the Live Classes screen without active network connectivity
- **THEN** the system SHALL render the cached classes from the local database.

### Requirement: Design and Accessibility Compliance
All user interface elements SHALL comply with design tokens, provide appropriate accessibility semantics, and enforce touch target sizes of at least 48x48dp.

#### Scenario: Accessibility semantic nodes and touch target sizes
- **WHEN** the user navigates the Live Classes list or calendar
- **THEN** the interactive items SHALL expose appropriate accessibility labels and exceed 48x48dp in tap dimensions.

### Requirement: Navigation Drawer Integration
The navigation drawer SHALL include a dedicated menu option to open the Live Classes interface.

#### Scenario: Launching Live Classes from drawer
- **WHEN** the user opens the dashboard drawer and taps "Live Classes"
- **THEN** the system SHALL push the Live Classes screen onto the route stack and close the drawer.

### Requirement: Open Live Class Lobby View
Clicking on a live class item in either the calendar agenda or the list view SHALL fetch the class details from `/api/v3/live-classes/contents/{id}/` and navigate to the session lobby view.

#### Scenario: Navigating to live class lobby
- **WHEN** the user taps on a live class card
- **THEN** the system SHALL fetch the detailed live class metadata and open the lobby view (e.g., Fermion lobby or Zoom meeting lobby).
