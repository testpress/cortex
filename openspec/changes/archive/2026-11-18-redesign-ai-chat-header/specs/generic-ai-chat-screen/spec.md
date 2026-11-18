## MODIFIED Requirements

### Requirement: Chat Header Navigation
The system SHALL provide a dedicated header with leading conversation history access, active conversation title display, and trailing action controls.

#### Scenario: User opens history menu from leading button
- **WHEN** the user taps the leading hamburger menu icon in the header
- **THEN** the system triggers the conversation history drawer.

#### Scenario: Active conversation title display
- **WHEN** an active conversation is selected or loaded
- **THEN** the system renders the conversation title beside the hamburger icon with single-line truncation.

#### Scenario: User taps New Chat action
- **WHEN** the user taps the New Chat compose button on the trailing edge of an active conversation header
- **THEN** the system resets the conversation canvas to a clean new chat.

#### Scenario: Empty new chat header actions
- **WHEN** the user is on the clean new chat landing screen
- **THEN** the system displays only the leading hamburger menu and default title without trailing new chat or overflow action buttons.

#### Scenario: User deletes active conversation from header overflow menu
- **WHEN** the user taps the 3-dot overflow menu on an active conversation and confirms deletion
- **THEN** the system permanently deletes the conversation and resets the chat canvas.
