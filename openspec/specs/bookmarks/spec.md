# bookmarks Specification

## Purpose
TBD - created by archiving change bookmark-screen. Update Purpose after archive.
## Requirements
### Requirement: Bookmarks Screen UI
The system SHALL display a Bookmarks screen built with the design system tokens.

#### Scenario: User views the Bookmarks screen
- **WHEN** the user navigates to Bookmarks
- **THEN** they see a tab bar (All / Folders), filter chips, content type and sort dropdowns, and a paginated list of bookmarks fetched from `GET /api/v2.4/bookmarks/`.

#### Scenario: User is loading bookmarks
- **WHEN** data is being fetched
- **THEN** skeleton loading placeholders are displayed.

#### Scenario: User has no bookmarks
- **WHEN** the API returns an empty list
- **THEN** an empty state message is shown.

---

### Requirement: Bookmark Navigation to Content
The system SHALL navigate to the appropriate Detail page based on the bookmark content type.

#### Scenario: User taps a lesson bookmark
- **WHEN** the user taps a bookmark of type video, attachment, pdf, html, etc.
- **THEN** the system navigates to the Content Detail page (`/study/lesson/<id>`).

#### Scenario: User taps a forum post bookmark
- **WHEN** the user taps a bookmark of type `forumpost`
- **THEN** the system navigates to the Forum Post Detail screen (`/home/discussions/forum/posts/<slug>`).

#### Scenario: User taps a question-type bookmark (from exam review)
- **WHEN** the user taps a bookmark of type `question` or `userselectedanswer`
- **AND** the bookmark has a locally-stored `attemptId`
- **THEN** the system fetches review items for that attempt, finds the question index, and pushes `ReviewAnswerDetailScreen` with `initialQuestionIndex` set to that question.

#### Scenario: User taps a question-type bookmark without attempt ID
- **WHEN** the user taps a bookmark of type `question` or `userselectedanswer`
- **AND** the bookmark does NOT have an `attemptId` (e.g., bookmarked from outside review)
- **THEN** the system safely ignores the tap (no-op).

#### Scenario: User taps an unsupported community bookmark
- **WHEN** the user taps a bookmark of type `post`, `exam`, or `notice`
- **THEN** the system safely ignores the tap (no-op) until detail routes exist for those types.

### Requirement: Bookmarks Filtering & Sorting
The system SHALL allow filtering by content type and sorting.

#### Scenario: User changes content type filter
- **WHEN** the user selects a content type (Questions, Videos, PDFs, etc.)
- **THEN** the system fetches and displays only bookmarks of that type.

#### Scenario: User changes sort order
- **WHEN** the user selects Recent, Oldest, or Lastly Opened
- **THEN** the system re-fetches and displays bookmarks in that order.

---

### Requirement: Folder Management
The system SHALL allow users to create, rename, and delete bookmark folders.

#### Scenario: User creates a folder
- **WHEN** the user taps the "+" FAB and submits a name
- **THEN** the system calls `POST /api/v2.4/folders/` and refreshes the folder list.

#### Scenario: User renames a folder
- **WHEN** the user selects "Rename Folder" from the folder menu
- **THEN** a bottom sheet pre-filled with the current name is shown and on submit calls `PATCH /api/v2.5/folders/{id}/`.

#### Scenario: User deletes a folder
- **WHEN** the user selects "Delete Folder" from the folder menu
- **THEN** a confirmation dialog is shown and on confirm calls `DELETE /api/v2.5/folders/{id}/`.

---

### Requirement: Localization
The system SHALL display all Bookmarks UI strings from the localization system (EN, ML, AR).

#### Scenario: User's device is set to a supported locale
- **WHEN** the user views the Bookmarks screen
- **THEN** all labels, tabs, filter options, action labels, and folder item counts are displayed in the user's locale.
- **AND** folder item count is grammatically pluralized (e.g., "1 item" vs "5 items").

---

### Requirement: Design Token Compliance
The system SHALL use only design system tokens for colors, spacing, and radii.

#### Scenario: Design token usage
- **WHEN** any component in the Bookmarks feature renders
- **THEN** all colors are sourced from `design.colors.*`, all padding from `design.spacing.*`, and all border radii from `design.radius.*`.
- **AND** no hardcoded hex colors or raw pixel values are present.

### Requirement: Community Post Visual Distinction
The system SHALL display distinct icons and shortcut palette colors for community post types (forumposts, notices, questions) in the bookmark list, rather than falling back to standard lesson themes.

#### Scenario: User views community bookmarks
- **WHEN** rendering a bookmark item
- **THEN** `forumpost` uses `LucideIcons.messageSquare` and index 3
- **AND** `post` uses `LucideIcons.fileText` and index 0
- **AND** `notice` uses `LucideIcons.bell` and index 2
- **AND** `question` uses `LucideIcons.helpCircle` and index 4.

