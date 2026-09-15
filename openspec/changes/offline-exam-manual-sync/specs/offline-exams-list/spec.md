## MODIFIED Requirements

### Requirement: Offline exam list item actions
Each exam in the offline exams list SHALL display appropriate actions based on its current status. If the exam is in `DOWNLOADED` or `IN_PROGRESS` status, it SHALL display an "Open" action. If the exam is in `PENDING_SYNC` status, it SHALL display a "Sync" action instead of "Open". If the exam is in `SYNCED` status, it SHALL not display the "Sync" action.

#### Scenario: User opens a downloaded or in-progress exam
- **WHEN** the user taps the "Open" button on an exam with status `DOWNLOADED` or `IN_PROGRESS`
- **THEN** the system MUST navigate the user to the exam detail page for that exam

#### Scenario: User syncs a pending sync exam
- **WHEN** the user taps the "Sync" button on an exam with status `PENDING_SYNC`
- **THEN** the system MUST trigger the synchronization process for that exam, show a loading state on the button during sync, and show a success confirmation toast upon completion

#### Scenario: User deletes an offline exam
- **WHEN** the user taps the "Delete" button on an offline exam list item
- **THEN** the system MUST prompt for confirmation and remove the exam from local storage upon confirmation
