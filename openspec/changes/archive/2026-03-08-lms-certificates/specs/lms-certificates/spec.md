## ADDED Requirements

### Requirement: Certificates List Screen
The system SHALL provide a dedicated certificates screen that users can access from profile settings to review earned and in-progress certificates.

#### Scenario: Viewing certificates screen structure
- **WHEN** the certificates screen is opened
- **THEN** the system MUST render a back affordance, a page title, and supporting subtitle text
- **AND** the system MUST display a list of certificate cards

### Requirement: Certificate Card States and Actions
The system SHALL support unlocked and locked certificate card states with distinct content and actions.

#### Scenario: Rendering an unlocked certificate card
- **WHEN** a certificate is marked unlocked
- **THEN** the card MUST display completion date and certificate ID
- **AND** the card MUST provide actions to view certificate and download

#### Scenario: Rendering a locked certificate card
- **WHEN** a certificate is marked locked
- **THEN** the card MUST display progress percentage and progress indicator
- **AND** the card MUST provide a contextual continuation action

### Requirement: Certificate Preview Experience
The system SHALL provide a certificate preview view for unlocked certificates.

#### Scenario: Opening certificate preview
- **WHEN** the user selects "View Certificate" on an unlocked card
- **THEN** the system MUST open a certificate preview screen
- **AND** the preview MUST include learner name, course name, completion date, and certificate ID

#### Scenario: Closing certificate preview
- **WHEN** the user triggers close/back from the preview screen
- **THEN** the system MUST return to the certificates list screen

### Requirement: Profile-tab Certificates Routing
The system SHALL provide certificates routing within the profile tab flow without leaving primary navigation context.

#### Scenario: Opening certificates from profile settings
- **WHEN** the user selects "Your certificates" from profile settings actions
- **THEN** the system MUST navigate to the certificates screen within the Profile tab stack
- **AND** primary navigation context MUST remain visible

#### Scenario: Back navigation from certificates
- **WHEN** the user triggers back from certificates
- **THEN** the system MUST return to the previous Profile screen state
- **AND** other tab stacks MUST remain unchanged

### Requirement: Paid-Active Certificate Data Behavior
The system SHALL support paid-active certificates behavior with unlocked and in-progress entries.

#### Scenario: Paid-active list composition
- **WHEN** the user is in paid-active state
- **THEN** the screen MUST show at least one unlocked certificate and remaining in-progress/locked certificates
- **AND** only unlocked certificates MUST allow opening preview

### Requirement: Tokenized, Localized, and Accessible UI
The certificates flow SHALL use shared design tokens, localized copy, and accessibility semantics.

#### Scenario: Token and semantic compliance
- **WHEN** certificates list and preview screens are rendered
- **THEN** typography, spacing, colors, and radius MUST come from shared design tokens and semantic roles
- **AND** controls MUST expose semantic labels and satisfy minimum touch-target expectations

#### Scenario: Localized copy
- **WHEN** app locale changes
- **THEN** visible certificates and preview text MUST come from localization resources
