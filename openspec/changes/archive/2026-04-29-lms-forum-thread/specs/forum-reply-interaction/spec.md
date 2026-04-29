## ADDED Requirements

### Requirement: Sticky Reply Input
A persistent input field SHALL be available at the bottom of the screen to allow users to type and send replies.

#### Scenario: Post a Reply
- **WHEN** a student enters text in the reply field and clicks send
- **THEN** the reply is added to the thread (simulated in mock data) and appears in the list.

### Requirement: Interactive Reply Button
The "Reply" button SHALL be clearly visible and accessible from anywhere in the thread detail view.

#### Scenario: Click Reply Input
- **WHEN** the user taps the reply input or the "Reply" indicator
- **THEN** the keyboard opens and focus is set to the text input field.
