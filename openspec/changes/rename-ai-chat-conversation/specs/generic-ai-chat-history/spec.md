## ADDED Requirements

### Requirement: Inline Conversation Renaming in History Drawer
The history drawer SHALL provide an inline rename flow on conversation items triggered from the options menu or on drawer opening.

#### Scenario: Opening rename action from options menu
- **WHEN** the user taps "Rename" in the anchored options menu of a conversation item
- **THEN** the system SHALL replace the conversation title display with an inline `EditableText` input focused on the existing title.

#### Scenario: Opening history drawer with target conversation in rename mode
- **WHEN** the history drawer is opened with a target conversation ID requested for rename (e.g. from the active chat header rename action)
- **THEN** the system SHALL immediately initialize that target conversation item in inline rename mode with its title focused and pre-selected, without requiring the user to tap rename again in the drawer.

#### Scenario: Accessible inline text input semantics
- **WHEN** the inline rename input is displayed
- **THEN** it SHALL provide an accessible semantic label for screen readers and apply design tokens from context for primary cursor and selection colors.

#### Scenario: Submitting inline rename
- **WHEN** the user submits the new title via keyboard Done or focus blur
- **THEN** the system SHALL sanitize the text and call the controller to rename the conversation, updating the displayed title upon success.

#### Scenario: Cancelling inline rename
- **WHEN** the user presses Escape or clears the title
- **THEN** the system SHALL revert the inline editing state without submitting.

#### Scenario: In-flight generation protection
- **WHEN** the user taps "Rename" for a conversation whose response is currently generating
- **THEN** the system SHALL disallow entering rename mode and display a warning toast message.
