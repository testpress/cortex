## ADDED Requirements

### Requirement: Conversation Deletion Action and Confirmation
The history drawer SHALL provide a confirmation-gated delete action on conversation items.

#### Scenario: Display options action
- **WHEN** conversation history items are rendered in the history drawer
- **THEN** each item SHALL display an accessible options button (3 dots) with at least 48×48dp touch target.

#### Scenario: Opening conversation actions
- **WHEN** the user taps the options action on a conversation item
- **THEN** the system SHALL display an anchored contextual options menu positioned adjacent to the options button offering conversation options including deletion.

#### Scenario: Non-overlapping interactive semantics
- **WHEN** conversation history items are rendered with delete actions
- **THEN** the open-chat interaction and semantics SHALL be scoped to the title/timestamp area, preventing nested button semantics with the delete button.

#### Scenario: Confirming conversation deletion
- **WHEN** the user taps the delete action on a conversation item
- **THEN** the system SHALL display a confirmation dialog prompting the user before dispatching the deletion.

#### Scenario: Deletion attempted during active generation
- **WHEN** the user taps the delete action on a conversation while a response is actively generating for it
- **THEN** the system SHALL immediately display a warning toast without prompting for confirmation.

#### Scenario: Cancelling conversation deletion
- **WHEN** the user cancels the confirmation dialog
- **THEN** the conversation SHALL remain in the history list without making any network call.

#### Scenario: Successful deletion updates drawer
- **WHEN** deletion completes successfully
- **THEN** the conversation item SHALL be removed from the history list.
