## ADDED Requirements

### Requirement: Bookmarks navigation
The system SHALL provide a navigation entry point to the Bookmarks screen from within the main dashboard drawer.

#### Scenario: Navigate to Bookmarks screen
- **WHEN** the user opens the app drawer
- **THEN** the system displays a "Bookmarks" menu item
- **WHEN** the user taps the "Bookmarks" item
- **THEN** the system navigates to `/bookmarks` via GoRouter.

---

### Requirement: Folder drill-down navigation
The system SHALL support navigating to a filtered bookmark view for a specific folder.

#### Scenario: User taps a folder
- **WHEN** the user taps a folder item on the Bookmarks screen
- **THEN** the system pushes the Bookmarks screen again with the `folderName` parameter set, showing only bookmarks in that folder.
