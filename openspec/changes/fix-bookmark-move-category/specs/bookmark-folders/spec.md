## MODIFIED Requirements

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

#### Scenario: Move question or post bookmark to a folder
- **WHEN** the user taps an unselected folder row for a bookmarked question or post
- **THEN** the system SHALL map the category parameter to `'user_selected_answer'` or `'post'` respectively in the POST request to the server in the background
- **AND** successfully save the bookmark under the selected folder.

#### Scenario: Move cached bookmark to a folder
- **WHEN** the user moves a bookmark loaded from the local database cache
- **THEN** the system SHALL use `bookmarkType` as the category parameter
- **AND** send a non-empty category to the server in the background.

#### Scenario: Preserve bookmark title and metadata when moving to a folder
- **WHEN** the user moves an existing bookmark to a folder
- **THEN** the system SHALL retain the bookmark's existing title, chapterName, slug, and created timestamp in the local database
- **AND** the UI list SHALL instantly display the correct title without showing "Unknown" or "Unknown Lesson".

#### Scenario: Move folder deletes old bookmark
- **WHEN** the user selects a new folder for an already bookmarked item
- **THEN** the system SHALL remove the old bookmark from its previous folder
- **AND** create the new bookmark in the selected folder, preventing duplicate bookmarks in the list.

#### Scenario: Avoid Riverpod disposal crashes during moves
- **WHEN** the user selects a new folder and the bottom sheet is closed instantly
- **THEN** the system SHALL execute all background delete and create API calls using a stable provider container
- **AND** SHALL NOT crash or throw "Cannot use ref after the widget was disposed".
