## ADDED Requirements

### Requirement: Normalized Doubts Storage
The system SHALL store doubts and replies in separate normalized tables to ensure data integrity and support future rich-text/attachment expansion.

#### Scenario: Storing a Doubt with Replies
- **GIVEN** a student creates a doubt with multiple replies
- **WHEN** the data is persisted locally
- **THEN** the doubt SHALL be stored in the `doubts` table and replies in the `doubt_replies` table, linked by `doubtId`

### Requirement: Doubt Privacy
The system SHALL ensure that doubts are strictly private. A student SHALL only see doubts they have authored, and mentors SHALL see all doubts assigned to them.

#### Scenario: Private Visibility
- **GIVEN** Student A and Student B have asked separate doubts
- **WHEN** Student A fetches their doubts list
- **THEN** only Student A's doubts SHALL be returned; Student B's doubts SHALL NOT be visible
