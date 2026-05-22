# unified-lesson-shell Specification

## Purpose
TBD - created by archiving change integrate-bookmark. Update Purpose after archive.
## Requirements
### Requirement: Bookmark Folder Sheet Trigger
Tapping the bookmark icon in the lesson details header SHALL display a playlist-style bookmark folders bottom sheet instead of performing a binary bookmark state toggle.

#### Scenario: User clicks bookmark button
- **WHEN** the user taps the bookmark icon in the lesson header
- **THEN** the system SHALL present the bookmark folders bottom sheet containing list of folders and "Uncategorized" option.

### Requirement: Bookmark State Visuals
The bookmark icon in the lesson details header SHALL render in an active (filled) state if the lesson is bookmarked (has a non-null `bookmarkId`), and in an inactive (outlined) state if the lesson is not bookmarked.

#### Scenario: Render bookmarked lesson
- **WHEN** a lesson detail is loaded with a non-null `bookmarkId`
- **THEN** the header bookmark icon SHALL be displayed as a filled icon.

