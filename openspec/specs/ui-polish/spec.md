# ui-polish Specification

## Purpose
TBD - created by archiving change fix-ui-header-overflow. Update Purpose after archive.
## Requirements
### Requirement: Feature Header Alignment
The system SHALL align the back button in feature screen headers close to the left edge of the screen, bypassing the standard screen padding to ensure visual balance.

#### Scenario: Viewing a feature screen
- **WHEN** the user opens the Downloads, Bookmarks, or Ask Doubt screen
- **THEN** the back button appears with minimal left padding instead of the full screen margin

### Requirement: Doubt Card Layout Overflow Prevention
The system SHALL display the lesson title in the Ask Doubt list without right overflow, regardless of title length.

#### Scenario: Viewing a doubt with a long title
- **WHEN** a doubt item has a very long lesson title
- **THEN** the timeline is displayed next to the status badge, giving the lesson title full width

