## MODIFIED Requirements

### Requirement: Tokenized, Localized, and Accessible UI
The certificates flow SHALL use shared design tokens, localized copy, and accessibility semantics.

#### Scenario: Token and semantic compliance
- **WHEN** certificates list and preview screens are rendered
- **THEN** typography, spacing, colors, and radius MUST come from shared design tokens and semantic roles
- **AND** controls MUST expose semantic labels and satisfy minimum touch-target expectations

#### Scenario: Full-width button alignment in preview
- **WHEN** the certificate preview screen is rendered
- **THEN** the action buttons (Download and Share) MUST occupy the full available width of their respective layouts to ensure edge-to-edge alignment.

#### Scenario: Full-width button alignment in certificate card
- **WHEN** an unlocked certificate card is rendered
- **THEN** the "View Certificate" action button MUST occupy the full available width within its row, covering the space from the left edge to the download button.
