## ADDED Requirements

### Requirement: Semantic Typography Resolution
The system SHALL resolve widget text styles primarily through semantic `AppText` constructors that reflect the content's functional role, rather than atomic measurements.

#### Scenario: Dashboard Section Headers
- **WHEN** a dashboard section title (e.g., "Today's Schedule") is rendered
- **THEN** it MUST use the `AppText.title()` constructor (or equivalent internal semantic role)
- **AND** it MUST NOT use a hardcoded `fontSize`.

#### Scenario: Card-Level Hierarchy
- **WHEN** card-based components (Snapshot Cards, Course Cards) are rendered
- **THEN** they MUST use `AppText.subtitle()` for secondary titles and `AppText.bodySmall()` for metadata
- **AND** they MUST NOT specify manual pixel sizes.

#### Scenario: Display-Level Greeting
- **WHEN** the primary user greeting is rendered
- **THEN** it MUST use a `Display` or `Headline` level semantic style to establish visual priority.

#### Scenario: Exceptional Scale Usage
- **WHEN** rendering non-standard typography (e.g., large numerical stats)
- **THEN** the system MAY use atomic scale tokens (e.g., `AppText.xl3()`)
- **AND** the rationale MUST be documented in the code.
