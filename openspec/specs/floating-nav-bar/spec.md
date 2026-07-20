# floating-nav-bar Specification

## Purpose
TBD - created by archiving change floating-bottom-nav-bar. Update Purpose after archive.
## Requirements
### Requirement: Floating Nav Bar Visual Design
The system SHALL render the bottom navigation bar as a floating element rather than a full-width bottom-anchored bar.

#### Scenario: Nav Bar appearance
- **WHEN** the bottom navigation bar is rendered
- **THEN** it MUST have rounded corners, a visible drop shadow, and margins separating it from the screen edges.

### Requirement: Content Overlap
The system SHALL allow main screen content to flow behind the floating navigation bar.

#### Scenario: Scrolling content
- **WHEN** the user scrolls a list in a tab
- **THEN** the content MUST scroll underneath the floating navigation bar.
- **AND** the bottom-most items MUST remain accessible via appropriate bottom padding.

