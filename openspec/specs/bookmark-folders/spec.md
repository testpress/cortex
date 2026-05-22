# bookmark-folders Specification

## Purpose
This capability enables users to organize bookmarked lessons into user-defined bookmark folders (playlists) and the default "Uncategorized" folder. It supports loading lists of existing folders, adding or removing lessons, creating new folders with dynamic dialog overlay UI, and instant feedback.

## Requirements

### Requirement: List Folders in Bottom Sheet
The system SHALL retrieve all bookmark folders and render them in a premium floating card bottom sheet (matching the styling, handle bar, and rounded corners of the Logout sheet, with no close button in the header).

#### Scenario: Display folders list
- **WHEN** the bookmark folders stream is watched in the repository
- **THEN** the repository SHALL automatically trigger a background network sync to refresh folders from the server without blocking the stream
- **AND** the system SHALL immediately yield cached folders from the local database
- **AND** update the stream seamlessly once the remote refresh updates the database
- **AND** a visible scrollbar SHALL be shown on the right side of the folders list to indicate scrollability.

### Requirement: Create Custom Folder
The system SHALL provide a "+ Create new folder" action button in the bottom sheet. When tapped, it SHALL close the bookmark bottom sheet and open a premium modal dialog overlay centered on the screen, asking the user for a folder name.

#### Scenario: Successfully create new folder
- **WHEN** the user inputs a name and confirms creation of a new folder via the "Save" action on the dialog modal
- **THEN** the system SHALL send a creation request to the server
- **AND** save the new folder to the database
- **AND** automatically select it for the current lesson
- **AND** the dialog modal SHALL close automatically.

#### Scenario: Dialog Layout, Validation, and Keyboard Interaction
- **WHEN** the "Create new folder" modal is shown
- **THEN** the modal SHALL render one input field with label "Enter Folder name"
- AND a row of "Cancel" and "Save" buttons underneath it, taking up equal width (expanded) in the row and having the same height (52)
- AND the "Save" button SHALL be styled in the primary color (using design accent2 background when enabled, and accent2 with 50% opacity/alpha when disabled, and white textInverse)
- AND the "Save" button SHALL always be visible, rendering in a disabled state initially, and becoming enabled when a non-empty folder name has been typed in the input field
- AND the "Cancel" button SHALL be styled in a neutral style with a filled light-gray background (using design surfaceVariant), dark text (using design textPrimary), and no visible border color (completely transparent)
- **AND** the dialog SHALL automatically adjust its layout based on the software keyboard's height to prevent the keyboard from overlapping the input area.

### Requirement: Bookmark Folder Selection & Toast Feedback
The system SHALL sync folder selection actions immediately. The entire folder row SHALL act as a single gesture target. To maximize tap surface and visual cleanliness, checkboxes SHALL be removed. Instead, folder selection status SHALL be displayed by highlighting the folder icon and title text in primary color with a bold font weight. Tapping any folder row SHALL instantly close the bottom sheet (YouTube-like workflow) and execute the operation asynchronously in the background. Once completed, a premium dark capsule toast notification SHALL float at the bottom of the screen to notify the user.

#### Scenario: Select a folder
- **WHEN** the user taps an unselected folder row
- **THEN** the system SHALL instantly close the bottom sheet
- **AND** execute the bookmark POST request to the server in the background
- **AND** update the local database with the new bookmark details
- **AND** upon successful completion, display a premium dark capsule toast confirming "Added bookmark to [Folder Name]"
- **AND** if the request fails, display a premium error toast "Failed to update bookmark. Please try again.".

#### Scenario: Deselect a folder
- **WHEN** the user taps a selected folder row
- **THEN** the system SHALL instantly close the bottom sheet
- **AND** execute the bookmark DELETE request to the server in the background
- **AND** delete the bookmark from the local database
- **AND** upon successful completion, display a premium dark capsule toast confirming "Removed bookmark from [Folder Name]"
- **AND** if the request fails, display a premium error toast "Failed to update bookmark. Please try again.".
