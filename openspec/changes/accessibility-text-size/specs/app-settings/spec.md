## MODIFIED Requirements

### Requirement: Accessibility Options

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
