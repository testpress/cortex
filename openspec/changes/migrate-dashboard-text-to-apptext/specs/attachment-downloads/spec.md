## ADDED Requirements

### Requirement: Unified Semantic Typography
The system SHALL resolve all text elements on the downloads screen and attachment viewer primarily through semantic `AppText` constructors to enforce typographic consistency.

#### Scenario: Downloads and attachment elements rendering
- **WHEN** rendering SnackBar messages, duration labels, file type badges, titles, and download progress / status labels
- **THEN** they MUST be built using the respective `AppText` semantic constructor (e.g., `AppText.body`, `AppText.labelSmall`, `AppText.title`, `AppText.caption`, `AppText.bodySmall`)
- **AND** they MUST NOT use raw `Text` widgets with manual style configurations.
