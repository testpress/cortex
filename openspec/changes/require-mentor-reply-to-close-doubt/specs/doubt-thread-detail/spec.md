## MODIFIED Requirements

### Requirement: Mark Resolved Action
The doubt thread detail screen SHALL provide an action for the student to resolve/close their doubt ONLY when the doubt has received at least one reply from a mentor (`isMentor == true`).
- **Eligibility**: If no reply with `isMentor == true` exists in the reply thread, the close/resolve action SHALL NOT be accessible to the student.
- **Action**: When eligible and active (not already closed), selecting the close doubt action and confirming SHALL submit the close request and update the status in the UI to closed.

#### Scenario: Attempting to close doubt without mentor reply
- **GIVEN** a student is viewing their active doubt details
- **AND** there are no replies with `isMentor == true` in the thread
- **WHEN** the student views the header actions
- **THEN** the close doubt action is not accessible

#### Scenario: Resolving a doubt after mentor reply
- **GIVEN** a student is viewing their active doubt details
- **AND** there is at least one reply with `isMentor == true` in the thread
- **WHEN** the student triggers the close action and confirms
- **THEN** the doubt close request is submitted and the status transitions to closed
