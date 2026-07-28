## ADDED Requirements

### Requirement: Unified Semantic Typography
The system SHALL resolve all text elements on the dashboard home screen components primarily through semantic `AppText` constructors to enforce typographic consistency.

#### Scenario: Dashboard text components rendering
- **WHEN** rendering category section headers, card titles, chapter subtitles, metadata captions, or progress badges on the home screen
- **THEN** they MUST be built using the respective `AppText` semantic constructor (e.g., `AppText.title`, `AppText.cardTitle`, `AppText.cardSubtitle`, `AppText.cardCaption`, `AppText.labelSmall`)
- **AND** they MUST NOT use raw `Text` widgets with manual style configurations.
