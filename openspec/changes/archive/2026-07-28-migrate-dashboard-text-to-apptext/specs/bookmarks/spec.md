## ADDED Requirements

### Requirement: Unified Semantic Typography
The system SHALL resolve all text elements on the bookmarks screen primarily through semantic `AppText` constructors to enforce typographic consistency.

#### Scenario: Bookmarks error rendering
- **WHEN** the bookmarks screen encounters an error
- **THEN** it MUST display the error message using `AppText.body`
- **AND** it MUST NOT use a raw `Text` widget.
