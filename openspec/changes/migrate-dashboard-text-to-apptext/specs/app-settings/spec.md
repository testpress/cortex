## ADDED Requirements

### Requirement: Unified Semantic Typography
The system SHALL resolve app settings tag elements through semantic `AppText` constructors to enforce typographic consistency.

#### Scenario: Settings tag rendering
- **WHEN** displaying the recommended or default quality settings tag inside a widget span
- **THEN** it MUST use `AppText.labelSmall` with the appropriate design token styling overrides
- **AND** it MUST NOT use a raw `Text` widget with manual style configurations.

## MODIFIED Requirements

### Requirement: Accessibility Options
The system SHALL provide accessibility options to accommodate user preferences.

#### Scenario: Scaling Text
- **WHEN** user selects a text size (Small, Medium, or Large)
- **THEN** the system MUST update the global text scale factor to the corresponding value:
  - `0.85` for Small
  - `1.0` for Medium (Default)
  - `1.15` for Large
  and apply it to all text rendering across the application.

#### Scenario: Layout Adaptability to Text Scale
- **WHEN** the text size is scaled up
- **THEN** the cards in the "Resume Learning", "What's New", and "Recently Completed" carousels MUST adapt their height dynamically to prevent any layout clipping or bottom overflows.
