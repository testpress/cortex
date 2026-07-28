## ADDED Requirements

### Requirement: Unified Semantic Typography
The system SHALL resolve the Ask Doubt FAB text label through semantic `AppText` constructors to enforce typographic consistency.

#### Scenario: FAB label rendering
- **WHEN** the Ask Doubt FAB is rendered
- **THEN** the text label MUST use `AppText.labelBold`
- **AND** it MUST NOT use a raw `Text` widget.
