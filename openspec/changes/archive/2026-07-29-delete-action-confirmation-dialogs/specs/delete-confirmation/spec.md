## ADDED Requirements

### Requirement: Show confirmation dialog before destructive actions
The system SHALL present a confirmation dialog asking for user confirmation before executing any user-triggered destructive actions such as deleting downloaded content, removing bookmarks, or closing doubts.

#### Scenario: User confirms deletion
- **WHEN** the user initiates a destructive action and taps "Delete" (or equivalent destructive action like "Remove" or "Close") on the confirmation dialog
- **THEN** the system executes the destructive action and dismisses the dialog

#### Scenario: User cancels deletion
- **WHEN** the user initiates a destructive action and taps "Cancel" (or dismisses the dialog)
- **THEN** the system cancels the destructive action, dismisses the dialog, and no data is lost
