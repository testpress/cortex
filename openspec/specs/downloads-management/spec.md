# downloads-management Specification

## Purpose
TBD - created by archiving change create-downloads-screen. Update Purpose after archive.
## Requirements
### Requirement: View Downloaded Videos
The system SHALL display a list of downloaded videos, including their thumbnail, title, course name, chapter name, file size, and duration.

#### Scenario: Displaying the video list
- **WHEN** the user selects the "Videos" tab in the Downloads screen
- **THEN** the system SHALL show a list of all downloaded videos with their respective metadata and thumbnails.

### Requirement: View Downloaded Attachments
The system SHALL display a list of downloaded attachments, including their file type icon, title, course name, chapter name, and file size.

#### Scenario: Displaying the attachment list
- **WHEN** the user selects the "Attachments" tab in the Downloads screen
- **THEN** the system SHALL show a list of all downloaded files with their respective metadata and icons.

### Requirement: Toggle between Videos and Attachments
The system SHALL provide a tabbed interface to switch between "Videos" and "Attachments" views.

#### Scenario: Switching tabs
- **WHEN** the user clicks on the "Attachments" tab while viewing "Videos"
- **THEN** the view SHALL update to show the list of downloaded attachments.

### Requirement: Display Storage Information
The system SHALL display a footer containing the total count of items and the total disk space consumed by the items in the currently active tab.

#### Scenario: Viewing storage usage
- **WHEN** the Downloads screen is active with content
- **THEN** a sticky footer SHALL be visible showing the total number of items and the aggregate size (e.g., "788 MB used").

### Requirement: Storage Persistence
The system SHALL persist all download records in a local database (`AppDatabase`).

#### Scenario: Persisting download state
- **WHEN** a download is started, paused, or completed
- **THEN** the local database SHALL be updated to reflect the new state.

### Requirement: Background Synchronization
The system SHALL synchronize the local database with the SDK state upon entering the Downloads screen.

#### Scenario: Triggering background sync
- **WHEN** the user navigates to the Downloads screen
- **THEN** the system SHALL trigger a background synchronization via `downloadsBootstrapProvider`.

### Requirement: Aesthetic Loading State (Shimmer)
The system SHALL display a high-fidelity shimmer effect using `Skeletonizer` during initial data load or synchronization.

#### Scenario: Displaying shimmer
- **WHEN** the screen is loading or a background sync is in progress with no cached data
- **THEN** the system SHALL show skeletonized cards with a smooth shimmer effect.
- **THEN** the Tab Bar SHALL remain visible but its text SHALL be skeletonized to hide intermediate counts.

### Requirement: Delete Downloaded Item
The system SHALL provide a delete action for each item in the download list.

#### Scenario: Deleting a download
- **WHEN** the user clicks the "Trash" icon on a downloaded item
- **THEN** the item SHALL be removed from the local database and the UI SHALL update reactively.

### Requirement: Empty State
The system SHALL display a centered empty state view only after initial synchronization is complete and no records exist.

#### Scenario: Displaying empty state
- **WHEN** there are no items in the database and the background sync has completed
- **THEN** the system SHALL show an illustration or icon with the message "No Videos Downloaded" or "No Attachments Downloaded".

