## MODIFIED Requirements

### Requirement: Bookmark Navigation to Content
The system SHALL navigate to the appropriate Detail page based on the bookmark content type.

#### Scenario: User taps a lesson bookmark
- **WHEN** the user taps a bookmark of type video, attachment, pdf, html, etc.
- **THEN** the system navigates to the Content Detail page (`/study/lesson/<id>`).

#### Scenario: User taps a forum post bookmark
- **WHEN** the user taps a bookmark of type `forumpost`
- **THEN** the system navigates to the Forum Post Detail screen (`/home/discussions/forum/posts/<slug>`).

#### Scenario: User taps an unsupported community bookmark
- **WHEN** the user taps a bookmark of type `post`, `exam`, `notice`, or `question`
- **THEN** the system safely ignores the tap (no-op) until detail routes exist for those types.

## ADDED Requirements

### Requirement: Community Post Visual Distinction
The system SHALL display distinct icons and shortcut palette colors for community post types (forumposts, notices, questions) in the bookmark list, rather than falling back to standard lesson themes.

#### Scenario: User views community bookmarks
- **WHEN** rendering a bookmark item
- **THEN** `forumpost` uses `LucideIcons.messageSquare` and index 3
- **AND** `post` uses `LucideIcons.fileText` and index 0
- **AND** `notice` uses `LucideIcons.bell` and index 2
- **AND** `question` uses `LucideIcons.helpCircle` and index 4.
